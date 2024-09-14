import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/book.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  final List<Book> books = [];
  final List<UserBook> userBooks = [];


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
      ),
      body: Center(child: Consumer<UserBooksViewModel>(
        builder: (context, viewModel, _) {
          List<UserBook> userBooks = viewModel.userBooks;

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
