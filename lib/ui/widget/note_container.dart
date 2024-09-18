
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/service/navigation.dart';

class NoteContainer extends StatefulWidget {
  final Note note;

  const NoteContainer({
    super.key,
    required this.note, 
  });

  @override
  NoteContainerState createState() => NoteContainerState();
}

class NoteContainerState extends State<NoteContainer> {


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
          onTap: () => { nav.goViewNote(widget.note.id!) },
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
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
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10.0, bottom: 20.0),
                  child: Text(
                    widget.note.content,
                    style: textTheme.bodyMedium,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
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
                right: Radius.circular(cardBoarderRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(-2, 0), // changes position of shadow
                ),
                ]
              
            ),
            child: (
              Text(
                widget.note.type.str,
                style: textTheme.labelSmall?.copyWith(color:colorScheme.onInverseSurface,),
              )
            )
          ),
        )
      ],
    );
  }
}

