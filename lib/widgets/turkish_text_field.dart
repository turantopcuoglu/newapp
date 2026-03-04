import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A [TextField] wrapper that explicitly supports Turkish character input.
///
/// This widget ensures that Turkish special characters (ş, ı, ç, ğ, ö, ü, İ,
/// Ş, Ç, Ğ, Ö, Ü) are properly accepted in text input fields by:
/// - Using [FilteringTextInputFormatter.allow] with a Unicode-aware pattern
/// - Enabling IME personalized learning
/// - Setting proper keyboard type for text input
class TurkishTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final FocusNode? focusNode;

  const TurkishTextField({
    super.key,
    this.controller,
    this.decoration,
    this.style,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      style: style,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      keyboardType: keyboardType ?? TextInputType.text,
      enableIMEPersonalizedLearning: true,
      autocorrect: true,
      enableSuggestions: true,
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus,
      focusNode: focusNode,
      inputFormatters: inputFormatters ??
          [
            // Explicitly allow all Unicode characters including Turkish
            FilteringTextInputFormatter.allow(RegExp(r'[\s\S]', unicode: true)),
          ],
    );
  }
}
