import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app_flutter2/components/drawer.dart';
import 'package:note_app_flutter2/components/note_tile.dart';
import 'package:note_app_flutter2/models/note.dart';
import 'package:note_app_flutter2/models/note_database.dart';
import 'package:provider/provider.dart';
import 'create_and_update_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // on app startup, fetch existing notes
    readNotes();
  }

  // create a note
  void createNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateOrUpdateNotePage()),
    );
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update a note
  void updateNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrUpdateNotePage(
          note: note,
        ),
      ),
    );
  }

  // delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  // analyze a note
  void analyzeNote(Note note) {
    context.read<NoteDatabase>().analyzeAndCreateNote(note);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add,
            color: Theme.of(context).colorScheme.inversePrimary),
      ),
      drawer: const Mydrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADING
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text('Notes',
                style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
          ),

          // LIST OF NOTES
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                // get individual note
                final note = currentNotes[index];

                // list title UI
                return NoteTile(
                  text:
                      note.title ?? 'Untitled', // title이 null일 경우 'Untitled' 표시
                  onEditPressed: () => updateNote(note),
                  onDeletePressed: () => deleteNote(
                    note.id ?? 0,
                  ),
                  onAnalyzePressed: () => analyzeNote(note),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
