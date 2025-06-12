import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';
import 'package:zeeppay/features/payments/presentation/pages/mixin/payments_mixin.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_input_value_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_insert_card_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_passwords_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_type_payment_widget.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> with PaymentsMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: BlocListener<PaymentsBloc, PaymentsState>(
            bloc: paymentsBloc,
            listener: (context, state) async {
              if (state is PaymentsStatePutCard) {
                final cardNumber = await readCard();
                if (!mounted) return;

                paymentsBloc.add(
                  PaymentsEventGetPassword(cardNumber: cardNumber),
                );
              }
            },
            child: BlocBuilder<PaymentsBloc, PaymentsState>(
              bloc: paymentsBloc,
              builder: (context, state) {
                switch (state) {
                  case PaymentsStatePutPassword():
                    return PaymentsPasswordsWidget(
                      controllerPasswordCard: controllerPasswordCard,
                    );
                  case PaymentsStateLoading():
                    return const Center(child: CircularProgressIndicator());
                  case PaymentsStatePutValue():
                    return PaymentsInputValueWidget(
                      functionConfirm: () =>
                          paymentsBloc.add(PaymentsEventPutCardState()),
                      paymentsBloc: paymentsBloc,
                      valueController: controllerValue,
                    );
                  case PaymentsStatePutCard():
                    return PaymentsInsertCardWidget(
                      paymentsBloc: paymentsBloc,
                    ); // <- Só visual agora
                  default:
                    return PaymentsTypePaymentWidget(
                      paymentsBloc: paymentsBloc,
                      onVistaTap: () {
                        paymentsBloc.add(PaymentsEventPutValueState());
                      },
                      onParceladoTap: () {},
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
