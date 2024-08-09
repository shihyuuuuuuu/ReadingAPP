import 'package:flutter/material.dart';

class popupEvent{
  final Icon icon;
  final String text;
  final void Function() onPressed;

  popupEvent({
    required this.icon, 
    required this.text, 
    required this.onPressed
  });
}