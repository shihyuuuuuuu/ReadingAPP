import 'package:flutter/material.dart';

class ViewNotePage extends StatelessWidget{
  final noteId;
  ViewNotePage({
    required this.noteId,
  });

  @override
  Widget build(BuildContext context) {
    
    return const Center(child: Text('viewnote Page'));
  }
}