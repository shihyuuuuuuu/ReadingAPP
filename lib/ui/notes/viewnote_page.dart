import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/book.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/data/repositories/base_repo.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/ui/widget/popup_dialog.dart';

class ViewNotePage extends StatefulWidget{
  final noteId;
  ViewNotePage({
    required this.noteId,
  });

  @override
  State<ViewNotePage> createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {

  final List<Note> notes = [];
  final List<UserBook> userBooks = [];
  final List<Book> books = [];

  Future<void> readJson() async {
    // final BaseRepository book =
    final String dataStr = await rootBundle.loadString('assets/test_data.json');
    final Map<String, dynamic> data = json.decode(dataStr);
    setState(() { 
      for (var note in data['Note']) {
        note['createdAt'] = Timestamp.fromDate(DateTime.parse(note['createdAt']));
        note['updatedAt'] = Timestamp.fromDate(DateTime.parse(note['updatedAt']));
        final newNote = Note.fromMap(note, note['id']);
        notes.add(newNote);
      }
      for (var userBook in data['UserBook']) {
        userBooks.add(UserBook.fromMap(userBook, userBook['id']));
      }
      for (var book in data['Book']) {
        books.add(Book.fromMap(book, book['id']));
      }
    }); 
  }


  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    final dateFormatter = DateFormat('yyyy-MM-dd');

    final List<PopupEvent> popupEvent = [
      PopupEvent(
        icon: const Icon(Icons.send), 
        text: '分享筆記', 
        onPressed: ()=>{}
      ),
      PopupEvent(
        icon: const Icon(Icons.pause_circle_outline), 
        text: '編輯筆記', 
        onPressed:  ()=>{},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {nav.pop()}, 
          ),
        title: notes.isEmpty?const Text("book title"):Text(notes[0].title, style: textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert), 
            onPressed: () => {showPopup(context, popupEvent)}, 
          ),
        ],
      ),
      body: notes.isEmpty?const CircularProgressIndicator():
      SingleChildScrollView(
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
                    Text(books[0].title, style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                    const SizedBox(height: 10,),
                    Text('P.${notes[0].startPage}-${notes[0].endPage},  ${
                              dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(notes[0].createdAt.millisecondsSinceEpoch))}',
                            style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                    const SizedBox(height: 16,),
                    Text(notes[0].content, style: textTheme.bodyLarge),
                    
                  ]
                ),
              ),
              Positioned(
                right: 0,
                top: 2,
                child: Container(
                  color: colorScheme.primaryFixed, //note color
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                  child: Text(notes[0].type.str, style: textTheme.labelLarge),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}