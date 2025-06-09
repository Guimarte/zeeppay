import 'package:flutter/material.dart';
import 'package:zeeppay/theme/colors_app.dart';

class CardWidget extends StatelessWidget {
  final String cardName;
  final IconData? icon;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    required this.cardName,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, size: 36, color: ColorsApp().primary),
              const SizedBox(height: 8),
              Text(
                cardName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
