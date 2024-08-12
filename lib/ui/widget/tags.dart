import 'package:flutter/material.dart';

class TagArea extends StatelessWidget{
  final List<String>? tagLables;
  const TagArea({
    super.key, 
    required this.tagLables
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // clipBehavior: Clip.hardEdge,
      spacing: 8.0,
      runSpacing: 5.0,
      children: 
        tagLables!.map((item) => _Tags(text:item)).toList()
      );
     
  }
}

class _Tags extends StatelessWidget {
  final String text;
  
  const _Tags({
    super.key, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Chip(
        label: Text('#$text', style: textTheme.labelMedium),
        backgroundColor: Colors.orange[100],
        padding: EdgeInsets.zero,
      );
  }
}