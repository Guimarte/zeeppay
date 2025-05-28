import 'package:flutter/material.dart';

class PaymentsTypePaymentWidget extends StatelessWidget {
  PaymentsTypePaymentWidget({super.key, required this.function});
  final Function() function;

  final numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      function();
                    },
                    child: Text("A vista"),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Parcelado")),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
