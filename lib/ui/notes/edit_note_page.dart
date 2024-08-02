import 'package:flutter/material.dart';

class EditNotePage extends StatelessWidget{
  final noteId;
  EditNotePage({
    required this.noteId,
  });

  @override
  Widget build(BuildContext context) {
    
    return const Center(child: Text('edit note Page'));
  }
}