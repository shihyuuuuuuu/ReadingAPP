import 'package:flutter/material.dart';
import 'package:reading_app/theme/appbar_icon_style.dart';
import 'package:reading_app/ui/notes/note_type.dart';
import 'package:reading_app/ui/widget/searching_dialog.dart';

class NotePage extends StatefulWidget {
  
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String str = '《1984》是一部描述反烏托邦社會的經典小說。故事設定在一個虛構的極權主義國家“奧西尼亞”，時間是1984年。主角溫斯頓·史密斯是一名在黨的真理部工作的普通成員。他對黨和其領袖老大哥感到懷疑和不滿，並試圖在秘密中保持自己的思想自由。';
  
  String _searchCondition = "";

    Future<void> _showPopup(BuildContext context) async {
      final result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return const SearchingDialog(
          searchHint: '輸入筆記名稱或相關內容',
            history: [
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '我的筆記', 
          style: textTheme.headlineLarge,
        ),
        actions: <Widget>[
          appBarIconStyle(colorScheme, context,  
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _showPopup(context);           // Search logic here
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: ListView(
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
            // Text('query string: ${_searchCondition}'),
          ],
        ),
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
  final colorScheme = Theme.of(context).colorScheme;
  switch (noteType) {
    case NoteType.content:
      return colorScheme.primaryFixedDim;
    case NoteType.experience:
      return colorScheme.secondaryFixedDim;
    case NoteType.action:
      return colorScheme.tertiaryFixedDim;
    case NoteType.thought:
      return colorScheme.surfaceDim;
  }
}
  @override
  Widget build(BuildContext context) {
    // style
    const double cardBoarderRadius = 10;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    Color chooseColor = getColor(widget.noteType);
    EdgeInsets cardEdgeInsets = const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0.0);

    return Stack(
      children:[ 
      Card(  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBoarderRadius),
        ),
        elevation: 8,
        color: colorScheme.surfaceContainerHighest,
        margin: cardEdgeInsets,
        child: Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
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
                          color: colorScheme.tertiary,
                          onPressed: onExpandPressed,
                          icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                        ),
                        IconButton(
                          iconSize: 28.0,
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
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 26,
           
          child: Container(
            margin: cardEdgeInsets,
            padding: const EdgeInsets.all(6),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: chooseColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.zero, 
                right: Radius.circular(cardBoarderRadius)
              ),
            ),
            child: (
              Text(
                widget.noteType.str,
                style: TextStyle(color: colorScheme.onSurface,)
              )
            )
          ),
        )
      ],
    );
  }
}

