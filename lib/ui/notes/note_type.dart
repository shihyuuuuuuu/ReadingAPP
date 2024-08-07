import 'package:flutter/material.dart';
import 'package:reading_app/theme/theme.dart';

enum NoteType {
  content(str: "內容筆記", colorKey: 'primary'),
  experience(str: "經驗", colorKey: 'secondary'),
  action(str: "行動", colorKey: 'primaryContainer'),
  thought(str: "連結想法", colorKey: 'onPrimaryFixed');

  final String str;
  final String colorKey;

  const NoteType({
    required this.str,
    required this.colorKey,
  });

  Color get color {
    final colorScheme = MaterialTheme.lightScheme();
    switch (colorKey) {
      case 'primary':
        return colorScheme.primaryFixedDim;
      case 'secondary':
        return colorScheme.secondaryFixedDim;
      case 'primaryContainer':
        return colorScheme.tertiaryFixedDim;
      case 'onPrimaryFixed':
        return colorScheme.surfaceDim;
      default:
        return Colors.black; // Fallback color
    }
  }
}
