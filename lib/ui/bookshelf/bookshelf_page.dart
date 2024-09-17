import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/book.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/theme/appbar_icon_style.dart';
import 'package:reading_app/ui/widget/searching_dialog.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

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
          history: ['习惯', '成长型思维', 'DRY', '自我察觉练习', '索引笔记', '便条纸笔记'],
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
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        toolbarHeight: 70.0,
        title: Text(
          '書架',
          style: textTheme.headlineMedium,
        ),
        actions: <Widget>[
          appBarIconStyle(
            colorScheme,
            context,
            IconButton(
              iconSize: 28,
              color: colorScheme.onSecondaryContainer,
              icon: const Icon(Icons.search),
              onPressed: () => _showPopup(context),
            ),
          ),
        ],
      ),
      body: Center(child: Consumer<UserBooksViewModel>(
        builder: (context, viewModel, _) {
          List<UserBook> userBooks = viewModel.userBooks;
          log("userId: ${viewModel.userId}");
          if (userBooks.isEmpty) {
            return const Center(child: Text('No books.'));
          } else {
            return GridView.count(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 24.0,
              crossAxisCount: 2,
              childAspectRatio: (0.53),
              children:
                  userBooks.map((book) => _BookCard(userBook: book)).toList(),
            );
          }
        },
      )),
    );
  }
}

class _BookCard extends StatelessWidget {
  final UserBook userBook;

  const _BookCard({
    super.key,
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
            nav.goBookDetail(userBook.id!);
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 5),
            child: (Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(userBook.book.coverImage!),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userBook.book.title,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall, // bold
                ),
                Text(
                  userBook.state.displayName,
                  style: textTheme.bodySmall,
                ), 
              ],
            )),
          ),
        ));
  }
}
