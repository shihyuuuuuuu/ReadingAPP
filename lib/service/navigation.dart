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
                      path: 'startreading',
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
                builder: (context, state) => BookDetailPage(bookId: state.pathParameters['bookId']),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'startreading',
                    builder: (context, state) => EditBookPage(bookId: state.pathParameters['bookId']),
                  ),
                  GoRoute(
                    path: 'edit',
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
                path: 'friends',
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