import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reading_app/view/bookshelf/bookshelf_bookguide_content.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key, required this.title});
  final String title;

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {


  @override
  Widget build(BuildContext context) {
    List<String> img = [
      "https://d1csarkz8obe9u.cloudfront.net/themedlandingpages/tlp_hero_book-cover-adb8a02f82394b605711f8632a44488b.jpg",
      "https://edit.org/images/cat/book-covers-big-2019101610.jpg",
      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/yellow-business-leadership-book-cover-design-template-dce2f5568638ad4643ccb9e725e5d6ff.jpg",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          '書架',
          style: Theme.of(context).textTheme.titleLarge,),
        actions: <Widget>[
          IconButton(
            iconSize: 35,
            icon: const Icon(Icons.search),
            onPressed: () {
              // ...
            },
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          padding: EdgeInsets.all(28.0),
          
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 24.0,
          crossAxisCount: 2,
          childAspectRatio: (0.51),
          children: [
            BookShelfBookGuideContent(img: img[0]),
            BookShelfBookGuideContent(img: img[1]),
            BookShelfBookGuideContent(img: img[2]),
            BookShelfBookGuideContent(img: img[0]),
            BookShelfBookGuideContent(img: img[1]),
            ],
          ),
      
      ),
    );
  }
}
