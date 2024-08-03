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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavbar(navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/note',
              builder: (context, state) => const NotesPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: ':noteId',
                  builder: (context, state) => ViewNotePage(noteId: state.pathParameters['noteId']),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'editnote',
                      builder: (context, state) => EditNotePage(noteId: state.pathParameters['noteId']),
                    ),
                  ]
                )
              ],
            ),
          ],
        ),

        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/book',
            builder: (context, state) => const BookshelfPage(),
            routes: <RouteBase>[
              GoRoute(
                path: ':bookId',
                builder: (context, state) => BookDetailPage(bookId: state.pathParameters['bookId']!),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'editbook',
                    builder: (context, state) => EditBookPage(bookId: state.pathParameters['bookId']),
                  ),
                  GoRoute(
                    path: 'reading',
                    builder: (context, state) => ReadingPage(bookId: state.pathParameters['bookId']),
                  ),
                  GoRoute(
                    path: 'addnote',
                    builder: (context, state) => AddNotePage(bookId: state.pathParameters['bookId']),
                  ),
                  GoRoute(
                    path: 'chatnote',
                    builder: (context, state) => ChatNotePage(bookId: state.pathParameters['bookId']),
                  ),        
                ]
              )
            ],
          ),
        ]),


        // The route branch for 3º Tab
        StatefulShellBranch(routes: <RouteBase>[
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
                    builder: (context, state) => AddBookPage(bookId: state.pathParameters['bookId']),
                  ),
                ]
              ),
            ]
          ),
        ]),


        // The route branch for 4º Tab
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/activity',
            builder: (context, state) => const FeedPage(),
          ),
        ]),


        // The route branch for 5º Tab
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
            routes: <RouteBase>[
              GoRoute(
                path: 'friendlist',
                builder: (context, state) => FriendListPage(),
              ),
              GoRoute(
                path: 'setting',
                builder: (context, state) => SettingPage(),
              ),
            ]
          ),
        ])
      ],
    ),
  ],
);


class NavigationService {
  late final GoRouter _router;

  NavigationService() {
    _router = router;
  }

  String currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  void goViewNote(String noteid) { _router.push('/note/$noteid');}
  void goEditNote(String noteid) { _router.go('/note/$noteid/editnote');}
  void goBookDetail(String bookid) { _router.push('/book/$bookid');}
  void goEditBook(String bookid) { _router.go('/book/$bookid/editbook');}
  void goReading(String bookid) { _router.push('/book/$bookid/reading');}
  void goAddNote(String bookid) { _router.push('/book/$bookid/addnote');}
  void goChatNote(String bookid) { _router.go('/book/$bookid/chatnote');}
  void goSearchBook() { _router.push('/home/searchbook');}
  void goAddBook(String bookid) { _router.go('/home/searchbook/$bookid');}
  void goFriendList() { _router.go('profile/friendlist'); }
  void goSetting() { _router.go('/profile/setting');}

  void pop() { _router.pop(); }
}