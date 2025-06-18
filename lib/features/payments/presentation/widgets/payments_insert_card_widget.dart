import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/widgets/custom_back_button_widget.dart';

class PaymentsInsertCardWidget extends StatelessWidget {
  final PaymentsBloc paymentsBloc;
  const PaymentsInsertCardWidget({super.key, required this.paymentsBloc});

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
                      return CustomBackButtonWidget(
                        backButton: () {
                          context.pop();
                        },
                      );
                    },
                  ),
                ],
              ),
              Text(
                'Transação com cartão: ',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Por favor passe o cartão no leitor',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              LottieBuilder.asset('assets/default/transact_animation.json'),

              TextButton(
                onPressed: () {
                  paymentsBloc.add(PaymentsEventSetInicialState());
                },
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
