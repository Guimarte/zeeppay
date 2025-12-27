import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final InputDecoration? decoration;

  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      maxLength: maxLength,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      // Desabilita o teclado virtual se tiver teclado físico (GPOS 760)
      showCursor: true,
      readOnly: hasPhysicalKeyboard ? false : false, // Mantém editável
      enableInteractiveSelection: true,
      decoration: decoration ??
          InputDecoration(
            labelText: labelText,
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            counterText: maxLength != null ? null : '',
          ),
      // Essa é a chave: desabilita o teclado virtual no GPOS 760
      onTap: hasPhysicalKeyboard
          ? () {
              // Esconde o teclado virtual
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            }
          : null,
    );
  }
}
