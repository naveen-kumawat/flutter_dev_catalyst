import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field types
enum CatalystTextFieldType { text, email, password, phone, number, multiline }

/// Catalyst Text Field widget
class CatalystTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final CatalystTextFieldType type;
  final List<String? Function(String?)> validators;
  final bool autoValidate;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;

  const CatalystTextField({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.type = CatalystTextFieldType.text,
    this.validators = const [],
    this.autoValidate = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.inputFormatters,
    this.focusNode,
    this.contentPadding,
    this.errorText,
  }) : super(key: key);

  @override
  State<CatalystTextField> createState() => _CatalystTextFieldState();
}

class _CatalystTextFieldState extends State<CatalystTextField> {
  late TextEditingController _controller;
  late bool _obscureText;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _obscureText =
        widget.obscureText || widget.type == CatalystTextFieldType.password;
    _errorText = widget.errorText;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: _obscureText,
      maxLines: _getMaxLines(),
      maxLength: widget.maxLength,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction ?? _getTextInputAction(),
      inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefix: widget.prefix,
        suffix: widget.suffix,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: _buildSuffixIcon(),
        errorText: _errorText,
        contentPadding: widget.contentPadding,
      ),
      validator: widget.autoValidate ? _validate : null,
      onChanged: (value) {
        if (widget.autoValidate) {
          setState(() {
            _errorText = _validate(value);
          });
        }
        widget.onChanged?.call(value);
      },
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.type == CatalystTextFieldType.password) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon);
    } else if (widget.suffix != null) {
      return widget.suffix;
    }
    return null;
  }

  String? _validate(String? value) {
    for (final validator in widget.validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case CatalystTextFieldType.email:
        return TextInputType.emailAddress;
      case CatalystTextFieldType.phone:
        return TextInputType.phone;
      case CatalystTextFieldType.number:
        return TextInputType.number;
      case CatalystTextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case CatalystTextFieldType.multiline:
        return TextInputAction.newline;
      default:
        return TextInputAction.done;
    }
  }

  int? _getMaxLines() {
    if (widget.maxLines != null) return widget.maxLines;

    switch (widget.type) {
      case CatalystTextFieldType.multiline:
        return null;
      case CatalystTextFieldType.password:
        return 1;
      default:
        return 1;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case CatalystTextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case CatalystTextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }
}
