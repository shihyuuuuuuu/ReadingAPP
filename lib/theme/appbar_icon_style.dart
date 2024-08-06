  import 'package:flutter/material.dart';

Container appBarIconStyle(ColorScheme colorScheme, BuildContext context, Widget child) {
  return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.secondaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5.0,
              offset: const Offset(0, 3), 
            ),
          ],
        ),
        child: child,
      );
}

