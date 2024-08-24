import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/theme/appbar_icon_style.dart';
import 'package:reading_app/ui/widget/note_container.dart';
import 'package:reading_app/ui/widget/searching_dialog.dart';
import 'package:reading_app/view_models/notes_vm.dart';

class NotePage extends StatefulWidget {
  
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String _searchCondition = "";
  List<Note> notes = [];
    
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
      body: Consumer<NotesViewModel>(
        builder: (context, viewModel, _) {
          List<Note> notes = viewModel.notes;

          if(notes.isEmpty) {
            return const Center(child: Text('No Notes.'));
          } else {
            return ListView( 
              children: notes.map((item) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: NoteContainer(note: item,),
                )).toList(), 
            );
          }
        }
      )
    );
  }
}

