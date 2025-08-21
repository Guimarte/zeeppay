import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

mixin InvoicePageMixin {
  final TextEditingController cpfController = TextEditingController();
  final ZeeppayDio _dio = ZeeppayDio();
  final SettingsPosDataStore _posData = SettingsPosDataStore();
  Database get database => GetIt.instance<Database>();
  final invoiceBloc = getIt.get<InvoiceBloc>();
}
