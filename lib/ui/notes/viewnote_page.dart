import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';

class ViewNotePage extends StatelessWidget{
  final noteId;
  ViewNotePage({
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('view note page'),
          Text('test to pop back to previous page'),
          ElevatedButton(
            onPressed: () => { nav.goEditNote('tt124') },
            child: Text("Edit Note")),
        ]
      )
    );
  }
}