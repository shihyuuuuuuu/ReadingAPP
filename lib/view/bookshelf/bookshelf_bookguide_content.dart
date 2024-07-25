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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 5),
        child: (
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(img),
              const SizedBox(height: 10,),
              Text(
                "書名", 
                style: Theme.of(context).textTheme.titleMedium,
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