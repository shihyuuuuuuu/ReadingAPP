import 'package:flutter/material.dart';

class AddBookPage extends StatelessWidget{
  final bookId;
  AddBookPage({
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    
    return const Center(child: Text('add book Page'));
  }
}