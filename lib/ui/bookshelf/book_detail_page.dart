import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';

class BookDetailPage extends StatelessWidget{
  final String bookId;
  BookDetailPage({
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('book detail Page'),
          ElevatedButton(
            onPressed: ()=>{nav.goEditBook('tt123')},
            child: Text("edit book")
          ),
          ElevatedButton(
            onPressed: ()=>{nav.goViewNote('tt123')},
            child: Text("view note")
          ),
          ElevatedButton(
            onPressed: ()=>{nav.goChatNote('tt123')},
            child: Text("chat note")
          ),
        ]
      )
    );
  }
}