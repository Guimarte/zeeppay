import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/cashier/cashier.dart';
import 'package:zeeppay/features/cashier/presentation/cashier_page_mixin.dart';
import 'package:zeeppay/features/cashier/presentation/widgets/body_cashier.dart';
import 'package:zeeppay/features/cashier/presentation/widgets/button_cashier.dart';
import 'package:zeeppay/features/cashier/presentation/widgets/header_cashier.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> with CashierPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CashierBloc, CashierState>(
        bloc: cashierBloc,
        builder: (context, state) {
          if (state is CashierStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CashierStateCurrentSession) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: HeaderCashier(cashierModel: state.cashier!),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BodyCashier(cashierModel: state.cashier!),
                    ),
                  ),
                  SizedBox(height: 16),
                  ButtonCashier(function: () {}),
                ],
              ),
            );
          } else {
            return Text("Error");
          }
        },
      ),
    );
  }
}
