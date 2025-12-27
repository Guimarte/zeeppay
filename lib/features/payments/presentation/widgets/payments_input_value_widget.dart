import 'package:flutter/material.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/widgets/custom_back_button_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_input_text_form_field_widget.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';
import 'package:zeeppay/shared/widgets/button_digital_widget.dart';
import 'package:zeeppay/shared/widgets/button_numbers_widget.dart';
import 'package:zeeppay/shared/widgets/digital_keyboard.dart';

class PaymentsInputValueWidget extends StatelessWidget {
  const PaymentsInputValueWidget({
    super.key,
    required this.valueController,
    required this.paymentsBloc,
    required this.functionConfirm,
    required this.function,
  });
  final TextEditingController valueController;
  final PaymentsBloc paymentsBloc;
  final Function functionConfirm;
  final Function() function;

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
              CustomBackButtonWidget(
                backButton: () {
                  function();
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Digite o valor a ser pago:',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              PaymentValueTextFieldWidget(controller: valueController),
              const SizedBox(height: 8),

              const Spacer(),
              // Oculta o teclado digital no GPOS 760 (usa teclado físico)
              if (!hasPhysicalKeyboard)
                DigitalKeyboard(
                  numbers: const [
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
                  ],
                  confirmButton: ButtonDigitalWidget(
                    icon: Icons.check_circle,
                    cardText: '',
                    isConfirmButton: true,
                    function: () {
                      functionConfirm();
                    },
                  ),
                  eraseButton: ButtonDigitalWidget(
                    icon: Icons.backspace,
                    cardText: '',
                    isConfirmButton: false,
                    function: () {
                      Formatters.eraseTextField(valueController);
                    },
                  ),
                  numberButton: (String number) => ButtonNumbersWidget(
                    number: number,
                    function: (number) {
                      if (valueController.text.length >= 11) {
                        return;
                      }
                      valueController.text += number;
                    },
                  ),
                ),
              // No GPOS 760, adiciona um botão de confirmar já que não tem teclado virtual
              if (hasPhysicalKeyboard)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      functionConfirm();
                    },
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
