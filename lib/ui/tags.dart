import 'package:flutter/material.dart';

class Tag extends StatelessWidget{
  final String text;
  const Tag({
    super.key, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(5.0),
      ), 
      child: Text(text,
      style: Theme.of(context).textTheme.labelMedium),
    );
  }
}