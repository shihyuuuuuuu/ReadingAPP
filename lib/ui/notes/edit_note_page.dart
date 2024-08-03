import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';

class EditNotePage extends StatelessWidget{
  final noteId;
  EditNotePage({
    required this.noteId,
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
      body: Center(child: Text('edit note Page'))
    );
  }
}