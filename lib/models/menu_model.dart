import 'package:flutter/material.dart';

class MenuItem {
  final String id;
  final String label;
  final String? imagePath;
  final Widget? screen;

  MenuItem({
    required this.id,
    required this.label,
    this.imagePath,
    this.screen,
  });
}
