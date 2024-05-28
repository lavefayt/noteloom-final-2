import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_app/src/components/uicomponents.dart';
import 'package:school_app/src/utils/firebase.dart';
import 'package:school_app/src/utils/models.dart';
import 'package:school_app/src/utils/providers.dart';
import 'package:school_app/src/utils/sharedprefs.dart';
import 'package:google_fonts/google_fonts.dart';  // Import Google Fonts

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key, required this.subjectId});
  final String subjectId;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    final SubjectModel? subject =
        context.read<QueryNotesProvider>().findSubject(widget.subjectId);

    if (subject == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new), onPressed: () {}),
        ),
        body: const Center(
          child: Text("Subject not found."),
        ),
      );
    }
    return RenderSubjectPage(
      subject: subject,
    );
  }
}

class RenderSubjectPage extends StatefulWidget {
  const RenderSubjectPage({super.key, required this.subject});

  final SubjectModel subject;

  @override
  State<RenderSubjectPage> createState() => _RenderSubjectPageState();
}

class _RenderSubjectPageState extends State<RenderSubjectPage> {
  @override
  void initState() {
    Future.microtask(() {
      final userData = context.read<UserProvider>();

      Database.addRecents("subjects/${widget.subject.id}");
      userData.addRecents("subjects/${widget.subject.id}");
    });

    super.initState();
  }

  void onExit() async {
    final getSharedPrefsList = await SharedPrefs.getPrioritySubjects();

    final isSubjectSaved = getSharedPrefsList.contains(widget.subject.id);

    Database.setPrioritySubejctIds(widget.subject.id!, isSubjectSaved);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPrefs.isSubjectPriority(widget.subject.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: myLoadingIndicator());
          }
          bool isPriority = snapshot.data ?? false;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Hello world !",
                style: GoogleFonts.ubuntu(  // Apply Ubuntu font
                  fontSize: 20,  // Optional: Adjust font size as needed
                  fontWeight: FontWeight.bold,  // Optional: Adjust font weight as needed
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  onExit();
                  context.go('/home');
                },
              ),
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.subject.subject,
                          style: const TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      Actions(isPriority: isPriority, subject: widget.subject)
                    ],
                  ),
                  Text(
                    widget.subject.subjectCode,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pushNamed("subjectNotes", pathParameters: {
                              "id": widget.subject.id!,
                            });
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Text(
                                'View Notes',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed("discussions", pathParameters: {
                              "id": widget.subject.id!,
                            });
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Text(
                                'View\nDiscussions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class Actions extends StatefulWidget {
  const Actions({
    super.key,
    required this.isPriority,
    required this.subject,
  });
  final bool isPriority;
  final SubjectModel subject;

  @override
  State<Actions> createState() => _ActionsState();
}

class _ActionsState extends State<Actions> {
  bool isPriority = false;

  @override
  void initState() {
    isPriority = widget.isPriority;
    super.initState();
  }

  void togglePriority() {
    setState(() {
      isPriority = !isPriority;
    });
    final userData = context.read<UserProvider>();

    if (isPriority) {
      userData.addPrioritySubjectId(widget.subject.id!);
    } else {
      userData.removePrioritySubjectId(widget.subject.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: togglePriority,
        icon: Icon(
          Icons.bookmark,
          color: isPriority ? Theme.of(context).colorScheme.primary : null,
        ));
  }
}
