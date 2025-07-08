import 'package:flutter/material.dart';
import 'package:loopedin/common/theme.dart';

class ProfileSetupAppBar extends StatelessWidget {
  final double titleFontSize;
  final double horizontalPadding;

  const ProfileSetupAppBar({
    super.key,
    required this.titleFontSize,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Let's setup your profile",
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
