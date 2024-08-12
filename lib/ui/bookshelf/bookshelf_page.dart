import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/local/book_state.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/theme/appbar_icon_style.dart';
import 'package:reading_app/ui/widget/searching_dialog.dart';


class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {

  String _searchCondition = ""; 

  Future<void> _showPopup(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const SearchingDialog(
          searchHint: '輸入書名、作者或標籤',
          history:  [
              '习惯', '成长型思维', 'DRY', '自我察觉练习', '索引笔记', '便条纸笔记'
            ],
        );
      },
    );

      if (result != null) {
        setState(() {
          _searchCondition = result;
        });
      }
    }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // will use database in the future
    List<String> img = [
      "https://d1csarkz8obe9u.cloudfront.net/themedlandingpages/tlp_hero_book-cover-adb8a02f82394b605711f8632a44488b.jpg",
      "https://edit.org/images/cat/book-covers-big-2019101610.jpg",
      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/yellow-business-leadership-book-cover-design-template-dce2f5568638ad4643ccb9e725e5d6ff.jpg",
    ];
    List<String> tags = ["小說","文學","經典", "超好看"];
    List<String> bookName = ["原子習慣", "小婦人", "小王子"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        toolbarHeight: 70.0,
        title: Text('書架', style: textTheme.headlineLarge,),
        actions: <Widget>[
          appBarIconStyle(
              colorScheme, context,
              IconButton(
              iconSize: 28,
              color: colorScheme.onSecondaryContainer,
              icon: const Icon(Icons.search),
              onPressed: () => _showPopup(context),
            ),
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 24.0,
          crossAxisCount: 2,
          childAspectRatio: (0.53),
          children: [
            // use this to test data:
            // Text('search condition: $_searchCondition'),
            
            _BookCard(img: img[2], bookName: bookName[1], tags: tags, bookState: BookState.reading,),
            _BookCard(img: img[1], bookName: bookName[1], tags: tags, bookState: BookState.reading,),
            _BookCard(img: img[0], bookName: bookName[0], tags: tags, bookState: BookState.suspended,),
            _BookCard(img: img[2], bookName: bookName[2], tags: tags, bookState: BookState.finished,),
            _BookCard(img: img[1], bookName: bookName[0], tags: tags, bookState: BookState.waiting,),
            _BookCard(img: img[0], bookName: bookName[1], tags: tags, bookState: BookState.waiting,),
            ],
          ),
      
      ),
    );
  }
}


class _BookCard extends StatelessWidget{
  final String img;
  final String bookName;
  final List<String> tags;
  final BookState bookState;
  const _BookCard({
    super.key,
    required this.img,
    required this.bookName,
    required this.tags,
    required this.bookState,
    });
  

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      color: colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: () {
          // GoRouter.of(context).go('/book/tk123');
          nav.goBookDetail('tt123');
        },
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
                  style: textTheme.titleMedium, // bold
                ),
                Text(bookState.displayName), //more info for page, etc.
                // TagArea(tagLables: tags.sublist(0,2),)
              ],)
            ),
        ),
      )
      );
  }
}
