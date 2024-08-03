import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:reading_app/main.dart';
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
import 'package:reading_app/ui/notes/edit_note_page.dart';
import 'package:reading_app/ui/notes/notes.dart';
import 'package:reading_app/ui/notes/viewnote_page.dart';
import 'package:reading_app/ui/profile/friend_list_page.dart';
import 'package:reading_app/ui/profile/profile.dart';
import 'package:reading_app/ui/profile/setting_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavbar(child);
      },
      routes: [
        // Note Routes
        GoRoute(
          path: '/note',
          builder: (context, state) => const NotesPage(),
          routes: [
            GoRoute(
              path: ':noteId',
              builder: (context, state) => ViewNotePage(noteId: state.pathParameters['noteId']),
              routes: [
                GoRoute(
                  path: 'editnote',
                  builder: (context, state) => EditNotePage(noteId: state.pathParameters['noteId']),
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
              builder: (context, state) => BookDetailPage(bookId: state.pathParameters['bookId']!),
              routes: [
                GoRoute(
                  path: 'editbook',
                  builder: (context, state) => EditBookPage(bookId: state.pathParameters['bookId']!),
                ),
                GoRoute(
                  path: 'reading',
                  builder: (context, state) => ReadingPage(bookId: state.pathParameters['bookId']!),
                ),
                GoRoute(
                  path: 'addnote',
                  builder: (context, state) => AddNotePage(bookId: state.pathParameters['bookId']!),
                ),
                GoRoute(
                  path: 'chatnote',
                  builder: (context, state) => ChatNotePage(bookId: state.pathParameters['bookId']!),
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
                  builder: (context, state) => AddBookPage(bookId: state.pathParameters['bookId']!),
                ),
              ],
            ),
          ],
        ),
        // Activity Route
        GoRoute(
          path: '/activity',
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
  }

  void goNote() { _goRoute('/note'); }
  void goBookshelf() { _goRoute('/book'); }
  void goHome() { _goRoute('/home'); }
  void goFeed() { _goRoute('/feed'); }
  void goProfile() { _goRoute('/profile'); }
  void goViewNote(String noteId) { _goRoute('/note/$noteId'); }
  void goEditNote(String noteId) { _goRoute('/note/$noteId/editnote'); }
  void goBookDetail(String bookId) { _goRoute('/book/$bookId'); }
  void goEditBook(String bookId) { _goRoute('/book/$bookId/editbook'); }
  void goReading(String bookId) { _goRoute('/book/$bookId/reading'); }
  void goAddNote(String bookId) { _goRoute('/book/$bookId/addnote'); }
  void goChatNote(String bookId) { _goRoute('/book/$bookId/chatnote'); }
  void goSearchBook() { _goRoute('/home/searchbook'); }
  void goAddBook(String bookId) { _goRoute('/home/searchbook/$bookId'); }
  void goFriendList() { _goRoute('/profile/friendlist'); }
  void goSetting() { _goRoute('/profile/setting'); }

  void pop() {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
      if (_navigationStack.isNotEmpty) {
        final previousRoute = _navigationStack.removeLast();
        _router.go(previousRoute);
      } else {
        _router.pop();
      }
    } else {
      _router.pop();
    }
  }
}
