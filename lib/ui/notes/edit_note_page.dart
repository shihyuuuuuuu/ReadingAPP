import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/local/note_type.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/notes_vm.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

enum _WhichPage {
  start(str: "起始頁"),
  end(str: "結束頁");

  final String str;

  const _WhichPage({
    required this.str,
  });
}

class EditNotePage extends StatelessWidget{
  // if noteId == "", then create a new note
  final String noteId;
  final String userBookId;

  EditNotePage({
    required this.noteId,
    required this.userBookId,
  });

  @override
  Widget build(BuildContext context) {
    // how much resources it take
    final noteViewModel = Provider.of<NotesViewModel>(context);
    
    
    // 如果是空的話要先建立model比較好還是不先建立model比較好
    if (noteId == '-') {
      //if the note is new, then create a new note
      return _editScaffold(note: Note.emptyNote(userBookId: userBookId));
    } else {
      //else fetch the data from db
      return FutureBuilder<Note?>(
        future: noteViewModel.getNote(noteId, userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {

            // initialize data from db
            Note note = snapshot.data!;
            return _editScaffold(note: note);
          }
          else {
              return const Center(child: Text('No data found'));
          }
        }
      );
    }

  }
}
class _editScaffold extends StatefulWidget {
  final Note note;

  _editScaffold({
    required this.note,
  });

  @override
  State<_editScaffold> createState() => _editScaffoldState();
}

class _editScaffoldState extends State<_editScaffold> {

  late Note note;

  // TODO update note.type here!
  void dropDownChange(NoteType? newType) { 
    if (newType != null) {
      note.type = newType;
    }
  }

  // TODO update note.start/endpage here!
  void changePage(String? page, _WhichPage whichPage) {
    int? parsedPage = (page?.isNotEmpty == true )
                        ? int.parse(page!) 
                        : null;

    if (whichPage == _WhichPage.start) {
      note.startPage = parsedPage;
    } else {
      note.endPage = parsedPage;
    }
  }


  @override
  void initState() {
    super.initState();
    note = widget.note;
  }
  
  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    final noteViewModel = Provider.of<NotesViewModel>(context);
    final userBookViewModel = Provider.of<UserBooksViewModel>(context);

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormatter = DateFormat('yyyy-MM-dd');

    // TODO: 暫定
    int columnMinLine = ((MediaQuery.sizeOf(context).height - 480) / 20).round();
    if (columnMinLine < 5) { columnMinLine = 5; }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {nav.pop()}, 
          ),
        title: Text(
          note.title.isEmpty? "note title": note.title, 
          style: textTheme.bodyMedium!.copyWith(color:colorScheme.outline)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save), 
            color: colorScheme.primary,
            onPressed: () {
              noteViewModel.updateNote(note, note.id!, userId);
            }, 
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.menu_book), 
              color: colorScheme.primary,
              // check saved and go view? or view directly?
              onPressed: () => { }, 
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: TextEditingController()..text = note.title,
                  onChanged: (text) => { 
                    // TODO how to update the title
                  },
                  style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    hintText: "在此輸入筆記標題",
                    border: InputBorder.none,
                  ),
                ),
                TextField(
                  controller: TextEditingController()..text = note!.content,
                  onChanged: (text) => {
                    note.content = text
                  },
                  style: textTheme.bodyLarge,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: columnMinLine,
                  decoration: const InputDecoration(
                    hintText: "在此輸入筆記內容",
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 6,),
                Row(
                  children: [
                    Text("筆記類別", style:textTheme.bodyMedium),
                    SizedBox(width: 15,),
                    SizedBox(
                      width: 180,
                      child: DropdownButtonFormField<NoteType>(
                        dropdownColor: note.type.color,
                        iconSize: 24,
                        iconEnabledColor: colorScheme.onPrimary,
                        value: note.type,
                        style: textTheme.bodyMedium,
                        onChanged: dropDownChange,
                        decoration: InputDecoration(
                          
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: colorScheme.outlineVariant),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          filled: true,
                          fillColor: note.type.color,
                        ),
                        items: NoteType.values.map((NoteType noteTypeItem) {
                          return DropdownMenuItem<NoteType>(
                            value: noteTypeItem,
                            child: Text(noteTypeItem.str, style: textTheme.labelLarge!.copyWith(color: colorScheme.onPrimary)));
                        }).toList(),
                        itemHeight: 50,
                        hint: Text("筆記類型", style: textTheme.labelMedium),
                      ),
                    ),
                  ],
                ),
                _pageInput(
                  whichPage: _WhichPage.start,
                  pageNum: note.startPage, 
                  callback: changePage,
                ),
                _pageInput(
                  whichPage: _WhichPage.end,
                  pageNum: note.endPage,
                  callback: changePage,
                ),
                SizedBox(height: 6,),
                FutureBuilder<UserBook?>(
                  future: userBookViewModel.getUserBook(note.userBookId, userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          "書籍 ⟪${snapshot.data!.book.title}⟫", 
                          style: textTheme.bodyMedium
                        ),
                      );
                    } else {
                      return const Center(child: Text('No data found'));
                    }
                  }
                ),
                // const SizedBox(height: 6,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('紀錄時間: ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(note!.createdAt.millisecondsSinceEpoch))}',
                      style: textTheme.bodyMedium),
                ),
          
                // const SizedBox(height: 6,),
              ]
            ),
          ),
        ),
      )
    );     
  }
}



class _pageInput extends StatelessWidget {
  final _WhichPage whichPage;
  final int? pageNum;
  final Function callback;

  const _pageInput({
    super.key, 
    required this.whichPage, 
    required this.pageNum,
    required this.callback
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(children: [
        Text(whichPage.str, style: textTheme.bodyMedium,),
        const SizedBox(width: 15.0,),
        Expanded(
          child: TextField(
            controller: TextEditingController()..text = 
              pageNum == null ? "": pageNum.toString(),
            onChanged: (value) => { callback(value, whichPage)},
            keyboardType: TextInputType.number,
            style: textTheme.bodyMedium,
            
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(4.0),
            ),
          ),
        )
      ],),
    );
  }
}
