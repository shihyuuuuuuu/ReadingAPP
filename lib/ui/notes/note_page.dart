import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/ui/widget/note_container.dart';
import 'package:reading_app/view_models/notes_vm.dart';

class NotePage extends StatefulWidget {
  
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Note> notes = [];
    

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Text(
          '我的筆記', 
          style: textTheme.headlineMedium,
        ),
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, viewModel, _) {
          List<Note> notes = viewModel.notes;

          if(notes.isEmpty) {
            return const Center(child: Text('No Notes.'));
          } else {
            return ListView( 
              children: notes.map((item) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: NoteContainer(note: item,),
                )).toList(), 
            );
          }
        }
      )
    );
  }
}

