import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:loopedin/features/home/ui/pages/home_page.dart';
import 'package:loopedin/common/responsive/helpers/responsive_calculator.dart';
import 'package:loopedin/common/responsive/models/responsive.dart';
import 'package:loopedin/features/profile/widgets/profile_setup_app_bar.dart';
import 'package:loopedin/features/profile/widgets/profile_input_section.dart';
import 'package:loopedin/features/profile/widgets/profile_text_area_section.dart';
import 'package:loopedin/features/profile/widgets/profile_description_text.dart';
import 'package:loopedin/features/profile/widgets/profile_topics_section.dart';
import 'package:loopedin/features/profile/widgets/profile_navigation_buttons.dart';
import 'package:loopedin/features/profile/widgets/profile_responsive_layout.dart';

class ProfileSetUpPage extends StatefulWidget {
  const ProfileSetUpPage({super.key});

  @override
  State<ProfileSetUpPage> createState() => _ProfileSetUpPageState();
}

class _ProfileSetUpPageState extends State<ProfileSetUpPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final _formKey = GlobalKey<FormBuilderState>();
  final _fullName = GlobalKey<FormBuilderFieldState>();
  final _currentTitle = GlobalKey<FormBuilderFieldState>();
  final _company = GlobalKey<FormBuilderFieldState>();
  final _industry = GlobalKey<FormBuilderFieldState>();
  final _experience = GlobalKey<FormBuilderFieldState>();
  final _description = GlobalKey<FormBuilderFieldState>();
  final _topics = GlobalKey<FormBuilderFieldState>();

  // Selected topics for the third page
  List<String> _selectedTopics = [];

  // Track current page for validation
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
    final spacing = ResponsiveCalculator.getProfileSetupResponsiveSpacing(
      screenHeight,
      isLandscape,
    );

    return ProfileResponsiveLayout(
      constraints: constraints,
      child: Column(
        children: [
          // Responsive AppBar
          ProfileSetupAppBar(
            titleFontSize: fontSizes.titleFontSize,
            horizontalPadding: layout.horizontalPadding,
          ),

          // Responsive Introduction Screen
          Expanded(
            child: _buildResponsiveIntroductionScreen(
              screenWidth,
              screenHeight,
              isLandscape,
              isTablet,
              isLargeScreen,
              layout.horizontalPadding,
              layout.verticalPadding,
              layout.contentWidth,
              spacing,
              fontSizes,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveIntroductionScreen(
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool isTablet,
    bool isLargeScreen,
    double horizontalPadding,
    double verticalPadding,
    double contentWidth,
    ProfileSetupResponsiveSpacing spacing,
    ResponsiveFontSizes fontSizes,
  ) {
    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: fontSizes.pageTitleFontSize,
        fontWeight: FontWeight.w700,
      ),
      bodyTextStyle: TextStyle(
        fontSize: fontSizes.bodyFontSize,
        fontWeight: FontWeight.w400,
      ),
      bodyPadding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0.0,
        horizontalPadding,
        spacing.pageBottomPadding,
      ),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return FormBuilder(
      key: _formKey,
      child: IntroductionScreen(
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context),
        key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: false,
        infiniteAutoScroll: false,
        globalHeader: Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: spacing.headerTopPadding,
                right: horizontalPadding,
              ),
            ),
          ),
        ),
        pages: [
          PageViewModel(
            title: "",
            bodyWidget: _buildResponsivePageContent(
              screenWidth,
              isLandscape,
              isTablet,
              spacing,
              [
                ProfileInputSection(
                  label: "What is your name ? ",
                  hint: "Full Name",
                  fieldName: "fullName",
                  keyboardType: TextInputType.name,
                  spacing: spacing,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Full name is required',
                    ),
                  ],
                  fieldKey: _fullName,
                ),
                ProfileInputSection(
                  label: "What's your Current title ?",
                  hint: "Eg. Software Engineer",
                  fieldName: "currentTitle",
                  keyboardType: TextInputType.name,
                  spacing: spacing,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Current title is required',
                    ),
                  ],
                  fieldKey: _currentTitle,
                ),
                ProfileInputSection(
                  label: "Where do you work ?",
                  hint: "Eg. Microsoft",
                  fieldName: "company",
                  keyboardType: TextInputType.name,
                  spacing: spacing,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Company is required',
                    ),
                  ],
                  fieldKey: _company,
                ),
                ProfileInputSection(
                  label: "What industry do you work in ?",
                  hint: "Select Industry",
                  fieldName: "industry",
                  keyboardType: TextInputType.name,
                  spacing: spacing,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Industry is required',
                    ),
                  ],
                  fieldKey: _industry,
                ),
                ProfileInputSection(
                  label: "How many years of experience do you have ? ",
                  hint: "Select Experience",
                  fieldName: "experience",
                  keyboardType: TextInputType.name,
                  spacing: spacing,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Experience is required',
                    ),
                  ],
                  fieldKey: _experience,
                ),
              ],
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "",
            bodyWidget: _buildResponsivePageContent(
              screenWidth,
              isLandscape,
              isTablet,
              spacing,
              [
                ProfileTextAreaSection(
                  label: "Describe yourself in a short",
                  hint: "Experience",
                  placeholder:
                      "Eg. Frontend Engineer working with React, building user-friendly interfaces and scalable web applications.",
                  fieldName: "description",
                  spacing: spacing,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Description is required',
                    ),
                  ],
                  fieldKey: _description,
                ),
                ProfileDescriptionText(spacing: spacing),
              ],
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "",
            bodyWidget: _buildResponsivePageContent(
              screenWidth,
              isLandscape,
              isTablet,
              spacing,
              [
                ProfileTopicsSection(
                  spacing: spacing,
                  fieldKey: _topics,
                  selectedTopics: _selectedTopics,
                  onTopicsChanged: (topics) {
                    setState(() {
                      _selectedTopics = topics;
                    });
                  },
                ),
              ],
            ),
            decoration: pageDecoration,
          ),
        ],
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,
        back: ProfileNavigationButtons.buildBackButton(
          onTap: () {
            if (_currentPage > 0) {
              _currentPage--;
            }
            introKey.currentState?.previous();
          },
        ),
        skip: ProfileNavigationButtons.buildSkipButton(
          onTap: () {
            _currentPage = 0; // Reset to first page
            _onIntroEnd(context);
          },
        ),
        next: ProfileNavigationButtons.buildNextButton(
          onTap: () => _onNextPage(),
        ),
        done: ProfileNavigationButtons.buildDoneButton(
          onTap: () => _onIntroEnd(context),
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: EdgeInsets.all(spacing.controlsMargin),
        controlsPadding: kIsWeb
            ? EdgeInsets.all(spacing.controlsPadding)
            : EdgeInsets.fromLTRB(
                spacing.controlsPadding,
                spacing.controlsPadding * 0.5,
                spacing.controlsPadding,
                spacing.controlsPadding * 0.5,
              ),
        dotsDecorator: DotsDecorator(
          size: Size(spacing.dotSize, spacing.dotSize),
          color: const Color(0xFFBDBDBD),
          activeSize: Size(spacing.activeDotWidth, spacing.dotSize),
          activeShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsivePageContent(
    double screenWidth,
    bool isLandscape,
    bool isTablet,
    ProfileSetupResponsiveSpacing spacing,
    List<Widget> children,
  ) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  void _onNextPage() {
    // Validate current page based on page index
    bool isValid = false;

    switch (_currentPage) {
      case 0:
        // Validate first page fields
        isValid = _validateFirstPage();
        if (kDebugMode) {
          print('First page validation: $isValid');
          final formData = _formKey.currentState?.value;
          print('Form data: $formData');
        }
        break;
      case 1:
        // Validate second page fields
        isValid = _validateSecondPage();
        if (kDebugMode) {
          print('Second page validation: $isValid');
          final formData = _formKey.currentState?.value;
          print('Form data: $formData');
        }
        break;
      case 2:
        // Validate third page fields
        isValid = _validateThirdPage();
        if (kDebugMode) {
          print('Third page validation: $isValid');
          print('Selected topics: $_selectedTopics');
        }
        break;
    }

    if (isValid) {
      // Move to next page
      _currentPage++;
      introKey.currentState?.next();
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _validateFirstPage() {
    // Save the form first to ensure all values are captured
    final formState = _formKey.currentState;
    if (formState == null) return false;

    // Save the form without validation first
    formState.save();

    // Get the form values
    final formData = formState.value;

    // Check if all required fields have values
    bool isValid = true;

    if (formData['fullName'] == null ||
        formData['fullName'].toString().trim().isEmpty) {
      isValid = false;
    }

    if (formData['currentTitle'] == null ||
        formData['currentTitle'].toString().trim().isEmpty) {
      isValid = false;
    }

    if (formData['company'] == null ||
        formData['company'].toString().trim().isEmpty) {
      isValid = false;
    }

    if (formData['industry'] == null ||
        formData['industry'].toString().trim().isEmpty) {
      isValid = false;
    }

    if (formData['experience'] == null ||
        formData['experience'].toString().trim().isEmpty) {
      isValid = false;
    }

    return isValid;
  }

  bool _validateSecondPage() {
    // Save the form first to ensure all values are captured
    final formState = _formKey.currentState;
    if (formState == null) return false;

    // Save the form without validation first
    formState.save();

    // Get the form values
    final formData = formState.value;

    // Check if description field has a value
    return formData['description'] != null &&
        formData['description'].toString().trim().isNotEmpty;
  }

  bool _validateThirdPage() {
    // Check if topics are selected
    return _selectedTopics.isNotEmpty;
  }

  void _onIntroEnd(BuildContext context) {
    if (_formKey.currentState!.saveAndValidate()) {
      // Get all form data
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);

      // Add selected topics to form data
      formData['topics'] = _selectedTopics;

      // Log form data for debugging (you can replace this with your API call)
      if (kDebugMode) {
        print('Form submitted with data: $formData');
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile setup completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home page
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      // Show error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
