// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/widgets/custom_back_button_widget.dart';
import 'package:zeeppay/shared/widgets/primary_button.dart';

class PaymentsTermWidget extends StatelessWidget {
  const PaymentsTermWidget({
    super.key,
    required this.paymentsBloc,
    required this.functionPrimaryButton,
    required this.interestType,
    required this.onInterestTypeChanged,
    required this.selectedInstallment,
    required this.onSelectedInstallmentChanged,
  });

  final PaymentsBloc paymentsBloc;
  final Function() functionPrimaryButton;
  final String interestType;
  final Function(String interestTypeSelected) onInterestTypeChanged;
  final int selectedInstallment;
  final Function(int installment) onSelectedInstallmentChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: BlocBuilder(
        bloc: paymentsBloc,
        builder: (context, state) {
          return Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButtonWidget(
                  backButton: () {
                    context.pop();
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Escolha o tipo de juros:',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InterestButtonWidget(
                      isSelected: interestType == 'comprador',
                      value: 'comprador',
                      label: 'Parcelado emissor',
                      onTap: () {
                        onInterestTypeChanged('comprador');
                      },
                    ),
                    const SizedBox(width: 12),
                    InterestButtonWidget(
                      value: 'loja',
                      label: 'Parcelado loja',
                      isSelected: interestType == 'loja',
                      onTap: () {
                        onInterestTypeChanged('loja');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Escolha o número de parcelas:',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final parcela = index + 2;
                      final isSelected = selectedInstallment == parcela;

                      return GestureDetector(
                        onTap: () {
                          onSelectedInstallmentChanged(parcela);
                        },
                        child: Card(
                          elevation: isSelected ? 4 : 1,
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isSelected
                                ? BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  )
                                : BorderSide(color: Colors.grey.shade300),
                          ),
                          child: ListTile(
                            leading: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                            title: Text(
                              '$parcela parcelas',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : null,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.arrow_forward_ios, size: 16)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  buttonName: 'Confirmar',
                  functionPrimaryButton: functionPrimaryButton,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InterestButtonWidget extends StatelessWidget {
  const InterestButtonWidget({
    super.key,
    required this.value,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final bool isSelected;
  final String value;
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? theme.colorScheme.primary
              : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          onTap();
        },
        child: Text(label, style: theme.textTheme.labelMedium),
      ),
    );
  }
}
