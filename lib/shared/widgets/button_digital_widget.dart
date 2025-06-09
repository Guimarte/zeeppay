import 'package:flutter/material.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/theme/colors_app.dart';

class ButtonDigitalWidget extends StatelessWidget {
  const ButtonDigitalWidget({
    super.key,
    this.icon,
    required this.cardText,
    required this.isConfirmButton,
    required this.function,
  });

  final IconData? icon;
  final String cardText;
  final bool isConfirmButton;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    final colors = getIt<ColorsApp>();
    return Material(
      color: isConfirmButton
          ? colors.confirmButtonCard
          : colors.eraseButtonCard,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: function,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, size: 18)],
          ),
        ),
      ),
    );
  }
}
