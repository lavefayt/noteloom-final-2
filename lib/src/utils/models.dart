import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:school_app/src/utils/firebase.dart';

class UserModel {
  final String? id;
  final String username;
  final String name;
  final String email;
  final String universityId;
  String? department;
  String? course;
  List<String> recents;
  List<String>? prioritySubjects;

  UserModel(
      {this.id,
      required this.email,
      required this.name,
      required this.universityId,
      required this.username,
      this.course,
      this.department,
      required this.recents,
      this.prioritySubjects});

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, options) {
    final data = snapshot.data();
    final id = snapshot.id;

    final fromFirebase = UserModel(
        id: id,
        email: data?['email'],
        username: data?['username'],
        name: data?['name'],
        universityId: data?['universityId'],
        course: data?['course'],
        department: data?['department'],
        recents: data?['recents']?.cast<String>() ?? <String>[],
        prioritySubjects: data?['prioritySubjects']?.cast<String>() ?? []);
    return fromFirebase;
  }

  factory UserModel.fromMap(Map<String, dynamic>? data) {
    return UserModel(
        id: data?['id'] ?? Auth.currentUser!.uid,
        email: data?['email'],
        username: data?['username'],
        name: data?['name'],
        universityId: data?['universityId'],
        course: data?['course'],
        department: data?['department'],
        recents: data?['recents'].cast<String>() ?? <String>[],
        prioritySubjects: data?['prioritySubjects'].cast<String>() ?? []);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "username": username,
      "name": name,
      "universityId": universityId,
      if (department != null) "department": department,
      if (course != null) "course": course,
      "recents": recents,
      if (prioritySubjects != null) "prioritySubjects": prioritySubjects
    };
  }

  void setRecents(List<String> newRecents) {
    recents = newRecents;
  }

  void setPrioritySubjects(List<String> newPrioritySubjects) {
    prioritySubjects = newPrioritySubjects;
  }
}

class UniversityModel {
  final String id;
  final String name;
  final String? storageLogoPath;
  final List<String>? subjectIds;
  final List<DepartmentModel>? departmentIds;

  UniversityModel(
      {required this.id,
      required this.name,
      this.storageLogoPath,
      this.subjectIds,
      this.departmentIds});

  factory UniversityModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, options) {
    final data = snapshot.data();
    final id = snapshot.id;

    final university = UniversityModel(
        id: id,
        name: data?['name'],
        storageLogoPath: data?['storageLogoPath'],
        subjectIds: data?['subjectIds']?.cast<String>(),
        departmentIds: data?['departmentIds']?.cast<String>());

    return university;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      if (storageLogoPath != null) "storageLogoPath": storageLogoPath,
      if (subjectIds != null) "subjectIds": subjectIds,
      if (departmentIds != null) "departmentIds": departmentIds
    };
  }
}

class DepartmentModel {
  final String id;
  final String name;
  final DocumentReference<UniversityModel>? universityRef;

  DepartmentModel({
    required this.id,
    required this.name,
    this.universityRef,
  });

  factory DepartmentModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, options) {
    final data = snapshot.data();
    final id = snapshot.id;

    final department = DepartmentModel(
      id: id,
      name: data?['name'],
      universityRef: data?["universityRef"],
    );

    return department;
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name, "universityRef": universityRef};
  }
}

class CourseModel {
  final String id;
  final String name;

  CourseModel({
    required this.id,
    required this.name,
  });

  factory CourseModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, options) {
    final data = snapshot.data();
    final id = snapshot.id;

    final course = CourseModel(
      id: id,
      name: data?['name'],
    );

    return course;
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name};
  }
}

abstract class Results {}

class SubjectModel extends Results {
  String? id;
  String subject;
  String subjectCode;
  String? universityId;

  SubjectModel({
    this.id,
    required this.subject,
    required this.subjectCode,
    required this.universityId,
  });

  factory SubjectModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, options) {
    final data = snapshot.data();
    final id = snapshot.id;

    if (kDebugMode) print(id);

    return SubjectModel(
      id: id,
      subject: data?['subject'],
      subjectCode: data?['subject code'],
      universityId: data?['universityId'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "subject": subject,
      "subject code": subjectCode,
      if (universityId != null) "universityId": universityId,
    };
  }
}

class NoteModel extends Results {
  String? id;
  String schoolId;
  String name;
  String author;
  String subjectId;
  String subjectName;
  String time;
  String storagePath;
  List<String>? tags;
  List<String?>? peopleLiked;
  String? summary;

  NoteModel(
      {this.id,
      required this.schoolId,
      required this.name,
      required this.subjectId,
      required this.subjectName,
      required this.time,
      required this.storagePath,
      required this.author,
      this.tags,
      this.peopleLiked,
      this.summary});

  factory NoteModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, __) {
    final data = snapshot.data();
    final id = snapshot.id;

    final note = NoteModel(
        id: id,
        schoolId: data?['schoolId'],
        name: data?['name'],
        author: data?['author'],
        subjectId: data?['subjectId'],
        subjectName: data?['subjectName'],
        time: data?['time'],
        storagePath: data?['storagePath'],
        tags: data?['tags'].cast<String>(),
        summary: data?['summary'],
        peopleLiked: data?['peopleLiked']?.cast<String>());

    return note;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "author": author,
      "schoolId": schoolId,
      "subjectId": subjectId,
      "subjectName": subjectName,
      "time": DateTime.now().toString(),
      "storagePath": storagePath,
      if (tags != null) "tags": tags,
      if (summary != null) "summary": summary,
      if (peopleLiked != null) "peopleLiked": peopleLiked
    };
  }

  void editFields(String newName, String newSubjectId, String newSubjectName,
      String? newSummary, List<String>? newTags) {
    name = newName;
    subjectId = newSubjectId;
    subjectName = newSubjectName;
    summary = newSummary;
    tags = newTags;
  }
}

class MessageModel {
  String? id;
  String message;
  String senderId;
  String senderUserProfileURL;
  String senderUsername;
  Timestamp timestamp;
  String? noteId;

  MessageModel(
      {this.id,
      required this.message,
      required this.senderId,
      this.senderUserProfileURL = "",
      required this.senderUsername,
      required this.timestamp,
      this.noteId});

  factory MessageModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    final data = snapshot.data();
    final id = snapshot.id;

    final message = MessageModel(
        id: id,
        message: data?['message'],
        senderId: data?['senderId'],
        senderUserProfileURL: data?['senderUserProfileURL'] ?? "",
        senderUsername: data?['senderUsername'],
        timestamp: data?['timestamp'],
        noteId: data?['noteId'] ?? "");
    return message;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "message": message,
      "senderId": senderId,
      "senderUserProfileURL": senderUserProfileURL,
      "senderUsername": senderUsername,
      "timestamp": timestamp,
      if (noteId != null) "noteId": noteId
    };
  }
}

class SavedNoteModel {
  String? id;
  String noteid;
  DateTime date;

  SavedNoteModel({this.id, required this.noteid, required this.date});

  factory SavedNoteModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    final data = snapshot.data();
    final id = snapshot.id;

    final likedNoteData = SavedNoteModel(
        id: id,
        noteid: data?['noteid'],
        date: data?['date']?.toDate() as DateTime);

    return likedNoteData;
  }

  Map<String, dynamic> toFirestore() {
    return {if (id != null) "id": id, "noteid": noteid, "date": date};
  }
}
