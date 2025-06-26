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
import 'package:zeeppay/features/payments/presentation/widgets/payments_term_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_type_payment_widget.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';
import 'package:zeeppay/shared/widgets/show_dialog_erro_widget.dart';

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
                final cardNumber = await GertecService.readCard();

                if (!mounted) return;
                setCardNumber(cardNumber);
                if (cardNumber.contains("Erro") || cardNumber.isEmpty) {
                  showErrorDialog(context, message: cardNumber);

                  return paymentsBloc.add(PaymentsEventErrorCard());
                } else {
                  paymentsBloc.add(PaymentsEventGetPassword());
                }
              }

              if (state is PaymentsStateSuccess) {
                resetDatas();
                return paymentsBloc.add(PaymentsEventSetInicialState());
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
                      function: () {
                        paymentsBloc.add(PaymentsEventSetInicialState());
                      },
                      functionConfirm: () {
                        setValue(controllerValue.text);
                        paymentsBloc.add(PaymentsEventPutCardState());
                      },
                      paymentsBloc: paymentsBloc,
                      valueController: controllerValue,
                    );
                  case PaymentsStatePutCard():
                    return PaymentsInsertCardWidget(
                      paymentsBloc: paymentsBloc,
                      function: () async {
                        GertecService.stopReadCard();
                      },
                    );
                  case PaymentsStateTerm():
                    return PaymentsTermWidget(
                      interestType: interestType,
                      onInterestTypeChanged: (String interestTypeSelected) =>
                          onInterestTypeChanged(interestTypeSelected),
                      onSelectedInstallmentChanged: (int installment) =>
                          onSelectedInstallmentChanged(installment),
                      selectedInstallment: selectedInstallment,
                      paymentsBloc: paymentsBloc,
                      functionPrimaryButton: () {
                        paymentsBloc.add(PaymentsEventPutValueState());
                      },
                    );
                  default:
                    resetDatas();
                    return PaymentsTypePaymentWidget(
                      paymentsBloc: paymentsBloc,
                      onVistaTap: () {
                        setPrazo(1);
                        setPaymentType('1');

                        paymentsBloc.add(PaymentsEventPutValueState());
                      },
                      onParceladoTap: () {
                        setPaymentType('2');

                        paymentsBloc.add(PaymentsEventTerm());
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
