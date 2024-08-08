import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/ui/notes/note_type.dart';
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
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    DateTime now = DateTime.now();
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
              // Implement more options functionality here
            },
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [ 
                  _BookInfoContainer(textTheme: textTheme, colorScheme: colorScheme),
                  SizedBox(height: 20,),
                  Text('書籍狀態：在讀', style: textTheme.bodyLarge),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0, // 标签之间的水平间距
                    runSpacing: 2.0, // 标签之间的垂直间距
                    children: [
                      Chip(
                        label: Text('# 魔法'),
                        backgroundColor: Colors.orange[100],
                        padding: EdgeInsets.zero,
                      ),
                      Chip(
                        label: Text('# 小說'),
                        backgroundColor: Colors.orange[100],
                        padding: EdgeInsets.zero,
                      ),
                      // 可以添加更多的标签
                      Chip(
                        label: Text('# 冒險'),
                        backgroundColor: Colors.orange[100],
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
            
                  SizedBox(height: 16,),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                      child: Text("筆記", style: textTheme.titleLarge),
                    ),
                    Expanded(child: Divider( )),  
                  ],),
                  SizedBox(height: 4.0,),
                  Text("共6則", style: textTheme.bodySmall),
                  
                ],
              )
            ),
            SliverList(
              // scrollDirection: Axis.vertical,
              // shrinkWrap: true,
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
    );
  }
}

class _BookInfoContainer extends StatelessWidget {
  const _BookInfoContainer({
    // super.key,
    required this.textTheme,
    required this.colorScheme,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
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
                  style: textTheme.displaySmall,
                ),
                SizedBox(height: 16),
                Text('Author', style: textTheme.bodyLarge,),
                Text('Publisher', style: textTheme.bodyLarge),
                Text('Year', style: textTheme.bodyLarge),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('p.${startPage}-${endPage+10}, ${DateFormat.yMd().format(date)}'),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    maxLines: 4,
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
