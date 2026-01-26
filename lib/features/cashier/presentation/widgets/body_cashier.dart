import 'package:flutter/material.dart';
import 'package:zeeppay/features/cashier/cashier.dart';

class BodyCashier extends StatelessWidget {
  final CashierModel cashierModel;
  const BodyCashier({required this.cashierModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            RowCashierBody(
              paymentType: "Crédito",
              value: cashierModel
                  .summary!
                  .paymentsSummary!
                  .paymentsValueByCreditCard!,
            ),
            SizedBox(height: 8),
            RowCashierBody(
              paymentType: "Débito",
              value: cashierModel
                  .summary!
                  .paymentsSummary!
                  .paymentsValueByDebitCard!,
            ),
            SizedBox(height: 8),
            RowCashierBody(
              paymentType: "Pix",
              value: cashierModel.summary!.paymentsSummary!.paymentsValueByPix!,
            ),
            SizedBox(height: 8),
            RowCashierBody(
              paymentType: "Dinheiro",
              value:
                  cashierModel.summary!.paymentsSummary!.paymentsValueByCash!,
            ),
          ],
        ),
      ),
    );
  }
}

class RowCashierBody extends StatelessWidget {
  final String paymentType;
  final double value;
  const RowCashierBody({
    required this.paymentType,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(paymentType),
              Text('R\$${value.toStringAsFixed(2)}'),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
