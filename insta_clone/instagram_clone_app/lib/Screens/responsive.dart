import 'package:flutter/material.dart';
import 'package:instagram_clone_app/Utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxHeight > webScreenSize) {
        // web screen layout
        return widget.webScreenLayout;
      } else {
        // mobile screen layout
        return widget.mobileScreenLayout;
      }
    });
  }
}
