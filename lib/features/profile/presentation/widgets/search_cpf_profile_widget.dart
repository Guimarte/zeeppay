import 'package:flutter/material.dart';
import 'package:zeeppay/features/profile/presentation/widgets/cpf_form_field_widget.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/shared/widgets/button_digital_widget.dart';
import 'package:zeeppay/shared/widgets/button_numbers_widget.dart';
import 'package:zeeppay/shared/widgets/digital_keyboard.dart';

class SearchCpfProfileWidget extends StatelessWidget {
  SearchCpfProfileWidget({
    super.key,
    required this.cpfController,
    required this.onConfirm,
    required this.onBack,
  });

  final TextEditingController cpfController;
  final Function() onConfirm;
  final Function() onBack;

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
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;

    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onBack,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Digite o CPF:',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: CpfFormFieldWidget(cpfController: cpfController),
              ),
              const Spacer(),
              if (!hasPhysicalKeyboard)
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
              if (hasPhysicalKeyboard)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
