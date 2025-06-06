import 'package:flutter/material.dart';
import 'package:zeeppay/features/profile/presentation/widgets/cpf_form_field_widget.dart';
import 'package:zeeppay/shared/widgets/button_digital_widget.dart';
import 'package:zeeppay/shared/widgets/button_numbers_widget.dart';
import 'package:zeeppay/shared/widgets/digital_keyboard.dart';

class SearchCpfProfileWidget extends StatelessWidget {
  SearchCpfProfileWidget({
    super.key,
    required this.cpfController,
    required this.onConfirm,
  });
  final TextEditingController cpfController;
  final Function() onConfirm;
  final List<String> numbers = [
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
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Expanded(child: SizedBox()),
            Expanded(
              flex: 2,
              child: CpfFormFieldWidget(cpfController: cpfController),
            ),
            Expanded(
              flex: 10,
              child: DigitalKeyboard(
                numbers: numbers,
                confirmButton: ButtonDigitalWidget(
                  cardText: "Confirmar",
                  isConfirmButton: true,
                  function: () {
                    onConfirm();
                  },
                ),
                eraseButton: ButtonDigitalWidget(
                  cardText: "",
                  icon: Icons.backspace,
                  isConfirmButton: false,
                  function: () {
                    if (cpfController.text.isNotEmpty) {
                      cpfController.text = cpfController.text.substring(
                        0,
                        cpfController.text.length - 1,
                      );
                    }
                  },
                ),
                numberButton: (String number) => ButtonNumbersWidget(
                  number: number,
                  function: (string) {
                    if (cpfController.text.length >= 14) return;
                    cpfController.text += string;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
