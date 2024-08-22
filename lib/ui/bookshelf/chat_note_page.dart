import 'dart:developer';

import 'package:flutter/material.dart';


class ChatNotePage extends StatefulWidget{
  final String bookId;
  const ChatNotePage({
    super.key, 
    required this.bookId,
  });

  @override
  State<ChatNotePage> createState() => _ChatNotePageState();
}

class _ChatNotePageState extends State<ChatNotePage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTextEmpty = true;

  List<Widget> content = [
    _ConversationDialog(text: "太棒了！今天的閱讀完成了！來分享一下今天看到什麼新知嗎？", isUser: false),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(
        onPressed: () => {}, // ask 
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text("沒問題"),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(
        onPressed: () => {}, // confirm and quit chatNote page 
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text("先跳過"),
        ),
      ),
    ),
  ];

  Future<void> _getResponse() async {
    setState(() {
      log("state change: API wait");
      content.add(_ConversationDialog(text: '...', isUser: false));
      content = List.from(content);
    });
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      log("state change: API get");
      content.removeLast();
      content.add(_ConversationDialog(text: 'abcd', isUser: false));
      content = List.from(content);
    });
    _scrollToBottom();
  }

  Future<void> _userSubmit(String value) async {
    setState(() {
      content.add(_ConversationDialog(text: value, isUser: true));
      content = List.from(content);
      log("state change: user submit");
    });
    _textController.clear();
    _scrollToBottom();

    await _getResponse();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        log("scrolling to bottom, with length ${content.length}");
        log('maxScrollExtent: ${_scrollController.position.maxScrollExtent}');
        log('current scroll position: ${_scrollController.position.pixels}');
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }



  void _handleTextChange() {
    setState(() {
      _isTextEmpty = _textController.text.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    log("rebuilt");

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              controller: _scrollController,
              children: content,
            ),
          ),
        ),
        Container(
          color: colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: textTheme.bodyLarge,
                    controller: _textController,
                    onSubmitted: (value) => _userSubmit(value),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "在此輸入",
                      hintStyle: textTheme.labelMedium?.copyWith(color: colorScheme.outline),
                    ),
                  ),
                ),
              ),
              _isTextEmpty
                  ? const SizedBox()
                  : SizedBox(
                      child: IconButton(
                        onPressed: () => _userSubmit(_textController.text),
                        icon: const Icon(Icons.send, size: 24),
                      ),
                    ),
            ],
          ),
        ),
      ],
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
          const Icon(
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
          const Icon(
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
            ),
          ),
        ),
      ]
    );
  }
}
