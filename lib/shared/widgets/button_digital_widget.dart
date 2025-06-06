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
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
          color: isConfirmButton
              ? colors.confirmButtonCard
              : colors.eraseButtonCard,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isConfirmButton ? SizedBox.shrink() : Icon(icon),
            isConfirmButton ? SizedBox.shrink() : SizedBox(width: 4),

            Text(
              cardText,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
