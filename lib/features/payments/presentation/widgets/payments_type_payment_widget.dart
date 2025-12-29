import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/shared/widgets/card_widget.dart';

class PaymentsTypePaymentWidget extends StatelessWidget {
  final VoidCallback onVistaTap;
  final VoidCallback? onParceladoTap;
  final PaymentsBloc paymentsBloc;
  const PaymentsTypePaymentWidget({
    super.key,
    required this.onVistaTap,
    this.onParceladoTap,
    required this.paymentsBloc,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder(
                    bloc: paymentsBloc,
                    builder: (context, state) {
                      return GestureDetector(
                        child: const Icon(Icons.arrow_back, size: 32),
                        onTap: () {
                          context.pop();
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Text(
                'Tipo de pagamento',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Escolha a forma que deseja realizar o pagamento:',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CardWidget(
                      cardName: "À vista",
                      icon: Icons.attach_money,
                      onTap: onVistaTap,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CardWidget(
                      cardName: "Parcelado",
                      icon: Icons.payments,
                      onTap: onParceladoTap ?? () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
