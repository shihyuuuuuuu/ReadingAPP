import 'package:flutter/material.dart';
import 'package:reading_app/theme/theme.dart';

enum NoteType {
  content(str: "內容筆記", colorKey: 1),
  experience(str: "經驗", colorKey: 2),
  action(str: "行動", colorKey: 3),
  thought(str: "連結想法", colorKey: 4);

  final String str;
  final int colorKey;

  const NoteType({
    required this.str,
    required this.colorKey,
  });

  Color get color {
    final colorScheme = MaterialTheme.lightScheme();
    switch (colorKey) {
      case 1:
        return colorScheme.primary;
      case 2:
        return colorScheme.secondary;
      case 3:
        return colorScheme.tertiary;
      case 4:
        return colorScheme.error;
      default:
        return Colors.white; // Fallback color
    }
  }
}
