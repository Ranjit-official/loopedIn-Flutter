import 'package:flutter/material.dart';
import 'package:loopedin/common/responsive/helpers/responsive_calculator.dart';

class ProfileResponsiveLayout extends StatelessWidget {
  final Widget child;
  final BoxConstraints constraints;

  const ProfileResponsiveLayout({
    super.key,
    required this.child,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final isLandscape = screenWidth > screenHeight;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Calculate responsive values using the helper
    final layout = ResponsiveCalculator.getResponsiveLayout(
      screenWidth,
      screenHeight,
      isLandscape,
      isTablet,
      isLargeScreen,
    );

    return Container(
      color: Colors.white,
      child: isLandscape
          ? Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: layout.contentWidth,
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 600.0 : 500.0,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            )
          : Column(children: [Expanded(child: child)]),
    );
  }
}
