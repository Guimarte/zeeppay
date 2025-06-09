import 'package:flutter/material.dart';

class CreditChartWidget extends StatelessWidget {
  final double used;
  final double available;

  const CreditChartWidget({
    super.key,
    required this.used,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: used / (used + available),
      backgroundColor: Colors.green,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
      minHeight: 20,
    );
  }
}
