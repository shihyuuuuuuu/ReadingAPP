import 'package:flutter/material.dart';

class PopupEvent{
  final Icon icon;
  final String text;
  final void Function() onPressed;

  PopupEvent({
    required this.icon, 
    required this.text, 
    required this.onPressed
  });
}