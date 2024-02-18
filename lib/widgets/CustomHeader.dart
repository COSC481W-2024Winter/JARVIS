import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double toolbarHeight;

  // CustomAppBar constructor
  const CustomAppBar({
    super.key,
    this.title = 'JARVIS',
    this.toolbarHeight = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      title: Text(title),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
