import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/widgets/custom_back_button_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/input_password_card_widget.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/shared/widgets/button_digital_widget.dart';
import 'package:zeeppay/shared/widgets/button_numbers_widget.dart';
import 'package:zeeppay/shared/widgets/digital_keyboard.dart';

class PaymentsPasswordsWidget extends StatelessWidget {
  PaymentsPasswordsWidget({
    super.key,
    required this.controllerPasswordCard,
    required this.paymentsBloc,
    required this.onConfirm,
  });
  final PaymentsBloc paymentsBloc;

  final TextEditingController controllerPasswordCard;
  final Function() onConfirm;

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
    final theme = Theme.of(context);
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;

    return BlocBuilder(
      bloc: paymentsBloc,
      builder: (context, state) {
        return SafeArea(
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomBackButtonWidget(
                    backButton: () {
                      context.pop();
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Digite a sua senha:',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  InputPasswordTextFormField(
                    controllerPasswordCard: controllerPasswordCard,
                  ),
                  Spacer(),
                  // Oculta o teclado digital no GPOS 760 (usa teclado físico)
                  if (!hasPhysicalKeyboard)
                    DigitalKeyboard(
                      numbers: numbers,
                      confirmButton: ButtonDigitalWidget(
                        function: () {
                          if (controllerPasswordCard.text.isEmpty ||
                              controllerPasswordCard.text.length < 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Digite a senha de 4 dígitos do cartão',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          onConfirm();
                        },
                        icon: Icons.check_circle,
                        cardText: '',
                        isConfirmButton: true,
                      ),
                      eraseButton: ButtonDigitalWidget(
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
                        cardText: '',
                        isConfirmButton: false,
                        icon: Icons.backspace,
                      ),
                      numberButton: (String number) => ButtonNumbersWidget(
                        number: number,
                        function: (string) {
                          if (controllerPasswordCard.text.length == 4) return;
                          controllerPasswordCard.text += string;
                        },
                      ),
                    ),
                  // No GPOS 760, adiciona um botão de confirmar já que não tem teclado virtual
                  if (hasPhysicalKeyboard)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (controllerPasswordCard.text.isEmpty ||
                              controllerPasswordCard.text.length < 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Digite a senha de 4 dígitos do cartão',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          onConfirm();
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
      },
    );
  }
}
