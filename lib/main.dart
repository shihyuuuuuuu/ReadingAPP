import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';
import 'theme/theme.dart';
import 'ui/icons.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<NavigationService>(create: (_) => NavigationService()),
      ], 
      child: const MyApp()
    )
  );
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
  const ScaffoldWithNavbar(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Provider.of<NavigationService>(context, listen: false);
    String currentPath = nav.currentPath(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar:  _showBottomNavigationBar(currentPath)
          ? BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        items: MenuIcon.values.map((menuIcon) {
          return BottomNavigationBarItem(
            icon: menuIcon.icon,
            label: '',
          );
        }).toList(),
        onTap: _onTap,
        selectedItemColor: theme.colorScheme.inversePrimary,
        unselectedItemColor: theme.colorScheme.outline,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ):null,
    );
  }

  bool _showBottomNavigationBar(String currentPath) {
    return (currentPath == "/book" || currentPath ==  "/note" ||
       currentPath == "/home" || currentPath ==  "/feed" || currentPath == "profile");
  }

  void _onTap(index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
