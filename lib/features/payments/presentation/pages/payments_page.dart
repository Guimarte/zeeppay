import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';
import 'package:zeeppay/features/payments/presentation/pages/mixin/payments_mixin.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_input_value_widget.dart';
import 'package:zeeppay/shared/widgets/payments_insert_card_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_passwords_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_term_widget.dart';
import 'package:zeeppay/features/payments/presentation/widgets/payments_type_payment_widget.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';
import 'package:zeeppay/shared/widgets/show_dialog_erro_widget.dart';
import 'package:zeeppay/shared/service/log_service.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> with PaymentsMixin {
  @override
  void dispose() {
    paymentsBloc.close();
    controllerPasswordCard.dispose();
    controllerValue.dispose();
    super.dispose();
  }

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
                  if (mounted) {
                    showErrorDialog(context, message: cardNumber);
                  }
                  return paymentsBloc.add(PaymentsEventErrorCard());
                } else {
                  paymentsBloc.add(PaymentsEventGetPassword());
                }
              }

              if (state is PaymentsStateError) {
                if (mounted) {
                  showPaymentErrorDialog(
                    context,
                    message: state.error ?? 'Erro na transação',
                    onRetry: () {
                      // Limpa a senha se for erro relacionado à senha
                      if (state.error?.toLowerCase().contains('senha') == true ||
                          state.error?.toLowerCase().contains('password') == true ||
                          state.error?.toLowerCase().contains('pin') == true) {
                        controllerPasswordCard.clear();
                        paymentsBloc.add(PaymentsEventGetPassword());
                      } else {
                        paymentsBloc.add(PaymentsEventSetInicialState());
                      }
                    },
                  );
                }
              }

              if (state is PaymentsStateAskClientReceipt) {
                if (mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Imprimir Via do Cliente?'),
                      content: const Text('Deseja imprimir a via do cliente?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            paymentsBloc.add(PaymentsEventPrintClientReceipt(
                              receiveModel: state.receiveModel,
                              printClient: false,
                            ));
                          },
                          child: const Text('Não'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            paymentsBloc.add(PaymentsEventPrintClientReceipt(
                              receiveModel: state.receiveModel,
                              printClient: true,
                            ));
                          },
                          child: const Text('Sim'),
                        ),
                      ],
                    ),
                  );
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
                        try {
                          LogService.instance.logInfo(
                            'PaymentsPage',
                            'onConfirm CHAMADO - Iniciando confirmação de senha',
                            details: {
                              'senhaPreenchida': controllerPasswordCard.text.isNotEmpty,
                              'tamanhoSenha': controllerPasswordCard.text.length,
                            },
                          );

                          setPassword(controllerPasswordCard.text);

                          LogService.instance.logInfo(
                            'PaymentsPage',
                            'Senha setada - SellModel antes de disparar evento',
                            details: sellModel.toJson(),
                          );

                          LogService.instance.logInfo(
                            'PaymentsPage',
                            'PRESTES A DISPARAR PaymentsEventTransact',
                          );

                          paymentsBloc.add(
                            PaymentsEventTransact(sellModel: sellModel),
                          );

                          LogService.instance.logInfo(
                            'PaymentsPage',
                            'PaymentsEventTransact DISPARADO COM SUCESSO',
                          );
                        } catch (e, stackTrace) {
                          LogService.instance.logError(
                            'PaymentsPage',
                            'ERRO no onConfirm',
                            details: {
                              'error': e.toString(),
                              'stackTrace': stackTrace.toString(),
                            },
                          );
                        }
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
                    return InsertCardWidget(
                      bloc: paymentsBloc,
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
