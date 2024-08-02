import 'package:flutter/material.dart';

class EditBookPage extends StatelessWidget{
  final bookId;
  EditBookPage({
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    
    return const Center(child: Text('edit book Page'));
  }
}