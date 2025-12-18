import 'package:flutter/material.dart';

/// TextField personalizado con diseño minimalista consistente
class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool enabled;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null && onSuffixTap != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixTap,
              )
            : null,
      ),
    );
  }
}
