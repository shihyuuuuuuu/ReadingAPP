import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/service/navigation.dart';

class ChatNotePage extends StatefulWidget{
  final bookId;
  ChatNotePage({
    required this.bookId,
  });

  @override
  State<ChatNotePage> createState() => _ChatNotePageState();
}

class _ChatNotePageState extends State<ChatNotePage> {
  
  /*
  Example of how to load fake data
  Real data shoul follow the similar steps
  */

  // 1. declare data types that would be used
  final List<Note> notes = [];

  // 2. function for loading data
  Future<void> readJson() async {
    final String dataStr = await rootBundle.loadString('assets/test_data.json');
    final Map<String, dynamic> data = json.decode(dataStr);
    setState(() { 
      for (var note in data['Note']) {
        note['createdAt'] = Timestamp.fromDate(DateTime.parse(note['createdAt']));
        note['updatedAt'] = Timestamp.fromDate(DateTime.parse(note['updatedAt']));
        final newNote = Note.fromMap(note, note['id']);
        notes.add(newNote);
      }
    }); 
  }

  // 3. in initState, execute loading data
  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            nav.pop();        
          },
        ),
      ),
      body: 
          // 4. null safety and iterate through data
          notes != null 
                ? Column( 
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: notes.map((item) => Text(item.title)).toList(), 
                  ) 
                : CircularProgressIndicator(), 

          // Text('display large', style: textTheme.displayLarge,),
          // Text('display medium', style: textTheme.displayMedium,),
          // Text('display small', style: textTheme.displaySmall,),
          // Text('headline large', style: textTheme.headlineLarge,),
          // Text('headline medium', style: textTheme.headlineMedium,),
          // Text('headline small', style: textTheme.headlineSmall,),
          // Text('title large', style: textTheme.titleLarge,),
          // Text('title medium', style: textTheme.titleMedium,),
          // Text('title small', style: textTheme.titleSmall,),
          // Text('body large', style: textTheme.bodyLarge,),
          // Text('body medium', style: textTheme.bodyMedium,),
          // Text('body small', style: textTheme.bodySmall,),
          // Text('label large', style: textTheme.labelLarge,),
          // Text('label medium', style: textTheme.labelMedium,),
          // Text('label small', style: textTheme.labelSmall,),


        
      
    );
  }
}