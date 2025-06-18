import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';
import 'package:zeeppay/features/payments/presentation/pages/mixin/payments_mixin.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_input_value_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_insert_card_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_passwords_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_type_payment_widget.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';

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

                setCardNumber(cardNumber);
                paymentsBloc.add(PaymentsEventGetPassword());
              }
              if (state is PaymentsStateSuccess) {
                resetDatas();
                paymentsBloc.add(PaymentsEventSetInicialState());
                context.pop();
              }
            },
            child: BlocBuilder<PaymentsBloc, PaymentsState>(
              bloc: paymentsBloc,
              builder: (context, state) {
                switch (state) {
                  case PaymentsStatePutPassword():
                    return PaymentsPasswordsWidget(
                      onConfirm: () {
                        setPassword(controllerPasswordCard.text);
                        paymentsBloc.add(
                          PaymentsEventTransact(sellModel: sellModel),
                        );
                      },
                      controllerPasswordCard: controllerPasswordCard,
                      paymentsBloc: paymentsBloc,
                    );
                  case PaymentsStateLoading():
                    return const Center(child: CircularProgressIndicator());
                  case PaymentsStatePutValue():
                    return PaymentsInputValueWidget(
                      functionConfirm: () {
                        setValue(controllerValue.text);
                        paymentsBloc.add(PaymentsEventPutCardState());
                      },
                      paymentsBloc: paymentsBloc,
                      valueController: controllerValue,
                    );
                  case PaymentsStatePutCard():
                    return PaymentsInsertCardWidget(paymentsBloc: paymentsBloc);

                  default:
                    resetDatas();
                    return PaymentsTypePaymentWidget(
                      paymentsBloc: paymentsBloc,
                      onVistaTap: () {
                        setPaymentType('1');

                        paymentsBloc.add(PaymentsEventPutValueState());
                      },
                      onParceladoTap: () {
                        setPaymentType('2');

                        paymentsBloc.add(PaymentsEventPutValueState());
                      },
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
