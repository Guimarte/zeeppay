import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

class PaymentValueTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const PaymentValueTextFieldWidget({super.key, required this.controller});

  @override
  State<PaymentValueTextFieldWidget> createState() => _PaymentValueTextFieldWidgetState();
}

class _PaymentValueTextFieldWidgetState extends State<PaymentValueTextFieldWidget> {
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
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: !hasPhysicalKeyboard, // Permite edição no GPOS 760
      textAlign: TextAlign.center,
      // Oculta o teclado do Android no GPOS 760
      showCursor: true,
      enableInteractiveSelection: hasPhysicalKeyboard,
      keyboardType: hasPhysicalKeyboard ? TextInputType.none : null, // Importante: TextInputType.none
      inputFormatters: hasPhysicalKeyboard
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))]
          : null,
      style: theme.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'R\$ 0,00',
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
