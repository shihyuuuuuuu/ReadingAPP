import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/authentication.dart';
import 'package:reading_app/ui/bookshelf/add_note_page.dart';
import 'package:reading_app/ui/bookshelf/book_detail_page.dart';
import 'package:reading_app/ui/bookshelf/bookshelf_page.dart';
import 'package:reading_app/ui/bookshelf/chat_note_page.dart';
import 'package:reading_app/ui/bookshelf/edit_book_page.dart';
import 'package:reading_app/ui/bookshelf/reading_page.dart';
import 'package:reading_app/ui/feed/feed.dart';
import 'package:reading_app/ui/home/add_book_page.dart';
import 'package:reading_app/ui/home/home.dart';
import 'package:reading_app/ui/home/search_book_page.dart';
import 'package:reading_app/ui/login/login_page.dart';
import 'package:reading_app/ui/notes/edit_note_page.dart';
import 'package:reading_app/ui/notes/note_page.dart';
import 'package:reading_app/ui/notes/viewnote_page.dart';
import 'package:reading_app/ui/profile/friend_list_page.dart';
import 'package:reading_app/ui/profile/profile.dart';
import 'package:reading_app/ui/profile/setting_page.dart';
import 'package:reading_app/ui/widget/scaffold_with_navbar.dart';
import 'package:reading_app/view_models/userbooks_vm.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

// TODO: Use a hardcoded test ID from the Firebase before we can obtain the actual User ID.
// String? userId = 'MXWzgPVPjIjyutDPcBvx';

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
        final userId = Provider.of<AuthenticationService>(context, listen: false)
            .checkAndGetLoggedInUserId();
        log("rebuild shellroute");
         if (userId == null) {
          log('Warning: ShellRoute should not be built without a user');
          return const SizedBox.shrink();
        }
        return ChangeNotifierProvider(
          create: (_) => UserBooksViewModel(userId: userId),
          child: ScaffoldWithNavbar(child),
        );
      },
      routes: [
        // Note Routes
        GoRoute(
          path: '/note',
          builder: (context, state) => const NotePage(),
          routes: [
            GoRoute(
              path: ':noteId',
              builder: (context, state) =>
                  ViewNotePage(noteId: state.pathParameters['noteId']),
              routes: [
                GoRoute(
                  path: 'editnote',
                  builder: (context, state) =>
                      EditNotePage(noteId: state.pathParameters['noteId']),
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
                  path: 'editbook',
                  builder: (context, state) =>
                      EditBookPage(bookId: state.pathParameters['bookId']!),
                ),
                GoRoute(
                  path: 'reading',
                  builder: (context, state) =>
                      ReadingPage(bookId: state.pathParameters['bookId']!),
                ),
                GoRoute(
                  path: 'addnote',
                  builder: (context, state) =>
                      AddNotePage(bookId: state.pathParameters['bookId']!),
                ),
                GoRoute(
                  path: 'chatnote',
                  builder: (context, state) =>
                      ChatNotePage(bookId: state.pathParameters['bookId']!),
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
              path: 'searchbook',
              builder: (context, state) => SearchBookPage(),
              routes: [
                GoRoute(
                  path: ':bookId',
                  builder: (context, state) =>
                      AddBookPage(bookId: state.pathParameters['bookId']!),
                ),
              ],
            ),
          ],
        ),
        // Activity Route
        GoRoute(
          path: '/feed',
          builder: (context, state) => const FeedPage(),
        ),
        // Profile Routes
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
          routes: [
            GoRoute(
              path: 'friendlist',
              builder: (context, state) => FriendListPage(),
            ),
            GoRoute(
              path: 'setting',
              builder: (context, state) => SettingPage(),
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
                .checkAndGetLoggedInUserId() != null;
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

  void _goRoute(String route) {
    _navigationStack.add(route);
    _router.go(route);
    // print('Go route: $route, with current stacks: ${_navigationStack.join("")}');
  }

  void _goAndClearRoute() {
    _navigationStack.clear();
  }

  void goNote() {
    _goAndClearRoute();
    _goRoute('/note');
  }

  void goBookshelf() {
    _goAndClearRoute();
    _goRoute('/book');
  }

  void goHome() {
    _goAndClearRoute();
    _goRoute('/home');
  }

  void goFeed() {
    _goAndClearRoute();
    _goRoute('/feed');
  }

  void goProfile() {
    _goAndClearRoute();
    _goRoute('/profile');
  }

  void goViewNote(String noteId) {
    _goRoute('/note/$noteId');
  }

  void goEditNote(String noteId) {
    _goRoute('/note/$noteId/editnote');
  }

  void goBookDetail(String bookId) {
    _goRoute('/book/$bookId');
  }

  void goEditBook(String bookId) {
    _goRoute('/book/$bookId/editbook');
  }

  void goReading(String bookId) {
    _goRoute('/book/$bookId/reading');
  }

  void goAddNote(String bookId) {
    _goRoute('/book/$bookId/addnote');
  }

  void goChatNote(String bookId) {
    _goRoute('/book/$bookId/chatnote');
  }

  void goSearchBook() {
    _goRoute('/home/searchbook');
  }

  void goAddBook(String bookId) {
    _goRoute('/home/searchbook/$bookId');
  }

  void goFriendList() {
    _goRoute('/profile/friendlist');
  }

  void goSetting() {
    _goRoute('/profile/setting');
  }

  void pop() {
    // print("pop, with current stack: ${_navigationStack.join("")}");
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
      if (_navigationStack.isNotEmpty) {
        final previousRoute = _navigationStack.last;
        _router.go(previousRoute);
      } else {
        _router.pop();
      }
    } else {
      _router.pop();
    }

    // print("after pop, with current stack: ${_navigationStack.join("")}");
  }
}
