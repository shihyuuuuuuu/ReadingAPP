import 'package:flutter/material.dart';

class ReadingPage extends StatelessWidget{
  final bookId;
  ReadingPage({
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    
    return const Center(child: Text('reading Page'));
  }
}