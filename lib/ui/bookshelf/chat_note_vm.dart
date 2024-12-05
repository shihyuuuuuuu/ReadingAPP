import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/models/reading_session.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/notes_vm.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';
import 'package:retry/retry.dart';
import 'package:requests/requests.dart';

class ChatNoteViewModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final List<ConversationDialog> chatContent = [];
  // final String userBookId;
  final ReadingSession readingSession;
  // late GenerativeModel model;
  // late ChatSession chat;
  List<Map<String, String>> chatHistory = [];
  final Map<String, String> headers = {
    'Authorization': 'API_KEY',
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> payload = {
    "providers": ["openai"],
    "chatbot_global_action": "Act as an assistant",
    "previous_history": [],
    "temperature": 0.7,
    "max_tokens": 200,
    "fallback_providers": "replicate",
    "text": "",
  };


  UserBooksViewModel userBooksViewModel;
  // NotesViewModel notesViewModel;

  bool _noteTakingFinish = false;
  bool _startChat = false; // whether the chat is start
  bool _textFieldEnable = false; // whether text field is enable

  bool get noteTakingFinish => _noteTakingFinish;
  bool get startChat => _startChat;
  bool get textFieldEnable => _textFieldEnable;

  ChatNoteViewModel(
    this.userBooksViewModel,  
    // this.notesViewModel,
    {
    // required this.userBookId, 
    required String apiKey, 
    required String prompt,
    required this.readingSession,}) {
    _initializeModel(apiKey, prompt);
  }

  void _initializeModel(String apiKey, String prompt) {
    chatHistory.add({'role': 'assistant', 'message': prompt});
  }

  Future<String> fetchResponseText(
    Map<String, String> headers, Map<String, dynamic> payload
  ) async {
    const String url = 'https://api.edenai.run/v2/text/chat';
    var r = await Requests.post(
      url,
      headers: headers,
      json: payload,
    );

    if (r.statusCode == 200) {
      Map<String, dynamic> response = r.json();
      print(response);
      return response['openai/gpt-3.5-turbo']['generated_text'];
    }

    return 'Error: ${r.statusCode}';
  }

  Future<void> sendStart() async {

    UserBook? userbook = await userBooksViewModel.getUserBook(readingSession.userBookId);
  
    String bookTitle = userbook!.book.title;
    payload['previous_history'] = chatHistory;
    payload['text'] = '今天閱讀的書： $bookTitle';

    String responseText = await fetchResponseText(headers, payload);
    print(responseText);
    chatHistory.add({'role': 'assistant', 'message': responseText});
    chatContent.add(ConversationDialog(text: responseText, isUser: false));

    _startChat = true;
    _textFieldEnable = true;

    notifyListeners();
  }

  Future<void> userSubmit(String userInput) async {
    _textFieldEnable = false;

    chatHistory.add({'role': 'user', 'message': userInput});
    chatContent.add(ConversationDialog(text: userInput, isUser: true));
    notifyListeners();

    await _getResponse(userInput);
  }

  Future<void> _getResponse(String userInput) async {
    chatContent.add(const ConversationDialog.loadingDialog());
    notifyListeners();

    print('[user input]: $userInput');
    // var content = Content.text(userInput);
    final r = RetryOptions(maxAttempts: 3); // Retry up to 3 times

    payload['previous_history'] = chatHistory;
    payload['text'] = userInput;
    try {
      await r.retry(
        () async {
          String responseText = await fetchResponseText(headers, payload);
          String text = responseText.replaceAll('\n', '');
          print(responseText);
          text = text.replaceAll(' ', '');
          text = text.replaceAll('**', '');

          if (text.endsWith('<end>')) {
            _noteTakingFinish = true;
            text = text.replaceAll('<end>', '');
          }

          chatContent.removeLast();
          chatHistory.add({'role': 'assistant', 'message': text});
          chatContent.add(ConversationDialog(text: text, isUser: false));
          _textFieldEnable = true;

          notifyListeners();

        },
        // Retry on specific exceptions
        // retryIf: (e) => e is ServerException || e is GenerativeAIException,
      );
    } catch (e) {
      print('Failed after retrying: $e');
    }
  }

  Future genNote(BuildContext context) async{

    var notesViewModel = Provider.of<NotesViewModel>(context, listen: false);
    var nav = Provider.of<NavigationService>(context, listen: false);

    String notePrompt = await rootBundle.loadString('assets/note_prompt.txt');
    chatHistory.add({'role': 'assistant', 'message': notePrompt});
    payload['previous_history'] = chatHistory;
    payload['max_tokens'] = 500;

    String responseText = await fetchResponseText(headers, payload);
    print(responseText);
    // var content = Content.text(notePrompt);
    // var response = await chat.sendMessage(content);

    Map<String, dynamic> data = json.decode(responseText);
    Timestamp now = Timestamp.now();


    final userBook = <String, dynamic>{'userBookId': readingSession.userBookId};
    final createdAt = <String, dynamic>{'createdAt': now};
    final updatedAt = <String, dynamic>{'updatedAt': now};
    final startPage = <String, dynamic>{'startPage': readingSession.startPage};
    final endPage = <String, dynamic>{'endPage': readingSession.endPage};
    final rsId = <String, dynamic>{'readingSessionId': readingSession.id};
    data.addEntries(createdAt.entries);
    data.addEntries(updatedAt.entries);
    data.addEntries(userBook.entries);
    data.addEntries(startPage.entries);
    data.addEntries(endPage.entries);
    data.addEntries(rsId.entries);
    Note note = Note.fromMap(data, 'emptyid');

    note.id = await notesViewModel.addNote(note);
    nav.goViewNote(note.id!);

  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  update(UserBooksViewModel userBookModel) {
    userBooksViewModel = userBookModel;
    // notesViewModel = noteModel;
    notifyListeners();
  }
}


class ConversationDialog extends StatelessWidget {
  
  final String text;
  final bool isUser;

  const ConversationDialog({
    super.key, 
    required this.text, 
    required this.isUser
  });

  const ConversationDialog.loadingDialog()
    :text='...', isUser=false;

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

