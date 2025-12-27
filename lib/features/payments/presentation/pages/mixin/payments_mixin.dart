import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:zeeppay/core/default_options.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/payments/presentation/pages/payments_page.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';
import 'package:zeeppay/shared/models/sell_model.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';
import 'package:zeeppay/shared/service/encript_service.dart';
import 'package:zeeppay/shared/service/log_service.dart';

mixin PaymentsMixin<T extends StatefulWidget> on State<PaymentsPage> {
  final TextEditingController controllerPasswordCard = TextEditingController();
  final TextEditingController controllerValue = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$',
    initialValue: 0,
  );

  String interestType = 'comprador';
  int selectedInstallment = 2;

  final PaymentsBloc paymentsBloc = getIt.get<PaymentsBloc>();
  FlavorConfig get flavorConfig => FlavorConfig.instance;
  SettingsPosDataStore get posData => SettingsPosDataStore();
  final database = getIt<Database>();

  late SellModel sellModel = SellModel();
  @override
  void initState() {
    super.initState();
    sellModel = getIt.get<SellModel>();
  }

  void setValue(String value) {
    sellModel.valorCompra = Formatters.parseCurrency(value);
  }

  void setPaymentType(String paymentType) {
    sellModel.tipoParcelamento = paymentType;
  }

  void setCardNumber(String cardNumber) {
    sellModel.plastico = cardNumber;
  }

  void setNsu(String nsu) {
    sellModel.nsuCaptura = "1";
  }

  void setCodigoEstabelecimento() {
    try {
      StorePosModel store = StorePosModel.fromJson(
        json.decode(database.getString("store")!),
      );
      sellModel.codigoEstabelecimento = '0${store.cnpj}';
    } catch (e) {
      LogService.instance.logInfo('Erro de cnpj', 'CNPJ NAO INFORMADO');
    }
  }

  void setTipoCripitografia() {
    sellModel.tipoCriptografia = '3DES';
  }

  void setDataLocalAndDataCompra() {
    sellModel.dataCompra = Formatters.formatDateTime(
      DateTime.now(),
      'yyyy/MM/dd',
    );
    sellModel.dataLocal = DateTime.now().toLocal().toString();
  }

  void setPrazo(int prazo) {
    sellModel.prazo = prazo;
  }

  void setPassword(String password) {
    sellModel.senha = EncriptService.encrypt3DES(
      "${password}FFFF",
      DefaultOptions.keyEncript,
    );
    setNsu("1");
    setDataLocalAndDataCompra();
    setCodigoEstabelecimento();
  }

  void resetDatas() {
    controllerPasswordCard.clear();
    controllerValue.text = 'R\$ 0,00';

    // FIX: Pega nova instância do Factory ao invés de tentar resetar Singleton
    // Agora cada transação terá um SellModel completamente novo e isolado
    sellModel = getIt.get<SellModel>();
  }

  void onSelectedInstallmentChanged(int installment) {
    setState(() {
      selectedInstallment = installment;
    });
    setPrazo(selectedInstallment);
  }

  void onInterestTypeChanged(String interestTypeSelected) {
    setState(() {
      interestType = interestTypeSelected;
    });
    if (interestTypeSelected == 'comprador') {
      sellModel.tipoParcelamento = '3'; // Comprador
      sellModel.plano = ''; // Comprador
    } else {
      sellModel.plano = '';
      sellModel.tipoParcelamento = '2'; // Loja
    }
  }
}
