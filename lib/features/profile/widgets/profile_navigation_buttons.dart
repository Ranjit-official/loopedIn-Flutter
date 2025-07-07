import 'package:flutter/material.dart';

class ProfileNavigationButtons {
  static Widget buildBackButton({required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap, child: const Icon(Icons.arrow_back));
  }

  static Widget buildSkipButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  static Widget buildNextButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.arrow_forward),
    );
  }

  static Widget buildDoneButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
