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
  
  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: '輸入書名、作者或標籤',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: <Widget>[
                  _buildFilterChip('在讀'),
                  _buildFilterChip('待讀'),
                  _buildFilterChip('已暫停'),
                  _buildFilterChip('已完成'),
                  _buildFilterChip('已放棄'),
                  _buildFilterChip('全部'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool value) {},
    );
  }

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
          style: Theme.of(context).textTheme.headlineLarge,),
        actions: <Widget>[
          Container(
            // color: Theme.of(context).colorScheme.primary,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Theme.of(context).colorScheme.secondaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 5.0,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: IconButton(
              // padding: EdgeInsets.all(5),
              iconSize: 28,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              icon: const Icon(Icons.search),
              onPressed: () => _showPopup(context),
            ),
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
