import 'package:flutter/material.dart';
import 'package:reading_app/pages/notes/note_guideview_content.dart';
import 'package:reading_app/pages/notes/note_type.dart';

class NotePage extends StatefulWidget {
  
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String str = '《1984》是一部描述反烏托邦社會的經典小說。故事設定在一個虛構的極權主義國家“奧西尼亞”，時間是1984年。主角溫斯頓·史密斯是一名在黨的真理部工作的普通成員。他對黨和其領袖老大哥感到懷疑和不滿，並試圖在秘密中保持自己的思想自由。';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '我的筆記', 
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Sorting logic here
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search logic here
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          NoteGuideviewContent(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.content,
            description: str,
          ),
          NoteGuideviewContent(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.action,
            description: str,
          ),
          NoteGuideviewContent(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.experience,
            description: str,
          ),
          NoteGuideviewContent(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.thought,
            description: str,
          ),
          NoteGuideviewContent(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.action,
            description: str,
          ),
        ],
      ),
    );
  }
}

