import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loopedin/common/theme.dart';
import 'package:loopedin/common/responsive/models/responsive.dart';

class ProfileInputSection extends StatelessWidget {
  final String label;
  final String hint;
  final String fieldName;
  final TextInputType keyboardType;
  final ProfileSetupResponsiveSpacing spacing;
  final List<FormFieldValidator<String?>> validators;
  final GlobalKey<FormBuilderFieldState>? fieldKey;

  const ProfileInputSection({
    super.key,
    required this.label,
    required this.hint,
    required this.fieldName,
    required this.keyboardType,
    required this.spacing,
    required this.validators,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: spacing.labelFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: spacing.inputTopMargin),
        FormBuilderTextField(
          key: fieldKey,
          name: fieldName,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            labelText: hint,
            labelStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing.inputHorizontalPadding,
              vertical: spacing.inputVerticalPadding,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: FormBuilderValidators.compose(validators),
        ),
        SizedBox(height: spacing.inputBottomMargin),
      ],
    );
  }
}
