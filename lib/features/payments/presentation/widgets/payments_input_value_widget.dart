import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/widgets/custom_back_button_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_input_text_form_field_widget.dart';
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
  });
  final TextEditingController valueController;
  final PaymentsBloc paymentsBloc;
  final Function functionConfirm;

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
              CustomBackButtonWidget(
                backButton: () {
                  context.pop();
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
            ],
          ),
        ),
      ),
    );
  }
}
