import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/service/navigation.dart';
import 'theme/theme.dart';
import 'ui/widget/icons.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    Provider<NavigationService>(create: (_) => NavigationService()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reading APP',
      theme: const MaterialTheme().light(),
      darkTheme: const MaterialTheme().dark(),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}

class ScaffoldWithNavbar extends StatelessWidget {
  const ScaffoldWithNavbar(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Provider.of<NavigationService>(context, listen: false);
    String currentPath = nav.currentPath(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: _showBottomNavigationBar(currentPath)
          ? BottomNavigationBar(
              currentIndex: _getCurrentIndex(currentPath),
              items: MenuIcon.values.map((menuIcon) {
                return BottomNavigationBarItem(
                  icon: menuIcon.icon,
                  label: '',
                );
              }).toList(),
              onTap: (index) => _onTap(context, index),
              selectedItemColor: theme.colorScheme.inversePrimary,
              unselectedItemColor: theme.colorScheme.outline,
              showUnselectedLabels: false,
              showSelectedLabels: false,
            )
          : null,
    );
  }

  bool _showBottomNavigationBar(String currentPath) {
    return (currentPath == "/book" ||
        currentPath == "/note" ||
        currentPath == "/home" ||
        currentPath == "/feed" ||
        currentPath == "/profile");
  }

  int _getCurrentIndex(String currentPath) {
    switch (currentPath) {
      case '/note':
        return 0;
      case '/book':
        return 1;
      case '/home':
        return 2;
      case '/feed':
        return 3;
      case '/profile':
        return 4;
      default:
        return 2;
    }
  }

  void _onTap(BuildContext context, int index) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    switch (index) {
      case 0:
        nav.goNote();
        break;
      case 1:
        nav.goBookshelf();
        break;
      case 2:
        nav.goHome();
        break;
      case 3:
        nav.goFeed();
        break;
      case 4:
        nav.goProfile();
        break;
    }
  }
}
