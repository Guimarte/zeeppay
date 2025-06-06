import 'package:flutter/material.dart';
import 'package:zeeppay/features/payments/presentation/widgets/input_password_card_widget.dart';
import 'package:zeeppay/shared/widgets/button_digital_widget.dart';
import 'package:zeeppay/shared/widgets/button_numbers_widget.dart';
import 'package:zeeppay/shared/widgets/digital_keyboard.dart';

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
        Expanded(child: SizedBox()),
        Expanded(
          flex: 2,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: InputPasswordCardWidget(
              controllerPasswordCard: controllerPasswordCard,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: DigitalKeyboard(
            numbers: numbers,
            confirmButton: ButtonDigitalWidget(
              function: () {
                print(controllerPasswordCard.text);
              },
              cardText: 'Confirmar',
              isConfirmButton: true,
            ),
            eraseButton: ButtonDigitalWidget(
              function: () {
                if (controllerPasswordCard.text.isNotEmpty) {
                  controllerPasswordCard.text = controllerPasswordCard.text
                      .substring(0, controllerPasswordCard.text.length - 1);
                }
              },
              cardText: '',
              isConfirmButton: false,
              icon: Icons.backspace,
            ),
            numberButton: (String number) => ButtonNumbersWidget(
              number: number,
              function: (string) {
                if (controllerPasswordCard.text.length == 6) return;
                controllerPasswordCard.text += string;
              },
            ),
          ),
        ),
      ],
    );
  }
}
