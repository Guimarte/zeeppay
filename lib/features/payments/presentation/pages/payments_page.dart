import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';
import 'package:zeeppay/features/payments/presentation/pages/mixin/payments_mixin.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_passwords_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_type_payment_widget.dart';

class PaymentsPage extends StatelessWidget with PaymentsMixin {
  PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: BlocBuilder<PaymentsBloc, PaymentsState>(
            bloc: paymentsBloc,
            builder: (context, state) {
              switch (state) {
                case PaymentsStateGetPassword():
                  return PaymentsPasswordsWidget(
                    controllerPasswordCard: controllerPasswordCard,
                  );
                case PaymentsStateLoading():
                  return Center(child: CircularProgressIndicator());
                default:
                  return PaymentsTypePaymentWidget(
                    function: () {
                      paymentsBloc.add(PaymentsEventGetPassword());
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
