import 'package:flutter/material.dart';

class OptionsMenuHomeWidget extends StatelessWidget {
  const OptionsMenuHomeWidget({super.key, required this.function});
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            function();
          },
        ),
      ],
    );
  }
}
