import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_app/src/components/uicomponents.dart';
import 'package:school_app/src/utils/models.dart';
import 'package:school_app/src/utils/providers.dart';

class SubjectNotesPage extends StatefulWidget {
  const SubjectNotesPage({super.key, required this.subjectId});
  final String subjectId;
  @override
  State<SubjectNotesPage> createState() => _SubjectNotesPageState();
}

class _SubjectNotesPageState extends State<SubjectNotesPage> {
  final SearchController _controller = SearchController();
  List<NoteModel> _allSubjectNotes = [];
  final List<NoteModel> _filteredNotes = [];

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        filterNotes();
      });
    });
    super.initState();
  }

  void filterNotes() {
    final String query = _controller.text.toLowerCase();

    if (query.isEmpty) {
      _filteredNotes.clear();
      _filteredNotes.addAll(_allSubjectNotes);
      return;
    }

    final List<NoteModel> filtered = _allSubjectNotes
        .where((note) =>
            note.name.toLowerCase().contains(query) ||
            note.author.toLowerCase().contains(query))
        .toList();

    _filteredNotes.clear();
    _filteredNotes.addAll(filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<QueryNotesProvider>(
        builder: (context, queryNotes, child) {
          _allSubjectNotes = queryNotes.getNotesBySubject(widget.subjectId);
          filterNotes();
          if (_allSubjectNotes.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text("No notes found for this subject"),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              leading: Container(),
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: mySearchBar(context, _controller, "Search Notes")),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(45),
                ),
              ),
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  final NoteModel note = _filteredNotes[index];

                  return noteButton(note, context, Colors.white);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
