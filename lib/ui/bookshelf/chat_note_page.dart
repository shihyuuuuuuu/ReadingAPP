import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/reading_session.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/ui/bookshelf/chat_note_vm.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

class ChatNotePage extends StatelessWidget {
  // final String bookId;
  final ReadingSession readingSession;

  const ChatNotePage({
    super.key, 
    // required this.bookId, 
    required this.readingSession
  });

  @override
  Widget build(BuildContext context) {
    // final apiKey = Platform.environment['GEMINI_API_KEY'];
    const apiKey = 'AIzaSyDcO8S_trwkrDBEYQ68Xl0hKgKRAvQhn18';

    return FutureBuilder<String>(
      future: loadPrompt(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();  // Show a loading indicator while loading the prompt.
        }
        String prompt = snapshot.data!;
        return ChangeNotifierProxyProvider<UserBooksViewModel,  ChatNoteViewModel> (
          create:  (_) => ChatNoteViewModel(
            context.read<UserBooksViewModel>(),
            apiKey: apiKey, 
            prompt: prompt, 
            // userBookId: bookId, 
            readingSession: readingSession,
          ),
          update: (context, userBookModel,  notifier) 
            => notifier!..update(userBookModel),
          child: const ChatNoteView(),
        );
      }
    );
  }
  Future<String> loadPrompt() async {
    return await rootBundle.loadString('assets/conversation_prompt.txt');
  }
}


class ChatNoteView extends StatefulWidget{
  const ChatNoteView({
    super.key, 
  });
  
  @override
  State<ChatNoteView> createState() => _ChatNoteViewState();
}


class _ChatNoteViewState extends State<ChatNoteView> {
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

 
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    
    final chatNoteViewModel = Provider.of<ChatNoteViewModel>(context);

    // Scroll after chat content updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatNoteViewModel.scrollToBottom();
    });

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
              controller: chatNoteViewModel.scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ConversationDialog(
                        text: "太棒了！今天的閱讀完成了！\n來回憶一下剛剛看了什麼吧", 
                        isUser: false
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                            onPressed: chatNoteViewModel.startChat
                              ? null
                              :(){
                                chatNoteViewModel.sendStart();
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
                              child: Text("今天先跳過"),
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
                      return chatNoteViewModel.chatContent[index];
                    },
                    childCount: chatNoteViewModel.chatContent.length,
                  ),
                ),
              ],
            )
          ),
        ),
        chatNoteViewModel.noteTakingFinish ?
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FilledButton(
            // TODO: (再看看之後的設計邏輯是怎樣) 儲存note, nav to ViewNote
            onPressed: ()=>{ chatNoteViewModel.genNote(context) }, 
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("產生筆記"),
            )
          ),
        ): const SizedBox(),

        _InputField(
          enable: chatNoteViewModel.startChat, 
          submitCallback: chatNoteViewModel.userSubmit
        ),
      ],
    )
    );
  }
}

class _InputField extends StatefulWidget {
  final bool enable;
  final void Function(String) submitCallback;

  const _InputField({
    super.key, 
    required this.enable, 
    required this.submitCallback
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  final TextEditingController _textController = TextEditingController();
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleTextChange);

  }

  void _handleTextChange() {
    setState(() {
      _isTextEmpty = _textController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: !widget.enable,
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
                    onPressed: () {
                      widget.submitCallback(_textController.text);
                      _textController.clear();
                    },
                    icon: const Icon(Icons.send, size: 24),
                  ),
                ),
        ],
      ),
    );
  }
}
