import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loopedin/common/theme.dart';
import 'package:loopedin/common/responsive/models/responsive.dart';

class ProfileTopicsSection extends StatefulWidget {
  final ProfileSetupResponsiveSpacing spacing;
  final GlobalKey<FormBuilderFieldState>? fieldKey;
  final List<String> selectedTopics;
  final Function(List<String>) onTopicsChanged;

  const ProfileTopicsSection({
    super.key,
    required this.spacing,
    this.fieldKey,
    required this.selectedTopics,
    required this.onTopicsChanged,
  });

  @override
  State<ProfileTopicsSection> createState() => _ProfileTopicsSectionState();
}

class _ProfileTopicsSectionState extends State<ProfileTopicsSection> {
  // Available topics
  final List<String> _availableTopics = [
    "Sports",
    "Technology",
    "Finance",
    "Health",
    "Travel",
    "Food",
    "Fashion",
    "Art",
    "Music",
    "Books",
    "Movies",
    "TV",
    "Gaming",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select topics you'd like to talk about. This helps us connect you better.",
          style: TextStyle(
            fontSize: widget.spacing.labelFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: widget.spacing.inputTopMargin),
        FormBuilderField<List<String>>(
          key: widget.fieldKey,
          name: 'topics',
          initialValue: widget.selectedTopics,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select at least one topic';
            }
            return null;
          },
          builder: (FormFieldState<List<String>> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _availableTopics.map((topic) {
                    final isSelected = widget.selectedTopics.contains(topic);
                    return FilterChip(
                      label: Text(topic),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          List<String> updatedTopics = List.from(
                            widget.selectedTopics,
                          );
                          if (selected) {
                            updatedTopics.add(topic);
                          } else {
                            updatedTopics.remove(topic);
                          }
                          widget.onTopicsChanged(updatedTopics);
                          field.didChange(updatedTopics);
                        });
                      },
                      selectedColor: AppTheme.primaryColor.withValues(
                        alpha: 0.2,
                      ),
                      checkmarkColor: AppTheme.primaryColor,
                    );
                  }).toList(),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(height: widget.spacing.inputBottomMargin),
      ],
    );
  }
}
