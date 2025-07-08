import 'package:flutter/material.dart';

class CustomIconWidget extends StatefulWidget {
  final String icon;
  const CustomIconWidget({super.key, required this.icon});

  @override
  State<CustomIconWidget> createState() => _CustomIconWidgetState();
}

class _CustomIconWidgetState extends State<CustomIconWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('tapped');
      },
      child: SizedBox(width: 40, height: 40, child: Image.asset(widget.icon)),
    );
  }
}
