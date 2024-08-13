import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/book.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/ui/widget/note_container.dart';
import 'package:reading_app/ui/widget/popup_dialog.dart';
import 'package:reading_app/ui/widget/popup_event.dart';
import 'package:reading_app/ui/widget/tags.dart';

class BookDetailPage extends StatefulWidget {

  final String bookId;

  const BookDetailPage({
    super.key, 
    required this.bookId
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  
  // TODO: [rear end]: books -> book, userBooks -> userBook
  final List<Note> notes = [];
  final List<Book> books = [];
  final List<UserBook> userBooks = [];

  Future<void> readJson() async {
    // TODO: [rear end]: data fetching logic
    final String dataStr = await rootBundle.loadString('assets/test_data.json');
    final Map<String, dynamic> data = json.decode(dataStr);
    setState(() { 
      for (var note in data['Note']) {
        note['createdAt'] = Timestamp.fromDate(DateTime.parse(note['createdAt']));
        note['updatedAt'] = Timestamp.fromDate(DateTime.parse(note['updatedAt']));
        final newNote = Note.fromMap(note, note['id']);
        notes.add(newNote);
      }
      for (var book in data['Book']) {
        books.add(Book.fromMap(book, book['id']));
        break;
      }
      for (var userBook in data['UserBook']) {
        userBooks.add(UserBook.fromMap(userBook, userBook['id']));
        break;
      }
    }); 
  }


  void _showPopup(BuildContext context, List<popupEvent> popUpEvent) async {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog(options: popUpEvent,);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
  

    const snackBar = SnackBar(
      content: Text('已更新書籍狀態'),
      duration: Duration(milliseconds: 1500),
    );

    final List<popupEvent> bookStatePopUp = [
      popupEvent(
        icon: const Icon(Icons.flag), 
        text: '放棄', 
        onPressed: ()=>{ScaffoldMessenger.of(context).showSnackBar(snackBar)}
      ),
      popupEvent(
        icon: const Icon(Icons.pause_circle_outline), 
        text: '暫停', 
        onPressed:  ()=>{},
      ),
      popupEvent(
        icon: const Icon(Icons.adjust_outlined), 
        text: '完成', 
        onPressed: ()=>{}
      ),
    ];

    final List<popupEvent> bookDetailPopup = [
      popupEvent(
        icon: const Icon(Icons.edit_document), 
        text: '編輯書籍資訊', 
        onPressed: ()=>{}
      ),
      popupEvent(
        icon: const Icon(Icons.table_chart_outlined), //autorenew
        text: '更改狀態', 
        onPressed: () => _showPopup(context, bookStatePopUp),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            nav.pop();        
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showPopup(context, bookDetailPopup);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 85.0),
        child: books.isEmpty? 
        const CircularProgressIndicator():
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start ,
                  children: [
                    _BookInfoContainer(book: books[0], userBook: userBooks[0]),
                    const SizedBox(height: 10,),
                    Text('書籍狀態：${userBooks[0].state.displayName}', style: textTheme.bodyMedium),
                    const SizedBox(height: 10,),
                    TagArea(tagLables: (books[0].categories)),
                    const SizedBox(height: 16,),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                        child: Text("筆記", style: textTheme.titleMedium),
                      ),
                      const Expanded(child: Divider( )),  
                    ],),
                    const SizedBox(height: 4.0,),
                    Text("共${notes.length}則", style: textTheme.bodySmall),     
                  ],
                ),
              )
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NoteContainer(note: notes[index], expand: false,),
                  );
                },
                childCount: notes.length,
              ),
            )
            
          ],
        ),
      ),
      bottomSheet: _BottomButtons(),
    );
  }
}

class _BookInfoContainer extends StatelessWidget {
  final Book book;
  final UserBook userBook;

  const _BookInfoContainer({
    super.key, 
    required this.book, 
    required this.userBook,
  });

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final dateFormatter = DateFormat('yyyy-MM-dd');

    return Row(
      children: [
        Image.network(
          book.coverImage!,
          width: 140,
          height: 220,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text('作者：${book.authors.map((item) => item).join()}', style: textTheme.bodyMedium,),
              Text('出版商：${book.publisher}', style: textTheme.bodyMedium),
              Text('出版日期：${dateFormatter.format(book.publishedDate!)}', style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            value: userBook.currentPage / book.pageCount!,
                            backgroundColor: Colors.grey[350],
                            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.tertiary),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text(((userBook.currentPage / book.pageCount!)*100).toStringAsFixed(0)),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // final nav = Provider.of<NavigationService>(context, listen: false);
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        boxShadow:[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,  
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FilledButton(
              onPressed: () => {}, 
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("開始閱讀", style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary) ),
              )
            ),
          FilledButton(
              onPressed: () => {}, 
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("新增筆記", style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary) ),
              )
            ),
        ],
      ),
    );
  }
}