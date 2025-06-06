import 'package:flutter/material.dart';
import 'package:zeeppay/shared/widgets/card_widget.dart';

class InitialProfileWidget extends StatelessWidget {
  const InitialProfileWidget({super.key, required this.function});
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CardWidget(
                cardName: "CPF",
                onTap: () {
                  function();
                },
              ),
              CardWidget(cardName: "Cartão", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
