import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_styles.dart';

class SteamTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool mostrarPassword;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final String? helperText;
  final String? counterText;
  final TextStyle? counterStyle;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  const SteamTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.mostrarPassword = false,
    this.onTogglePassword,
    this.validator,
    this.maxLines,
    this.maxLength,
    this.helperText,
    this.counterText,
    this.counterStyle,
    this.errorText,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure password fields can't have multiple lines
    final effectiveMaxLines = (isPassword && !mostrarPassword) ? 1 : maxLines;
    
    return Container(
      decoration: AppStyles.inputDecoration,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !mostrarPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
          suffixIcon: isPassword && onTogglePassword != null
              ? IconButton(
                  icon: Icon(
                    mostrarPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.primary,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          helperText: helperText,
          helperStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
          counterText: counterText,
          counterStyle: counterStyle,
          errorText: errorText,
          errorStyle: const TextStyle(color: AppColors.error, fontSize: 10),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        maxLines: effectiveMaxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
