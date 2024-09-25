import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/notes_vm.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

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
    final noteViewModel = Provider.of<NotesViewModel>(context);
    final userBookViewModel = Provider.of<UserBooksViewModel>(context);
    final dateFormatter = DateFormat('yyyy-MM-dd');


    return FutureBuilder<Note?>(
      future: noteViewModel.getNote(widget.noteId),
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
                  onPressed: () => {nav.pop(context)}, 
                  ),
                title: Text(
                  note.title, 
                  style: textTheme.bodyMedium!.copyWith(color:colorScheme.outline)
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      icon: const Icon(Icons.edit_document), 
                      color: colorScheme.primary,
                      // TODO: fix navigation push and pop
                      onPressed: () => {nav.goEditNote(widget.noteId, note.userBookId, false)}, 
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<UserBook?>(
                                  future: userBookViewModel.getUserBook(note.userBookId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return Text("⟪${snapshot.data!.book.title}⟫", style: textTheme.bodySmall?.copyWith(color: colorScheme.outline));
                                    } else {
                                      return const Center(child: Text('No data found'));
                                    }
                                  }
                                ),
                                const SizedBox(height: 10,),
                                Text('P.${note.startPage}-${note.endPage},  ${
                                          dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(note.createdAt.millisecondsSinceEpoch))}',
                                        style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: note.type.color, 
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[600]!.withOpacity(0.3),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: Offset(4, 4)
                                  ),
                                ]
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                              child: Text(note.type.str, style: textTheme.labelLarge!.copyWith(color: colorScheme.onPrimary)),
                            )
                          ],
                        ),
                        const SizedBox(height: 16,),
                        Text(note.content, style: textTheme.bodyLarge),
                        
                      ]
                    ),
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