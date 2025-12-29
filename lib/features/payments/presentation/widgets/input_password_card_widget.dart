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
  State<InputPasswordTextFormField> createState() =>
      _InputPasswordTextFormFieldState();
}

class _InputPasswordTextFormFieldState
    extends State<InputPasswordTextFormField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;

    widget.controllerPasswordCard.addListener(_onPasswordChanged);

    if (hasPhysicalKeyboard) {
      // Auto-focus no GPOS 760
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  void _onPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controllerPasswordCard.removeListener(_onPasswordChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;
    final passwordLength = widget.controllerPasswordCard.text.length;

    return GestureDetector(
      onTap: hasPhysicalKeyboard ? () => _focusNode.requestFocus() : null,
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            if (hasPhysicalKeyboard)
              Opacity(
                opacity: 0,
                child: TextFormField(
                  controller: widget.controllerPasswordCard,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.none,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _focusNode.hasFocus ? theme.primaryColor : Colors.grey,
                  width: _focusNode.hasFocus ? 2 : 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  '*' * passwordLength,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
