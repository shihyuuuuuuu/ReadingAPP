import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget{
  final bookId;
  BookDetailPage({
    required this.bookId,
  });
  
  @override
  Widget build(BuildContext context) {
    
    return const Center(child: Text('book detail Page'));
  }
}