import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/theme/appbar_icon_style.dart';
import 'package:reading_app/data/local/note_type.dart';
import 'package:reading_app/ui/widget/searching_dialog.dart';

class NotePage extends StatefulWidget {
  
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String _searchCondition = "";
  List<Note> notes = [];

  Future<void> readJson() async {
      final String dataStr = await rootBundle.loadString('assets/test_data.json');
      final Map<String, dynamic> data = json.decode(dataStr);
      setState(() { 
        for (var note in data['Note']) {
          note['createdAt'] = Timestamp.fromDate(DateTime.parse(note['createdAt']));
          note['updatedAt'] = Timestamp.fromDate(DateTime.parse(note['updatedAt']));
          final newNote = Note.fromMap(note, note['id']);
          notes.add(newNote);
        }
      }); 
    }
    
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
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Text(
          '我的筆記', 
          style: textTheme.headlineMedium,
        ),
        actions: <Widget>[
          appBarIconStyle(colorScheme, context,  
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _showPopup(context);           // Search logic here
              },
            ),
          )
        ],
      ),
      body: notes != null 
                ? ListView( 
                    // mainAxisAlignment: MainAxisAlignment.center, 
                    children: notes.map((item) => 
                      _NoteContainer(note: item)).toList(), 
                  ) 
                : CircularProgressIndicator(), 
    );
  }
}


class _NoteContainer extends StatefulWidget {
  final Note note;

  const _NoteContainer({
    super.key,
    required this.note,
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

  @override
  Widget build(BuildContext context) {
    // style
    const double cardBoarderRadius = 10;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateFormatter = DateFormat('yyyy-MM-dd');
    
    
    EdgeInsets cardEdgeInsets = const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0.0);
    final nav = Provider.of<NavigationService>(context, listen: false);
    return Stack(
      children:[ 
      Card(  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBoarderRadius),
        ),
        elevation: 8,
        color: colorScheme.surfaceContainer,
        margin: cardEdgeInsets,
        child: InkWell(
          onTap: () => { nav.goViewNote("tt123") },
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.note.title,
                              style: textTheme.titleMedium,
                            ),
                          ),
                          subtitle: Text(
                            'P.${widget.note.startPage}-${widget.note.endPage},  ${
                              dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(widget.note.createdAt.millisecondsSinceEpoch))}',
                            style: textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
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
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10.0, bottom: 20.0),
                    child: Text(
                      widget.note.content,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
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
              color: widget.note.type.color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.zero, 
                right: Radius.circular(cardBoarderRadius)
              ),
            ),
            child: (
              Text(
                widget.note.type.str,
                style: textTheme.labelSmall?.copyWith(color:colorScheme.onSurface,)
              )
            )
          ),
        )
      ],
    );
  }
}

