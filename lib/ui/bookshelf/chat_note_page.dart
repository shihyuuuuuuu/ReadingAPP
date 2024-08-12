import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';

class ChatNotePage extends StatelessWidget{
  final bookId;
  ChatNotePage({
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            nav.pop();        
          },
        ),
      ),
      body: Column(
        children: [
          Text('display large', style: textTheme.displayLarge,),
          Text('display medium', style: textTheme.displayMedium,),
          Text('display small', style: textTheme.displaySmall,),
          Text('headline large', style: textTheme.headlineLarge,),
          Text('headline medium', style: textTheme.headlineMedium,),
          Text('headline small', style: textTheme.headlineSmall,),
          Text('title large', style: textTheme.titleLarge,),
          Text('title medium', style: textTheme.titleMedium,),
          Text('title small', style: textTheme.titleSmall,),
          Text('body large', style: textTheme.bodyLarge,),
          Text('body medium', style: textTheme.bodyMedium,),
          Text('body small', style: textTheme.bodySmall,),
          Text('label large', style: textTheme.labelLarge,),
          Text('label medium', style: textTheme.labelMedium,),
          Text('label small', style: textTheme.labelSmall,),
        ],
      )
    );
  }
}