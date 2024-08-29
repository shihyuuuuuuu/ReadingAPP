import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/ui/widget/popup_dialog.dart';
import 'package:reading_app/view_models/notes_vm.dart';

class ViewNotePage extends StatefulWidget{
  final noteId;
  ViewNotePage({
    required this.noteId,
  });

  @override
  State<ViewNotePage> createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    final viewModel = Provider.of<NotesViewModel>(context);
    final dateFormatter = DateFormat('yyyy-MM-dd');


    return FutureBuilder<Note?>(
      future: viewModel.getNote(widget.noteId, userId),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final note = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: colorScheme.surface,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  
                  onPressed: () => {nav.pop()}, 
                  ),
                title: Text(note.title, style: textTheme.titleMedium),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.send), 
                    color: colorScheme.primary,
                    onPressed: () => {}, 
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      icon: const Icon(Icons.edit_document), 
                      color: colorScheme.primary,
                      // TODO: fix navigation push and pop
                      onPressed: () => {nav.goEditNote(widget.noteId)}, 
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TODO: book title
                            Text("book title", style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                            const SizedBox(height: 10,),
                            Text('P.${note.startPage}-${note.endPage},  ${
                                      dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(note.createdAt.millisecondsSinceEpoch))}',
                                    style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                            const SizedBox(height: 16,),
                            Text(note.content, style: textTheme.bodyLarge),
                            
                          ]
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: note.type.color, 
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[600]!.withOpacity(0.5),
                                blurRadius: 5,
                                spreadRadius: 3,
                                offset: Offset(0, 1)
                              ),
                            ]
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                          child: Text(note.type.str, style: textTheme.labelLarge!.copyWith(color: colorScheme.onPrimary)),
                        )
                      ),
                    ],
                  ),
                ),
              )
          );
        } else {
            return const Center(child: Text('No data found'));
        }
      }
    );
  }
}