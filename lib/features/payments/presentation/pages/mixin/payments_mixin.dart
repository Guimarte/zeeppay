import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/pages/payments_page.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';

mixin PaymentsMixin<T extends StatefulWidget> on State<PaymentsPage> {
  final TextEditingController controllerPasswordCard = TextEditingController();
  final TextEditingController controllerValue = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$',
    initialValue: 0,
  );
  final PaymentsBloc paymentsBloc = getIt.get<PaymentsBloc>();
  FlavorConfig get flavorConfig => FlavorConfig.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<String> readCard() async {
    try {
      final result = await GertecService.readCard();
      return result;
    } catch (e) {
      return "Erro ao ler cartão: $e";
    }
  }
}
