import 'dart:collection';

import 'package:flutter/material.dart';

class ChatNotePage extends StatelessWidget{
  final bookId;
  ChatNotePage({
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _SlideBar(),
          _ConversationDialog(text: "text", isUser: false),
          _ConversationDialog(text: "Hi there! How are you? I am quite good. It is a nice day", isUser: true),
          FilledButton(onPressed: () => {}, child: Text("沒問題！")),
          FilledButton(onPressed: () => {}, child: Text("下次再說")),
          FilledButton(onPressed: () => {}, child: Text("產生筆記")),
        ],
      ),
    );
  }
}

class _SlideBar extends StatefulWidget{
  @override
  State<_SlideBar> createState() => _SlideBarState();
}

class _SlideBarState extends State<_SlideBar> {
  double _currentSliderValue = 20;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mood_bad,
            size: 40.0,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: colorScheme.primary,
                inactiveTrackColor: colorScheme.outlineVariant,
                thumbColor: colorScheme.tertiaryContainer,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 16.0,),
                trackHeight: 10.0,
              ),
              child: Slider(
                value: _currentSliderValue,
                min: 0,
                max: 100,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ),
          ),
          Icon(
            Icons.mood,
            size: 40.0,  
          ),
        ],
      ),
    );
  }
}

class _ConversationDialog extends StatelessWidget {
  
  final String text;
  final bool isUser;

  const _ConversationDialog({
    super.key, 
    required this.text, 
    required this.isUser
  });

  static double iconSize = 40;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: iconSize/2),
          child: Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: isUser? colorScheme.surfaceContainerLowest: colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: colorScheme.outline,
                width: 1.0,
              
             ),
             borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: iconSize/2 + 5, right: 15.0, left: 15.0, bottom: 12.0),
              child: Text(text, style: textTheme.bodyLarge),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: isUser ? 30 : null,
          left: isUser ? null : 30,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: isUser? colorScheme.tertiaryContainer:colorScheme.primary,
            ),
            child: Icon(
              isUser ? Icons.face: Icons.face_2, 
              size: iconSize,
              // color: colorScheme.primary,
            ),
          ),
        ),
      ]
    );
  }
}
