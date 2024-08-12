import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/book.dart';
import 'package:reading_app/data/models/user_book.dart';
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
  final List<Book> books = [];
  final List<UserBook> userBooks = [];

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

  Future<void> readJson() async {
    final String dataStr = await rootBundle.loadString('assets/test_data.json');
    final Map<String, dynamic> data = json.decode(dataStr);
    setState(() { 
      for (var book in data['Book']) {
        final newNote = Book.fromMap(book, book['id']);
        books.add(newNote);
      }
      for (var userBook in data['UserBook']) {
        final newUserBook = UserBook.fromMap(userBook, userBook['id']);
        userBooks.add(newUserBook);
      }
    }); 
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        toolbarHeight: 70.0,
        title: Text('書架', style: textTheme.headlineMedium,),
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
          children: books != null ? 
            // TODO: [rear end]:correspond book and userBook
            books.map((book) => _BookCard(book: book, userBook: userBooks[0])).toList():
            [ 
              const CircularProgressIndicator(),
            ],
          ),
      
      ),
    );
  }
}


class _BookCard extends StatelessWidget{
  final Book book;
  final UserBook userBook;
  
  const _BookCard({
    super.key,
    required this.book, 
    required this.userBook,
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
          // TODO: [rear end]:what to pass to the BookDetailPage
          nav.goBookDetail(book.id!);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 5),
          child: (
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(book.coverImage!),
                const SizedBox(height: 10,),
                Text(
                  book.title, 
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall, // bold
                ),
                Text(userBook.state.displayName, style: textTheme.bodySmall,), //more info for page, etc.
                // TagArea(tagLables: tags.sublist(0,2),)
              ],)
            ),
        ),
      )
      );
  }
}
