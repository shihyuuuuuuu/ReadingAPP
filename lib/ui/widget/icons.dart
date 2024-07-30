import 'package:flutter/material.dart';

enum MenuIcon {
  bookshelf(Icon(Icons.menu_book, size: 32)),
  notes(Icon(Icons.edit, size: 32)),
  home(Icon(Icons.home, size: 32)),
  feed(Icon(Icons.favorite, size: 32)),
  profile(Icon(Icons.person, size: 32));

  final Icon icon;

  const MenuIcon(this.icon);
}

// 也可以這樣使用:
// class MenuIcons {
//   static const Icon home = Icon(Icons.home, size: 32);
//   static const Icon bookshelf = Icon(Icons.menu_book, size: 32);
//   static const Icon notes = Icon(Icons.edit, size: 32);
//   static const Icon feed = Icon(Icons.favorite, size: 32);
//   static const Icon profile = Icon(Icons.person, size: 32);
// }
