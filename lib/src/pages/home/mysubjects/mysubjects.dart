import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/src/components/uicomponents.dart';
import 'package:school_app/src/utils/models.dart';
import 'package:school_app/src/utils/providers.dart';

class PrioritySubjects extends StatefulWidget {
  const PrioritySubjects({super.key});

  @override
  State<PrioritySubjects> createState() => _PrioritySubjectsState();
}

List<Color> colors = const [
  Color.fromRGBO(255, 255, 204, 1), // Pale Yellow (#FFFFCC)
  Color.fromRGBO(255, 204, 204, 1), // Light Coral (#FFCCCC)
  Color.fromRGBO(204, 255, 204, 1), // Soft Mint Green (#CCFFCC)
  Color.fromRGBO(135, 206, 250, 1), // Light Sky Blue (#87CEFA)
];

class _PrioritySubjectsState extends State<PrioritySubjects> {
  late SearchController _searchController;
  List<SubjectModel?> _allPrioritySubjects = [];
  List<SubjectModel?> _filteredSubjects = [];

  @override
  void initState() {
    _searchController = SearchController();
    _searchController.addListener(() {
      setState(() {
        filterResults();
      });
    });
    super.initState();
  }

  void filterResults() {
    final lowerSearchText = _searchController.text.toLowerCase();

    final filteredSubjects = _allPrioritySubjects.where((subject) {
      if (subject == null) return false;

      // filter by name, subject name, and tags
      if (subject.subject.toLowerCase().contains(lowerSearchText) ||
          subject.subjectCode.toLowerCase().contains(lowerSearchText)) {
        return true;
      }

      return false;
    });

    _filteredSubjects = filteredSubjects.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, QueryNotesProvider>(
      builder: (context, userdata, notes, child) {
        final userPrioritySubjects = userdata.readPrioritySubjects;

        if (userPrioritySubjects.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "You currently don't have any priority subjects.\nTo add, search a subject and add as priority.",
                ),
              ),
            ),
          );
        }

        _allPrioritySubjects = userPrioritySubjects
            .map((subjectId) => notes.findSubject(subjectId))
            .toList();

        filterResults();

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: mySearchBar(
                  context, _searchController, "Search your Priority Subjects"),
              centerTitle: true, 
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE0F7FA),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(45),
              ),
            ),
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: _filteredSubjects.length,
              itemBuilder: (context, index) {
                final subject = _filteredSubjects[index];
                if (subject == null) {
                  return const Center(
                    child: Text("Subject not found"),
                  );
                }

                return subjectButton(subject, context, colors[index % colors.length]);
              },
            ),
          ),
        );
      },
    );
  }
}
