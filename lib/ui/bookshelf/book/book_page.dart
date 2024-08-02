import 'package:flutter/material.dart';
import 'package:reading_app/ui/tags.dart';

class BookPage extends StatefulWidget {
  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement back button functionality here
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.network(
                    "https://d1csarkz8obe9u.cloudfront.net/themedlandingpages/tlp_hero_book-cover-adb8a02f82394b605711f8632a44488b.jpg",
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book Title',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Author'),
                        Text('Publisher'),
                        Text('Year'),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            CircularProgressIndicator(
                              value: 0.5,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            SizedBox(width: 8),
                            Text('50%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Text('書籍狀態：在讀'),
            Wrap(
              children: [
                Text('tags:'),
                Tag(text: '閱讀'),
                Tag(text:'一天'),
              ],
            ),
            Row(children: [
              Text("筆記", style: Theme.of(context).textTheme.titleSmall),
              Expanded(child: Divider( )),  
            ],),
            Text("共6則"),
            // ListView.builder()
            
        
          ],
        ),
      ),
    );
  }
}

// class NoteCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Note Title',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text('p.148-153, 2024.07.14'),
//             SizedBox(height: 8),
//             Text('知識內容'),
//             SizedBox(height: 8),
//             Text(
//               '《1984》是一部描述後鳥托邦社會的經典小說。故事設定在一個極權獨裁主義國家“奧亞尼亞”，時間是1984年。主角溫斯頓·史密斯是一名真理部員工...',
//               maxLines: 4,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
