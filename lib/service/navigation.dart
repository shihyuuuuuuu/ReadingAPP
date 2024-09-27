import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/reading_session.dart';
import 'package:reading_app/service/authentication.dart';
import 'package:reading_app/ui/bookshelf/book_detail_page.dart';
import 'package:reading_app/ui/bookshelf/bookshelf_page.dart';
import 'package:reading_app/ui/bookshelf/chat_note_page.dart';
import 'package:reading_app/ui/bookshelf/reading_page.dart';
import 'package:reading_app/ui/home/add_book_page.dart';
import 'package:reading_app/ui/home/home.dart';
import 'package:reading_app/ui/login/login_page.dart';
import 'package:reading_app/ui/notes/edit_note_page.dart';
import 'package:reading_app/ui/notes/note_page.dart';
import 'package:reading_app/ui/notes/viewnote_page.dart';
import 'package:reading_app/ui/widget/scaffold_with_navbar.dart';
import 'package:reading_app/view_models/notes_vm.dart';
import 'package:reading_app/view_models/readingsession_vm.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

String? userId;

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    ShellRoute(
      navigatorKey: _sectionNavigatorKey,
      builder: (context, state, child) {
        userId = Provider.of<AuthenticationService>(context, listen: false)
            .checkAndGetLoggedInUserId();

        log("rebuild shellroute");
        if (userId == null) {
          log('Warning: ShellRoute should not be built without a user');
          return const SizedBox.shrink();
        }
        // the provider will be disposed automatically when it is not in widget tree
        return ChangeNotifierProvider(
          create: (_) => UserBooksViewModel(userId: userId!),
          child: ScaffoldWithNavbar(child),
        );
      },
      routes: [
        // Note Routes
        ShellRoute(
          builder: (context, state, child) {
            final userId = Provider.of<AuthenticationService>(context, listen: false)
            .checkAndGetLoggedInUserId();
        
            if (userId == null) {
              log('Warning: ShellRoute should not be built without a user');
              return const SizedBox.shrink();
            }
            return ChangeNotifierProvider(
              create: (_) => NotesViewModel(userId: userId!),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/note',
              builder: (context, state) => const NotePage(),
              routes: [
                GoRoute(
                  path: 'chatnote',
                  builder: (context, state) {
                      ReadingSession rs = state.extra as ReadingSession;
                      return ChatNotePage(readingSession: rs);
                  }
                ),
                GoRoute(
                  path: ':noteId',
                  builder: (context, state) =>
                      ViewNotePage(noteId: state.pathParameters['noteId']),
                  routes: [
                    GoRoute(
                      path: ':userBookId',
                      builder: (context, state) => EditNotePage(
                        noteId: state.pathParameters['noteId']!,
                        userBookId: state.pathParameters['userBookId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Book Routes
        GoRoute(
          path: '/book',
          builder: (context, state) => const BookshelfPage(),
          routes: [
            GoRoute(
              path: ':bookId',
              builder: (context, state) =>
                  BookDetailPage(userBookId: state.pathParameters['bookId']!),
              routes: [
                GoRoute(
                  path: 'reading',
                  builder: (context, state) {
                    return ChangeNotifierProvider(
                      create: (_) => ReadingSessionViewModel(userId: userId!),
                      child: ReadingPage(
                          userBookId: state.pathParameters['bookId']!),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // Home Routes
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: 'addBook',
              builder: (context, state) =>
                  AddBookPage(),
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // final currentPath = state.uri.path;
    final isLoggedIn =
        Provider.of<AuthenticationService>(context, listen: false)
                .checkAndGetLoggedInUserId() !=
            null;
    log("current path ${state.uri.path}");
    if (isLoggedIn && state.uri.path == '/login') {
      return '/home';
    }
    if (!isLoggedIn && state.uri.path != '/login') {
      return '/login';
    }
    return null;
  },
);


class NavigationService {
  late final GoRouter _router;
  final List<String> _navigationStack = [];

  NavigationService() {
    _router = router;
  }

  String currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  void _goRoute(String route, [bool popBack=true]) {
    if (popBack) {
      _navigationStack.add(route);
    }
    _router.go(route);
    log('Go route: $route, with current stacks: ${_navigationStack.join("")}');
  }

  void _goAndClearRoute() {
    _navigationStack.clear();
  }

  void goNote() {
    _goAndClearRoute();
    _goRoute('/note');
  }
  
  void goChatNote(ReadingSession rs) {
    // _goRoute('/note/chatnote/$userBookId', extra: rs);
    _router.go('/note/chatnote', extra: rs);
    log('Go route: /note/chatnote, with current stacks: ${_navigationStack.join("")}');
  }

  void goViewNote(String noteId) {
    _goRoute('/note/$noteId', false);
  }

  void goEditNote(String noteId, String userBookId) {
    _goRoute('/note/$noteId/$userBookId', false);
  }
  
  void goBookshelf() {
    _goAndClearRoute();
    _goRoute('/book');
  }

  void goBookDetail(String bookId) {
    _goRoute('/book/$bookId');
  }

  void goReading(String bookId) {
    _goRoute('/book/$bookId/reading', false);
  }

  void goHome() {
    _goAndClearRoute();
    _goRoute('/home');
  }

  void goAddBook(String bookId) {
    _goRoute('/home/searchbook/$bookId');
  }


  void pop(context) {
    if (_navigationStack.isNotEmpty) {
      if(_navigationStack.last == currentPath(context)) {
        _navigationStack.removeLast();
      }
      if (_navigationStack.isNotEmpty) {
        final previousRoute = _navigationStack.last;
        _router.go(previousRoute);
      } else {
        _router.pop();
      }
    } else {
      _router.pop();
    }
  }
}
