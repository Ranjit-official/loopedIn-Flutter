import 'package:flutter/material.dart';
import 'package:loopedin/common/responsive/helpers/responsive_calculator.dart';

class ResponsiveWidgets {
  // Responsive title widget
  static Widget buildResponsiveTitle(
    String title,
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool isTablet, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final fontSizes = ResponsiveCalculator.getResponsiveFontSizes(
      screenWidth,
      isLandscape,
      isTablet,
    );

    return Text(
      title,
      style: TextStyle(
        fontSize: fontSizes.titleFontSize,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color,
      ),
    );
  }

  // Responsive subtitle widget
  static Widget buildResponsiveSubtitle(
    String subtitle,
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool isTablet, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final fontSizes = ResponsiveCalculator.getResponsiveFontSizes(
      screenWidth,
      isLandscape,
      isTablet,
    );

    return Text(
      subtitle,
      style: TextStyle(
        fontSize: fontSizes.subtitleFontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
      ),
    );
  }

  // Responsive body text widget
  static Widget buildResponsiveBodyText(
    String text,
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool isTablet, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final fontSizes = ResponsiveCalculator.getResponsiveFontSizes(
      screenWidth,
      isLandscape,
      isTablet,
    );

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSizes.bodyFontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
      ),
    );
  }

  // Responsive page title widget
  static Widget buildResponsivePageTitle(
    String title,
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool isTablet, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final fontSizes = ResponsiveCalculator.getResponsiveFontSizes(
      screenWidth,
      isLandscape,
      isTablet,
    );

    return Text(
      title,
      style: TextStyle(
        fontSize: fontSizes.pageTitleFontSize,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color,
      ),
    );
  }

  // Responsive container with proper padding
  static Widget buildResponsiveContainer(
    Widget child,
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool isTablet,
    bool isLargeScreen, {
    BoxConstraints? constraints,
    Color? color,
    Decoration? decoration,
  }) {
    final layout = ResponsiveCalculator.getResponsiveLayout(
      screenWidth,
      screenHeight,
      isLandscape,
      isTablet,
      isLargeScreen,
    );

    return Container(
      width: layout.contentWidth,
      constraints: constraints,
      color: color,
      decoration: decoration,
      padding: EdgeInsets.symmetric(
        horizontal: layout.horizontalPadding,
        vertical: layout.verticalPadding,
      ),
      child: child,
    );
  }

  // Responsive spacing widget
  static Widget buildResponsiveSpacing(
    double screenHeight,
    bool isLandscape,
    ResponsiveSpacingType type,
  ) {
    final spacing = ResponsiveCalculator.getResponsiveSpacing(
      screenHeight,
      isLandscape,
    );

    double spacingValue;
    switch (type) {
      case ResponsiveSpacingType.titleBottom:
        spacingValue = spacing.titleBottomMargin;
        break;
      case ResponsiveSpacingType.widgetBottom:
        spacingValue = spacing.widgetBottomMargin;
        break;
      case ResponsiveSpacingType.subtitleBottom:
        spacingValue = spacing.subtitleBottomMargin;
        break;
      case ResponsiveSpacingType.iconSpacing:
        spacingValue = spacing.iconSpacing;
        break;
    }

    return SizedBox(height: spacingValue);
  }
}

// Enum for different types of responsive spacing
enum ResponsiveSpacingType {
  titleBottom,
  widgetBottom,
  subtitleBottom,
  iconSpacing,
}
