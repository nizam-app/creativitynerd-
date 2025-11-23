import 'dart:ui';

import 'package:flutter/material.dart';

class ShareActionItem {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const ShareActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}