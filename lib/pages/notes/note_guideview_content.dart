import 'package:flutter/material.dart';
import 'package:reading_app/pages/notes/note_type.dart';



class NoteGuideviewContent extends StatefulWidget {
  final String title;
  final String pages;
  final String date;
  final NoteType noteType;
  final String? description;

  const NoteGuideviewContent({
    super.key,
    required this.title,
    required this.pages,
    required this.date,
    required this.noteType,
    this.description,
  });

  @override
  _NoteGuideviewContentState createState() => _NoteGuideviewContentState();
}

class _NoteGuideviewContentState extends State<NoteGuideviewContent> {
  

  
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
    Color chooseColor = getColor(widget.noteType);
    
    String chooseNoteLabel = getNoteLabel(widget.noteType);
    
    return Stack(
      children:[ 
        Container(
        padding: EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
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
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      subtitle: Text(
                        '${widget.pages}, ${widget.date}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 28.0,
                        // padding: EdgeInsets.only(right: 30),
                        color: Theme.of(context).colorScheme.tertiary,
                        onPressed: onExpandPressed,
                        icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                      ),
                      IconButton(
                        iconSize: 28.0,
                        // padding: EdgeInsets.only(right: 30),
                        color: Theme.of(context).colorScheme.tertiary,
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
                  style: Theme.of(context).textTheme.bodyLarge,
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
            padding: EdgeInsets.all(6),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: chooseColor,
            ),
            child: (
              Text(
                chooseNoteLabel, 
                style: TextStyle(color: Colors.black,)
              )
            )
          ),
        )

      ],
    );
  }
}
