import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

class InputPasswordTextFormField extends StatefulWidget {
  const InputPasswordTextFormField({
    super.key,
    required this.controllerPasswordCard,
  });

  final TextEditingController controllerPasswordCard;

  @override
  State<InputPasswordTextFormField> createState() => _InputPasswordTextFormFieldState();
}

class _InputPasswordTextFormFieldState extends State<InputPasswordTextFormField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;

    if (hasPhysicalKeyboard) {
      // Auto-focus no GPOS 760
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;

    return TextFormField(
      controller: widget.controllerPasswordCard,
      focusNode: _focusNode,
      obscureText: true,
      obscuringCharacter: '*',
      readOnly: !hasPhysicalKeyboard, // Permite edição no GPOS 760
      textAlign: TextAlign.center,
      // Oculta o teclado do Android no GPOS 760
      showCursor: true,
      enableInteractiveSelection: hasPhysicalKeyboard,
      keyboardType: hasPhysicalKeyboard ? TextInputType.none : null, // Importante: TextInputType.none
      maxLength: hasPhysicalKeyboard ? 4 : null,
      inputFormatters: hasPhysicalKeyboard
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      style: theme.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: '',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
      ),
    );
  }
}
