
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/ui/widget/icons.dart';

class ScaffoldWithNavbar extends StatelessWidget {
  const ScaffoldWithNavbar(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Provider.of<NavigationService>(context, listen: false);
    
    String currentPath;
    
    // TODO: the error may occur when direct to login page but this page is still trying to rebuild
    try{
      currentPath = nav.currentPath(context);
    } catch (e) {
      log('Error accessing GoRouterState: $e');
      return const SizedBox.shrink();
    }

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
        currentPath == "/home" );
  }

  int _getCurrentIndex(String currentPath) {
    switch (currentPath) {
      case '/note':
        return 0;
      case '/book':
        return 1;
      case '/home':
        return 2;
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
    }
  }
}
