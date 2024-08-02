import 'package:flutter/material.dart';
import 'package:reading_app/ui/bookshelf/book/book_page.dart';
import 'ui/bookshelf/bookshelf_page.dart';
import 'ui/feed/feed.dart';
import 'ui/home/home.dart';
import 'ui/notes/notes.dart';
import 'ui/profile/profile.dart';
import 'theme/theme.dart';
import 'ui/icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Reading APP',
      theme: const MaterialTheme().light(),
      darkTheme: const MaterialTheme().dark(),
      themeMode: ThemeMode.light,
      home: BookPage(),
    );
  }
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const BookshelfPage(),
    const NotesPage(),
    const HomePage(),
    const FeedPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: MenuIcon.values.map((menuIcon) {
          return BottomNavigationBarItem(
            icon: menuIcon.icon,
            label: '',
          );
        }).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.inversePrimary,
        unselectedItemColor: theme.colorScheme.outline,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
    );
  }
}
