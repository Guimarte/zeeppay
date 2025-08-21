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
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Digite o CPF:',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CpfFormFieldWidget(cpfController: cpfController),
              const Spacer(),
              DigitalKeyboard(
                numbers: numbers,
                confirmButton: ButtonDigitalWidget(
                  icon: Icons.check_circle,
                  cardText: '',
                  isConfirmButton: true,
                  function: onConfirm,
                ),
                eraseButton: ButtonDigitalWidget(
                  icon: Icons.backspace,
                  cardText: '',
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
            ],
          ),
        ),
      ),
    );
  }
}
