import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';

class EditBookPage extends StatelessWidget{
  final bookId;
  EditBookPage({
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {nav.pop()},
          ),
      ), 
      body: Center(child: Text('edit book Page'))
    );
  }
}