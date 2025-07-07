// Base responsive spacing class for common spacing values
class ResponsiveSpacing {
  final double titleBottomMargin;
  final double widgetBottomMargin;
  final double subtitleBottomMargin;
  final double iconSpacing;

  ResponsiveSpacing({
    required this.titleBottomMargin,
    required this.widgetBottomMargin,
    required this.subtitleBottomMargin,
    required this.iconSpacing,
  });
}

// Extended responsive spacing class for profile setup page
class ProfileSetupResponsiveSpacing {
  final double titleBottomMargin;
  final double pageBottomPadding;
  final double headerTopPadding;
  final double controlsMargin;
  final double controlsPadding;
  final double dotSize;
  final double activeDotWidth;
  final double labelFontSize;
  final double descriptionFontSize;
  final double inputTopMargin;
  final double inputBottomMargin;
  final double inputVerticalPadding;
  final double inputHorizontalPadding;

  ProfileSetupResponsiveSpacing({
    required this.titleBottomMargin,
    required this.pageBottomPadding,
    required this.headerTopPadding,
    required this.controlsMargin,
    required this.controlsPadding,
    required this.dotSize,
    required this.activeDotWidth,
    required this.labelFontSize,
    required this.descriptionFontSize,
    required this.inputTopMargin,
    required this.inputBottomMargin,
    required this.inputVerticalPadding,
    required this.inputHorizontalPadding,
  });
}

// Responsive font sizes for different contexts
class ResponsiveFontSizes {
  final double titleFontSize;
  final double subtitleFontSize;
  final double bodyFontSize;
  final double pageTitleFontSize;

  ResponsiveFontSizes({
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.bodyFontSize,
    required this.pageTitleFontSize,
  });
}

// Responsive layout dimensions
class ResponsiveLayout {
  final double horizontalPadding;
  final double verticalPadding;
  final double contentWidth;

  ResponsiveLayout({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.contentWidth,
  });
}
