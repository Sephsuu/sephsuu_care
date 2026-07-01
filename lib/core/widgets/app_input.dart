import 'package:flutter/material.dart';

// AppInput(
//   label: 'Username',
//   controller: usernameController,
//   hintText: 'Enter your username',
//   initialValue: null,

//   labelCharacter: const Icon(
//     Icons.person_outline,
//     size: 18,
//     color: Colors.grey,
//   ),

//   onChanged: (value) {
//     print('Username: $value');
//   },

//   onTap: () {
//     print('Input tapped');
//   },

//   obscureText: false,
//   enabled: true,
//   readOnly: false,
//   autofocus: false,

//   keyboardType: TextInputType.text,
//   textInputAction: TextInputAction.next,

//   maxLines: 1,
//   minLines: 1,
//   maxLength: 50,

//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Username is required';
//     }

//     return null;
//   },

//   padding: const EdgeInsets.only(bottom: 16),

//   contentPadding: const EdgeInsets.symmetric(
//     horizontal: 12,
//     vertical: 14,
//   ),

//   labelStyle: const TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: Color(0xFF374151),
//   ),

//   inputStyle: const TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//     color: Colors.black,
//   ),

//   hintStyle: const TextStyle(
//     fontSize: 14,
//     color: Colors.grey,
//   ),

//   fillColor: Colors.white,
//   borderColor: Colors.grey,
//   focusedBorderColor: Color(0xFFE67E22),
//   borderRadius: 10,
// )

class AppInput extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;

  final Widget? labelCharacter;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final String? Function(String?)? validator;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;

  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

  final double borderRadius;

  const AppInput({
    super.key,
    this.label,
    this.controller,
    this.hintText,
    this.initialValue,
    this.labelCharacter,
    this.onChanged,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.padding,
    this.contentPadding,
    this.labelStyle,
    this.inputStyle,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBorderColor = borderColor ?? Colors.grey.shade400;
    final Color resolvedFocusedBorderColor =
        focusedBorderColor ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style:
                  labelStyle ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
            ),
            const SizedBox(height: 4),
          ],

          TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            onChanged: onChanged,
            onTap: onTap,
            obscureText: obscureText,
            enabled: enabled,
            readOnly: readOnly,
            autofocus: autofocus,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLines: obscureText ? 1 : maxLines,
            minLines: minLines,
            maxLength: maxLength,
            validator: validator,
            style:
                inputStyle ??
                const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  hintStyle ??
                  TextStyle(fontSize: 14, color: Colors.grey.shade500),
              prefixIcon: labelCharacter != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: labelCharacter,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              filled: fillColor != null,
              fillColor: fillColor,
              contentPadding:
                  contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: resolvedBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: resolvedFocusedBorderColor,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
