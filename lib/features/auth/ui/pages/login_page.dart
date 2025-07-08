import 'package:flutter/material.dart';
import 'package:loopedin/common/custom_Icon.dart';
import 'package:loopedin/common/constants.dart';
import 'package:loopedin/common/theme.dart';
import 'package:loopedin/features/auth/ui/widgets/login_widget.dart';
import 'package:loopedin/features/auth/ui/widgets/signup_widget.dart';
import 'package:loopedin/common/responsive/helpers/responsive_calculator.dart';

class LoginPage extends StatefulWidget {
  final bool isLoginPage;
  const LoginPage({super.key, this.isLoginPage = true});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard and remove focus when tapping anywhere
            FocusScope.of(context).unfocus();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return _buildResponsiveLayout(constraints);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BoxConstraints constraints) {
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
    final fontSizes = ResponsiveCalculator.getResponsiveFontSizes(
      screenWidth,
      isLandscape,
      isTablet,
    );
    final spacing = ResponsiveCalculator.getResponsiveSpacing(
      screenHeight,
      isLandscape,
    );

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              screenHeight -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: layout.horizontalPadding,
              vertical: layout.verticalPadding,
            ),
            child: Center(
              child: SizedBox(
                width: layout.contentWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo/Title section with responsive sizing
                    _buildTitleSection(
                      fontSizes.titleFontSize,
                      spacing.titleBottomMargin,
                    ),

                    // Login/Signup widget with responsive container
                    _buildAuthWidget(
                      layout.contentWidth,
                      isLandscape,
                      isTablet,
                    ),

                    SizedBox(height: spacing.widgetBottomMargin),

                    // "Or Sign in/up with" text
                    _buildSubtitleText(
                      fontSizes.subtitleFontSize,
                      spacing.subtitleBottomMargin,
                    ),

                    // Social login icons with responsive spacing
                    _buildSocialIcons(spacing.iconSpacing, isLandscape),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(double fontSize, double bottomMargin) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Center(
        child: Image.asset(
          'assets/rest/loopin_full.png',
          width: 200,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildAuthWidget(
    double contentWidth,
    bool isLandscape,
    bool isTablet,
  ) {
    return Container(
      width: contentWidth,
      constraints: BoxConstraints(maxWidth: isTablet ? 500.0 : 400.0),
      child: widget.isLoginPage ? LoginWidget() : SignUpWidget(),
    );
  }

  Widget _buildSubtitleText(double fontSize, double bottomMargin) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Text(
        widget.isLoginPage ? "Or Sign in with" : "Or Sign up with",
        style: TextStyle(fontSize: fontSize, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildSocialIcons(double iconSpacing, bool isLandscape) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(icon: IconConstants.google),
        SizedBox(width: iconSpacing),
        CustomIconWidget(icon: IconConstants.linkedin),
        SizedBox(width: iconSpacing),
        CustomIconWidget(icon: IconConstants.github),
        SizedBox(width: iconSpacing),
        CustomIconWidget(icon: IconConstants.facebook),
      ],
    );
  }
}
