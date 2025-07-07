import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loopedin/common/theme.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String name;
  final TextInputType? keyboardType;
  final double? verticalPadding;
  final double? horizontalPadding;
  final int? maxLines;
  final String? hint;
  final GlobalKey<FormBuilderFieldState>? keyField;
  const CustomInputField({
    super.key,
    required this.label,
    required this.name,
    this.keyboardType,
    this.verticalPadding,
    this.horizontalPadding,
    this.maxLines,
    this.hint,
    this.keyField,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return FormBuilderTextField(
      key: widget.keyField,
      name: widget.name,

      keyboardType: widget.keyboardType ?? TextInputType.emailAddress,
      maxLines: widget.maxLines ?? 1,
      textDirection: TextDirection.ltr,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.start,
      onEditingComplete: () {
        node.unfocus();
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        labelText: widget.label,
        labelStyle: TextStyle(color: Colors.grey),
        contentPadding:
            widget.verticalPadding != null && widget.horizontalPadding != null
            ? EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding!,
                vertical: widget.verticalPadding!,
              )
            : null,
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
      ),
    );
  }
}
