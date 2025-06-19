import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/shared/widgets/primary_button.dart';

class PaymentsTermWidget extends StatelessWidget {
  const PaymentsTermWidget({
    super.key,
    required this.paymentsBloc,
    required this.functionPrimaryButton,
  });

  final PaymentsBloc paymentsBloc;
  final Function() functionPrimaryButton;

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
                Text(
                  'Escolha o tipo de juros:',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InterestButtonWidget(
                      isSelected: paymentsBloc.interestType == 'comprador',
                      value: 'comprador',
                      label: 'Juros comprador',
                      onTap: () {
                        paymentsBloc.interestType = 'comprador';
                      },
                    ),
                    const SizedBox(width: 12),
                    InterestButtonWidget(
                      value: 'loja',
                      label: 'Juros loja',
                      isSelected: paymentsBloc.interestType == 'loja',
                      onTap: () {
                        paymentsBloc.interestType = 'loja';
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
                      final isSelected =
                          paymentsBloc.selectedInstallment == parcela;

                      return GestureDetector(
                        onTap: () {
                          paymentsBloc.selectedInstallment = parcela;
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
