import 'package:flutter/widgets.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

mixin PaymentsMixin {
  final TextEditingController controllerPasswordCard = TextEditingController();
  final PaymentsBloc paymentsBloc = getIt.get<PaymentsBloc>();
  FlavorConfig get flavorConfig => FlavorConfig.instance;
}
