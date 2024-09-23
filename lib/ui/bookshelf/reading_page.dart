import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/user_book.dart';
import 'package:reading_app/data/models/reading_session.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';
import 'package:reading_app/view_models/readingsession_vm.dart';

class ReadingPage extends StatefulWidget {
  final String userBookId;

  const ReadingPage({
    super.key,
    required this.userBookId,
  });

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  Timer? _timer;
  final ValueNotifier<int> _elapsedSeconds = ValueNotifier<int>(0);
  bool _isRunning = false;
  int? _startPage;
  int? _endPage;
  DateTime? _startTime;
  DateTime? _endTime;

  final TextEditingController _startPageController = TextEditingController();
  final TextEditingController _endPageController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _elapsedSeconds.dispose();
    _startPageController.dispose();
    _endPageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _startTime ??= DateTime.now();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _elapsedSeconds.value++;
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  Future<void> _endReadingSession() async {
    _pauseTimer();
    _endTime = DateTime.now();
    await _showPageInputDialog();
  }

  Future<void> _showPageInputDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('請輸入頁碼'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _startPageController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '開始頁碼',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _endPageController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '結束頁碼',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                ReadingSession newSession = await _addReadingSession();
                _showStatisticsDialog(newSession);
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  Future<ReadingSession> _addReadingSession() async {
    _startPage = int.tryParse(_startPageController.text);
    _endPage = int.tryParse(_endPageController.text);

    final newReadingSession = ReadingSession(
      userBookId: widget.userBookId,
      startTime: Timestamp.fromDate(_startTime!),
      endTime: Timestamp.fromDate(_endTime!),
      startPage: _startPage,
      endPage: _endPage,
      duration: _elapsedSeconds.value,
      earnedExp: _elapsedSeconds.value,
    );

    ReadingSessionViewModel readingSessionViewModel =
        Provider.of<ReadingSessionViewModel>(context, listen: false);
    await readingSessionViewModel.addReadingSession(newReadingSession);

    return newReadingSession;
  }

  Future<void> _showStatisticsDialog(ReadingSession session) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        return AlertDialog(
          title: const Text('閱讀統計'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('開始時間: ${formatter.format(session.startTime.toDate())}'),
              Text('結束時間: ${formatter.format(session.endTime.toDate())}'),
              Text('閱讀時間: ${_formatTime(session.duration)}'),
              Text('開始頁數: ${session.startPage ?? 'N/A'}'),
              Text('結束頁數: ${session.endPage ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<NavigationService>(context, listen: false).pop();
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nav = Provider.of<NavigationService>(context, listen: false);
    final viewModel = Provider.of<UserBooksViewModel>(context);

    return FutureBuilder<UserBook?>(
      future: viewModel.getUserBook(widget.userBookId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final userBook = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  nav.pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 128, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TimerText(elapsedSeconds: _elapsedSeconds),
                      const SizedBox(height: 32),
                      Image.network(
                        userBook.book.coverImage!,
                        width: 140,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userBook.book.title,
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: _isRunning ? _pauseTimer : _startTimer,
                        child: Text(_isRunning
                            ? '暫停'
                            : (_startTime == null ? '開始' : '繼續')),
                      ),
                      const SizedBox(height: 16),
                      if (!_isRunning && _startTime != null) ...[
                        FilledButton(
                          onPressed: _endReadingSession,
                          child: const Text('結束'),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data found'));
        }
      },
    );
  }
}

class TimerText extends StatelessWidget {
  final ValueNotifier<int> elapsedSeconds;

  const TimerText({super.key, required this.elapsedSeconds});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: elapsedSeconds,
      builder: (context, value, child) {
        return Text(
          _formatTime(value),
          style: Theme.of(context).textTheme.headlineLarge,
        );
      },
    );
  }
}

String _formatTime(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}
