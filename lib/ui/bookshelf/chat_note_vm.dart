import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/note.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/notes_vm.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';
import 'package:retry/retry.dart';

class ChatNoteViewModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final List<ConversationDialog> chatContent = [];
  final String userBookId;
  late GenerativeModel model;
  late ChatSession chat;

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
    required this.userBookId, 
    required String apiKey, 
    required String prompt}) {
    _initializeModel(apiKey, prompt);
  }

  void _initializeModel(String apiKey, String prompt) {
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 500),
      systemInstruction: Content.system(prompt),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ],
    );
    chat = model.startChat();
  }

  Future<void> sendStart() async {

    UserBook? userbook = await userBooksViewModel.getUserBook(userBookId, userBooksViewModel.userId);
  
    String bookTitle = userbook!.book.title;

    var response = await chat.sendMessage(Content.text('閱讀書籍：$bookTitle'));

    chatContent.add(ConversationDialog(text: response.text!, isUser: false));

    _startChat = true;
    _textFieldEnable = true;

    notifyListeners();
  }

  Future<void> userSubmit(String userInput) async {
    _textFieldEnable = false;

    chatContent.add(ConversationDialog(text: userInput, isUser: true));
    notifyListeners();

    await _getResponse(userInput);
  }

  Future<void> _getResponse(String userInput) async {
    chatContent.add(const ConversationDialog.loadingDialog());
    notifyListeners();

    print('[user input]: $userInput');
    var content = Content.text(userInput);
    final r = RetryOptions(maxAttempts: 3); // Retry up to 3 times

    try {
      
      final response = await r.retry(

        () async {
          var modelResponse = await chat.sendMessage(content);
          String text = modelResponse.text!.replaceAll('\n', '');
          text = text.replaceAll(' ', '');

          if (text.endsWith('<end>')) {
            _noteTakingFinish = true;
            text.replaceAll('<end>', '');
          }

          chatContent.removeLast();
          chatContent.add(ConversationDialog(text: text, isUser: false));
          _textFieldEnable = true;

          notifyListeners();

        },
        // Retry on specific exceptions
        retryIf: (e) => e is ServerException || e is GenerativeAIException,
      );

    
    } catch (e) {
      print('Failed after retrying: $e');
    }
  }

  Future genNote(BuildContext context) async{

    var notesViewModel = Provider.of<NotesViewModel>(context, listen: false);
    var nav = Provider.of<NavigationService>(context, listen: false);

    String notePrompt = await rootBundle.loadString('assets/note_prompt.txt');
    var content = Content.text(notePrompt);
    var response = await chat.sendMessage(content);

    
    Map<String, dynamic> data = json.decode(response.text!);
    Timestamp now = Timestamp.now();

    final userBook = <String, dynamic>{'userBookId': userBookId};
    final createdAt = <String, dynamic>{'createdAt': now};
    final updatedAt = <String, dynamic>{'updatedAt': now};
    data.addEntries(createdAt.entries);
    data.addEntries(updatedAt.entries);
    data.addEntries(userBook.entries);
    Note note = Note.fromMap(data, 'emptyid');

    note.id = await notesViewModel.addNote(note, notesViewModel.userId);
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

