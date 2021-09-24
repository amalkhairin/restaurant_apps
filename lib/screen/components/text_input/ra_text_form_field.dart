import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RATextFormField extends StatelessWidget {
  final bool? obsecureText;
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final bool? readOnly;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? showCursor;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? autofocus;
  final FocusNode? focusNode;

  const RATextFormField({
    Key? key,
    this.obsecureText = false,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.hintText,
    this.readOnly = false,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.autocorrect = false,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.enabled,
    this.maxLength,
    this.showCursor,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.onTap,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      readOnly: readOnly!,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obsecureText!,
      controller: controller,
      focusNode: focusNode,
      autocorrect: autocorrect!,
      autofocus: autofocus!,
      enableSuggestions: enableSuggestions!,
      enabled: enabled,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      onTap: onTap,
      showCursor: showCursor,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        fillColor: Colors.grey[200],
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10)
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}