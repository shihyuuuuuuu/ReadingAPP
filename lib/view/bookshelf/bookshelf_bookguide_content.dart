import 'package:flutter/material.dart';

class BookShelfBookGuideContent extends StatelessWidget{
  final String img;
  const BookShelfBookGuideContent({
    super.key,
    required this.img,
    });
  

  @override
  Widget build(BuildContext context) {
    List<String> tags = ["小說","文學","經典"];
    return Container(
      padding: const EdgeInsets.only(top:10.0, right: 10, left: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            blurRadius: 5.0,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: (
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(img),
            const SizedBox(height: 10,),
            Text(
              "書名", 
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 6,),
            Row(
              children: 
                tags.map((item) => Tag(text:item)).toList()
              )
          ],)
        )

      );
  }
}

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
      style: Theme.of(context).textTheme.labelSmall),
    );
  }
}