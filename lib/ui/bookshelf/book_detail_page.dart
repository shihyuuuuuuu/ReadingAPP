import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/local/note_type.dart';
import 'package:reading_app/service/navigation.dart';
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
  
  

  void _showPopup(BuildContext context, List<popupEvent> popUpEvent) async {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog(options: popUpEvent,);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    DateTime now = DateTime.now();

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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            nav.pop();        
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showPopup(context, bookDetailPopup);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [ 
                  _BookInfoContainer(),
                  const SizedBox(height: 10,),
                  Text('書籍狀態：在讀', style: textTheme.bodyMedium),
                  SizedBox(height: 10,),
                  const TagArea(tagLables: ['魔法', '小說', '奇幻']),
                  const SizedBox(height: 16,),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                      child: Text("筆記", style: textTheme.titleMedium),
                    ),
                    const Expanded(child: Divider( )),  
                  ],),
                  const SizedBox(height: 4.0,),
                  Text("共6則", style: textTheme.bodySmall),     
                ],
              )
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((_, index) => 
                _NoteCard(
                  noteTitle: "A Good Day",
                  startPage: index,
                  endPage: index,
                  date: now,
                  noteType: NoteType.action,
                  content: "if there is a dall on the street, should i pick it?"
                ),
                childCount: 5,
              )
            ),
            
          ],
        ),
      ),
      bottomSheet: _BottomButtons(),
    );
  }
}

class _BookInfoContainer extends StatelessWidget {
  const _BookInfoContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      // padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(
            "https://d1csarkz8obe9u.cloudfront.net/themedlandingpages/tlp_hero_book-cover-adb8a02f82394b605711f8632a44488b.jpg",
            width: 140,
            height: 220,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Title',
                  style: textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                Text('Author', style: textTheme.bodyMedium,),
                Text('Publisher', style: textTheme.bodyMedium),
                Text('Year', style: textTheme.bodyMedium),
                SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 80.0),
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 10,
                              value: 0.3,
                              backgroundColor: Colors.grey[350],
                              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.tertiary),
                            ),
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                      Center(child: Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text('30%'),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String noteTitle;
  final int startPage;
  final int endPage;
  final DateTime date;
  final String content;
  final NoteType noteType;

  const _NoteCard({
    super.key, 
    required this.noteTitle, 
    required this.startPage, 
    required this.endPage, 
    required this.date, 
    required this.content, 
    required this.noteType
  });


  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => {nav.goViewNote("noteId")},
        child: Stack(
          children: [    
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noteTitle,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500 ),
                  ),
                  const SizedBox(height: 8),
                  Text('p.${startPage}-${endPage+10}, ${DateFormat.yMd().format(date)}',
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    maxLines: 4,
                    style: textTheme.bodyMedium
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 24,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                color: noteType.color,
                child: Text(noteType.name),
              )
            )
          ],
        ),
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        boxShadow:[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,  
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FilledButton(
              onPressed: () => { nav.goChatNote('bookId')}, 
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