import 'package:flutter/material.dart';
import 'package:zeeppay/features/payments/presentation/widgets/button_numbers_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/button_payments_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/input_password_card_widget.dart';

class PaymentsPasswordsWidget extends StatelessWidget {
  PaymentsPasswordsWidget({super.key, required this.controllerPasswordCard});

  final TextEditingController controllerPasswordCard;
  final numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'erase',
    '0',
    'confirm',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: InputPasswordCardWidget(
              controllerPasswordCard: controllerPasswordCard,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              physics: NeverScrollableScrollPhysics(),
              children: numbers.map((e) {
                switch (e) {
                  case ('erase'):
                    return ButtonPaymentsWidget(
                      function: () {
                        if (controllerPasswordCard.text.isNotEmpty) {
                          controllerPasswordCard.text = controllerPasswordCard
                              .text
                              .substring(
                                0,
                                controllerPasswordCard.text.length - 1,
                              );
                        }
                      },
                      cardText: 'Corrigir',
                      isConfirmButton: false,
                      icon: Icons.backspace,
                    );
                  case ('confirm'):
                    return ButtonPaymentsWidget(
                      function: () {
                        print(controllerPasswordCard.text);
                      },
                      cardText: 'Confirmar',
                      isConfirmButton: true,
                    );
                  default:
                    return ButtonNumbersWidget(
                      number: e,
                      function: (string) {
                        if (controllerPasswordCard.text.length == 6) {
                          return;
                        }
                        controllerPasswordCard.text += string;
                      },
                    );
                }
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
