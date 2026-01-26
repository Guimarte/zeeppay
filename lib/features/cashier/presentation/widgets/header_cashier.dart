import 'package:flutter/material.dart';
import 'package:zeeppay/features/cashier/cashier.dart';

class HeaderCashier extends StatelessWidget {
  final CashierModel cashierModel;
  const HeaderCashier({required this.cashierModel, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Caixa: ${cashierModel.operator!.name ?? ''}"),
              Text("Data de abertura: ${cashierModel.openAt}"),
              Text("Status: ${cashierModel.status}"),
            ],
          ),
        ),
      ),
    );
  }
}
