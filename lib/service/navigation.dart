// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:reading_app/main.dart';
import 'package:reading_app/ui/bookshelf/bookshelf_page.dart';
import 'package:reading_app/ui/feed/feed.dart';
import 'package:reading_app/ui/home/home.dart';
import 'package:reading_app/ui/notes/notes.dart';
import 'package:reading_app/ui/notes/viewnote_page.dart';
import 'package:reading_app/ui/profile/profile.dart';

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
        // The route branch for the 1º Tab
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          // Add this branch routes
          // each routes with its sub routes if available e.g feed/uuid/details
          routes: <RouteBase>[
            GoRoute(
              path: '/note',
              builder: (context, state) => const NotesPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'viewnote',
                  builder: (context, state) => ViewnotePage(),
                )
              ],
            ),
          ],
        ),

        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          // each routes with its sub routes if available e.g shope/uuid/details
          GoRoute(
            path: '/book',
            builder: (context, state) => const BookshelfPage(),
          ),
        ]),


        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          // each routes with its sub routes if available e.g shope/uuid/details
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
        ]),


        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          // each routes with its sub routes if available e.g shope/uuid/details
          GoRoute(
            path: '/activity',
            builder: (context, state) => const FeedPage(),
          ),
        ]),


        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          // each routes with its sub routes if available e.g shope/uuid/details
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ])
      ],
    ),
  ],
);