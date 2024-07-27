import 'package:flutter/material.dart';
import 'package:reading_app/ui/tags.dart';

class BookShelfBookGuideContent extends StatelessWidget{
  final String img;
  final String bookName;
  final List<String> tags;
  const BookShelfBookGuideContent({
    super.key,
    required this.img,
    required this.bookName,
    required this.tags,
    });
  

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 5),
        child: (
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(img,),
              const SizedBox(height: 10,),
              Text(
                bookName, 
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 6,),
              Row(
                children: 
                  tags.map((item) => Tag(text:item)).toList()
                )
            ],)
          ),
      )
      );
  }
}