import 'package:flutter/material.dart';
import 'package:zeeppay/theme/colors_app.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.cardName, required this.onTap});
  final String cardName;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
      height: MediaQuery.sizeOf(context).height * 0.2,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Card(
          color: ColorsApp().primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(cardName)),
          ),
        ),
      ),
    );
  }
}
