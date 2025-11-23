import 'package:flutter/cupertino.dart';

class DocumentItem {
  final String title;
  final int pages;
  final String size;
  final Widget? thumbnail; // you can pass Image.file, Image.asset, etc.

  const DocumentItem({
    required this.title,
    required this.pages,
    required this.size,
    this.thumbnail,
  });
}
