import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';


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
  bool _noteTakingFinish = false;
  bool _btnEnable = true;

  void _showPopup() async {
    final nav = Provider.of<NavigationService>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("你確定..."),
            content: const Text("真的不記一下筆記嗎"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();  
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                  nav.pop(); // TODO: pop but skip /book/$bookid/reading page
                },
                child: const Text("確認"),
              ),
            ],
          );
      },
    );
  }

  List<Widget> chatContent = [];

  Future<void> _getResponse() async {
    setState(() {
      chatContent.add(const _ConversationDialog(text: '...', isUser: false));
      chatContent = List.from(chatContent);
    });
    _scrollToBottom();

    // TODO: insert API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      chatContent.removeLast();
      chatContent.add(_ConversationDialog(text: 'abcd', isUser: false));
      
      // TODO: 偵測到要結束的語句時
      if (chatContent.length > 6) {
        _noteTakingFinish = true;
      }
      chatContent = List.from(chatContent);
    });
    _scrollToBottom();
  }

  Future<void> _userSubmit(String value) async {
    setState(() {
      chatContent.add(_ConversationDialog(text: value, isUser: true));
      chatContent = List.from(chatContent);
    });
    _textController.clear();
    _scrollToBottom();

    await _getResponse();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
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
    final nav = Provider.of<NavigationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            nav.pop(); // TODO: 同_showPopUP 裡面的 確認
        },),
        title: Text("記筆記", style: textTheme.titleMedium),

      ),
      body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: 之後改成random或由API提供
                      const _ConversationDialog(
                        text: "太棒了！今天的閱讀完成了！\n來回憶一下剛剛看了什麼吧", 
                        isUser: false
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                            onPressed: ()=>{
                              if (_btnEnable) {
                                setState(() {
                                  // TODO: 之後改成random或由API提供
                                  chatContent.add(_ConversationDialog(text: "告訴我今天有什麼新發現", isUser: false));
                                  chatContent = List.from(chatContent);
                                  _btnEnable = false;
                                })
                              }
                            }, // ask 
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("沒問題"),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                            onPressed: _showPopup,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("先跳過"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return chatContent[index];
                    },
                    childCount: chatContent.length,
                  ),
                ),
              ],
            )
          ),
        ),
        _noteTakingFinish ?
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FilledButton(

            // TODO: (再看看之後的設計邏輯是怎樣) 儲存note, nav to ViewNote
            onPressed: ()=>{ nav.goViewNote("noteId") }, 
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("產生筆記"),
            )
          ),
        ): const SizedBox(),
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
    )
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
      alignment: isUser? Alignment.topRight: Alignment.topLeft,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: isUser? 50: 0,  
            left: isUser? 0:50,
            top: 10,
            bottom: 10,
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width / 2,
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Text(text, style: textTheme.bodyLarge),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: isUser ? 0 : null,
          left: isUser ? null : 0,
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

// class _SlideBar extends StatefulWidget{
//   @override
//   State<_SlideBar> createState() => _SlideBarState();
// }

// class _SlideBarState extends State<_SlideBar> {
//   double _currentSliderValue = 20;

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 30.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.mood_bad,
//             size: 40.0,
//           ),
//           Expanded(
//             child: SliderTheme(
//               data: SliderThemeData(
//                 activeTrackColor: colorScheme.primary,
//                 inactiveTrackColor: colorScheme.outlineVariant,
//                 thumbColor: colorScheme.tertiaryContainer,
//                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 16.0,),
//                 trackHeight: 10.0,
//               ),
//               child: Slider(
//                 value: _currentSliderValue,
//                 min: 0,
//                 max: 100,
//                 label: _currentSliderValue.round().toString(),
//                 onChanged: (double value) {
//                   setState(() {
//                     _currentSliderValue = value;
//                   });
//                 },
//               ),
//             ),
//           ),
//           const Icon(
//             Icons.mood,
//             size: 40.0,  
//           ),
//         ],
//       ),
//     );
//   }
// }
