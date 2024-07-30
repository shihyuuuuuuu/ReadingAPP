import 'package:flutter/material.dart';
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
          _NoteContainer(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.content,
            description: str,
          ),
          _NoteContainer(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.action,
            description: str,
          ),
          _NoteContainer(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.experience,
            description: str,
          ),
          _NoteContainer(
            title: 'Note Title',
            pages: 'p.148-153',
            date: '2024.07.14',
            noteType: NoteType.thought,
            description: str,
          ),
          _NoteContainer(
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


class _NoteContainer extends StatefulWidget {
  final String title;
  final String pages;
  final String date;
  final NoteType noteType;
  final String? description;

  const _NoteContainer({
    super.key,
    required this.title,
    required this.pages,
    required this.date,
    required this.noteType,
    this.description,
  });

  @override
  _NoteContainerState createState() => _NoteContainerState();
}

class _NoteContainerState extends State<_NoteContainer> {

  // function
  bool isExpanded = false;
  bool isPinned = false;

  void onExpandPressed() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void onPinPressed() {
    setState(() {
      isPinned = !isPinned;
    });
  }

  Color getColor(NoteType noteType) {
  switch (noteType) {
    case NoteType.content:
      return Theme.of(context).colorScheme.primaryFixedDim;
    case NoteType.experience:
      return Theme.of(context).colorScheme.secondaryFixedDim;
    case NoteType.action:
      return Theme.of(context).colorScheme.tertiaryFixedDim;
    case NoteType.thought:
      return Theme.of(context).colorScheme.surfaceDim;
  }
}

  String getNoteLabel(NoteType noteType) {
    switch (noteType) {
      case NoteType.content:
        return "內容筆記";
      case NoteType.experience:
        return "經驗";
      case NoteType.action:
        return "行動";
      case NoteType.thought:
        return "連結想法";
    }
  }

  @override
  Widget build(BuildContext context) {
    // style
    const double containerBR = 10;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    
    Color chooseColor = getColor(widget.noteType);
    String chooseNoteLabel = getNoteLabel(widget.noteType);
    
    return Stack(
      children:[ 
        Container(
        padding: EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(containerBR),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          widget.title,
                          style: textTheme.titleLarge,
                        ),
                      ),
                      subtitle: Text(
                        '${widget.pages}, ${widget.date}',
                        style: textTheme.labelLarge,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 28.0,
                        // padding: EdgeInsets.only(right: 30),
                        color: colorScheme.tertiary,
                        onPressed: onExpandPressed,
                        icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                      ),
                      IconButton(
                        iconSize: 28.0,
                        // padding: EdgeInsets.only(right: 30),
                        color: colorScheme.tertiary,
                        onPressed: onPinPressed,
                        icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isExpanded && widget.description != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10.0, bottom: 20.0),
                child: Text(
                  widget.description!,
                  style: textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 26,
           
          child: Container(
            padding: const EdgeInsets.all(6),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: chooseColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.zero, 
                right: Radius.circular(containerBR)
              ),
            ),
            child: (
              Text(
                chooseNoteLabel, 
                style: TextStyle(color: colorScheme.onSurface,)
              )
            )
          ),
        )
      ],
    );
  }
}

