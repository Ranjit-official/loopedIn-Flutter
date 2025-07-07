import 'package:flutter/material.dart';
import 'package:loopedin/common/responsive/models/responsive.dart';

class ProfileDescriptionText extends StatelessWidget {
  final ProfileSetupResponsiveSpacing spacing;

  const ProfileDescriptionText({super.key, required this.spacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Please fill this in to help us match you with like-minded professionals who share your interests and goals",
      style: TextStyle(
        fontSize: spacing.descriptionFontSize,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 80, 79, 79),
      ),
    );
  }
}
