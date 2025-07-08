import 'package:loopedin/common/responsive/models/responsive.dart';

class ResponsiveCalculator {
  // Calculate responsive padding based on screen width and orientation
  static double getResponsivePadding(double screenWidth, bool isLandscape) {
    if (isLandscape) {
      if (screenWidth > 1200) return screenWidth * 0.15;
      if (screenWidth > 900) return screenWidth * 0.12;
      if (screenWidth > 600) return screenWidth * 0.08;
      return screenWidth * 0.05;
    } else {
      if (screenWidth > 600) return 40.0;
      return 20.0;
    }
  }

  // Calculate responsive vertical padding based on screen height and orientation
  static double getResponsiveVerticalPadding(
    double screenHeight,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return screenHeight * 0.05;
    } else {
      if (screenHeight > 800) return 40.0;
      if (screenHeight > 600) return 30.0;
      return 20.0;
    }
  }

  // Calculate responsive font sizes for different contexts
  static ResponsiveFontSizes getResponsiveFontSizes(
    double screenWidth,
    bool isLandscape,
    bool isTablet,
  ) {
    double titleFontSize;
    double subtitleFontSize;
    double bodyFontSize;
    double pageTitleFontSize;

    if (isTablet) {
      titleFontSize = isLandscape ? 36.0 : 44.0;
      subtitleFontSize = isLandscape ? 18.0 : 20.0;
      bodyFontSize = isLandscape ? 16.0 : 18.0;
      pageTitleFontSize = isLandscape ? 24.0 : 28.0;
    } else {
      if (isLandscape) {
        if (screenWidth > 900) {
          titleFontSize = 32.0;
          subtitleFontSize = 16.0;
          bodyFontSize = 14.0;
          pageTitleFontSize = 20.0;
        } else {
          titleFontSize = 28.0;
          subtitleFontSize = 14.0;
          bodyFontSize = 12.0;
          pageTitleFontSize = 18.0;
        }
      } else {
        if (screenWidth > 400) {
          titleFontSize = 40.0;
          subtitleFontSize = 16.0;
          bodyFontSize = 16.0;
          pageTitleFontSize = 24.0;
        } else {
          titleFontSize = 36.0;
          subtitleFontSize = 14.0;
          bodyFontSize = 14.0;
          pageTitleFontSize = 20.0;
        }
      }
    }

    return ResponsiveFontSizes(
      titleFontSize: titleFontSize,
      subtitleFontSize: subtitleFontSize,
      bodyFontSize: bodyFontSize,
      pageTitleFontSize: pageTitleFontSize,
    );
  }

  // Calculate responsive content width
  static double getContentWidth(
    double screenWidth,
    bool isLandscape,
    bool isTablet,
    bool isLargeScreen,
  ) {
    if (isLargeScreen) {
      return isLandscape ? screenWidth * 0.6 : screenWidth * 0.5;
    } else if (isTablet) {
      return isLandscape ? screenWidth * 0.7 : screenWidth * 0.6;
    } else {
      return double.infinity;
    }
  }

  // Calculate responsive layout dimensions
  static ResponsiveLayout getResponsiveLayout(
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool isTablet,
    bool isLargeScreen,
  ) {
    final horizontalPadding = getResponsivePadding(screenWidth, isLandscape);
    final verticalPadding = getResponsiveVerticalPadding(
      screenHeight,
      isLandscape,
    );
    final contentWidth = getContentWidth(
      screenWidth,
      isLandscape,
      isTablet,
      isLargeScreen,
    );

    return ResponsiveLayout(
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      contentWidth: contentWidth,
    );
  }

  // Calculate responsive spacing for login/signup pages
  static ResponsiveSpacing getResponsiveSpacing(
    double screenHeight,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return ResponsiveSpacing(
        titleBottomMargin: screenHeight * 0.03,
        widgetBottomMargin: screenHeight * 0.02,
        subtitleBottomMargin: screenHeight * 0.015,
        iconSpacing: 15.0,
      );
    } else {
      return ResponsiveSpacing(
        titleBottomMargin: screenHeight * 0.05,
        widgetBottomMargin: screenHeight * 0.03,
        subtitleBottomMargin: screenHeight * 0.02,
        iconSpacing: 20.0,
      );
    }
  }

  // Calculate responsive spacing for profile setup page
  static ProfileSetupResponsiveSpacing getProfileSetupResponsiveSpacing(
    double screenHeight,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return ProfileSetupResponsiveSpacing(
        titleBottomMargin: screenHeight * 0.03,
        pageBottomPadding: screenHeight * 0.02,
        headerTopPadding: screenHeight * 0.02,
        controlsMargin: 16.0,
        controlsPadding: 12.0,
        dotSize: 10.0,
        activeDotWidth: 22.0,
        labelFontSize: 14.0,
        descriptionFontSize: 12.0,
        inputTopMargin: 8.0,
        inputBottomMargin: 16.0,
        inputVerticalPadding: 8.0,
        inputHorizontalPadding: 8.0,
      );
    } else {
      return ProfileSetupResponsiveSpacing(
        titleBottomMargin: screenHeight * 0.05,
        pageBottomPadding: screenHeight * 0.03,
        headerTopPadding: screenHeight * 0.03,
        controlsMargin: 16.0,
        controlsPadding: 8.0,
        dotSize: 10.0,
        activeDotWidth: 22.0,
        labelFontSize: 16.0,
        descriptionFontSize: 14.0,
        inputTopMargin: 10.0,
        inputBottomMargin: 20.0,
        inputVerticalPadding: 10.0,
        inputHorizontalPadding: 10.0,
      );
    }
  }
}
