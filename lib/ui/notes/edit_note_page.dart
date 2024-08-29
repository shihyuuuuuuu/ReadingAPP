import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/local/note_type.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/notes_vm.dart';

class EditNotePage extends StatefulWidget{
  final noteId;
  EditNotePage({
    required this.noteId,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  NoteType? noteType;
  void dropDownChange(NoteType? newType) { 
    if (newType != null) {
    setState(() {
      noteType = newType;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = Provider.of<NotesViewModel>(context);
    final dateFormatter = DateFormat('yyyy-MM-dd');

    // TODO: 暫定
    int columnMinLine = ((MediaQuery.sizeOf(context).height - 460) / 20).round();
    if (columnMinLine < 5) { columnMinLine = 5; }


    return FutureBuilder<Note?>(
      future: viewModel.getNote(widget.noteId, userId),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final note = snapshot.data!;
            noteType ??= note.type;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: colorScheme.surface,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => {nav.pop()}, 
                  ),
                title: Text(note.title, style: textTheme.bodyMedium!.copyWith(color: Colors.grey[400])),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save), 
                    color: colorScheme.primary,
                    onPressed: () => {}, 
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      icon: const Icon(Icons.menu_book), 
                      color: colorScheme.primary,
                      onPressed: () => {nav.goViewNote(widget.noteId)}, 
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
                          onChanged: (text) => {},
                          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            hintText: "在此輸入筆記標題",
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 6,),
                        
                        // TODO: book title
                        Row(
                          children: [
                            Text("⟪book title⟫", style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                            Text(', last update at: ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(note.createdAt.millisecondsSinceEpoch))}',
                                style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                          ],
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          controller: TextEditingController()..text = note.content,
                          onChanged: (text) => {},
                          style: textTheme.bodyLarge,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: columnMinLine,
                          decoration: InputDecoration(
                            hintText: "在此輸入筆記內容",
                            border: InputBorder.none,
                  
                          ),
                        ),
                        Row(
                          children: [
                            Text("筆記類別", style:textTheme.bodyMedium),
                            SizedBox(width: 15,),
                            SizedBox(
                              width: 180,
                              child: DropdownButtonFormField<NoteType>(
                                dropdownColor: noteType==null?Colors.white: noteType!.color,
                                iconSize: 24,
                                iconEnabledColor: colorScheme.onPrimary,
                                value: noteType,
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
                                  fillColor: noteType==null?Colors.white: noteType!.color,
                                ),
                                items: NoteType.values.map((NoteType noteTypeItem) {
                                  return DropdownMenuItem<NoteType>(
                                    value: noteTypeItem,
                                    child: Text(noteTypeItem.str, style: textTheme.labelLarge!.copyWith(color: colorScheme.onPrimary)));
                                }).toList(),
                                itemHeight: 50,
                                hint: Container(
                                  child: Text("筆記類型", style: textTheme.labelMedium),
                                ),
                              ),
                            ),
                          ],
                        ),
                        _pageInput(hintText: "從幾頁", pageNum: note.startPage),
                        _pageInput(hintText: "讀到幾頁", pageNum: note.endPage),
                        
                  
                        // const SizedBox(height: 6,),
                      ]
                    ),
                  ),
                ),
              )
          );
        } else {
            return const Center(child: Text('No data found'));
        }
      }
    );
  }
}

class _pageInput extends StatelessWidget {
  final String hintText;
  final int? pageNum;

  const _pageInput({
    super.key, 
    required this.hintText, 
    required this.pageNum
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        Text(hintText, style: textTheme.bodyMedium,),
        const SizedBox(width: 15.0,),
        Expanded(
          child: TextField(
            controller: TextEditingController()..text = pageNum.toString(),
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