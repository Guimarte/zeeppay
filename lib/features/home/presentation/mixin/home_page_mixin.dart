import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/cashier/domain/usecases/cashier_usecase.dart';
import 'package:zeeppay/features/home/domain/repository/home_repository.dart';
import 'package:zeeppay/features/home/domain/usecase/home_usecase.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';
import 'package:zeeppay/shared/widgets/show_dialog_confirm_widget.dart';
import 'package:zeeppay/shared/widgets/show_dialog_erro_widget.dart';
import 'package:zeeppay/shared/widgets/show_dialog_loading_widget.dart';
import 'package:zeeppay/core/pos_data_store.dart';

mixin HomePageMixin {
  final HomeUsecase homeUsecase = GetIt.instance<HomeUsecase>();
  final CashierUsecase cashierUsecase = GetIt.instance<CashierUsecase>();
  final Database database = GetIt.instance<Database>();
  final HomeRepository homeRepository = GetIt.instance<HomeRepository>();
  SettingsPosDataStore get posData => SettingsPosDataStore();

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar Última Venda'),
        content: const Text('Tem certeza que deseja cancelar a última venda?'),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () async {
              dialogContext.pop();
              await _handleCancelLastSale(context);
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }

  void showCloseCashierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Realizar fechamento do caixa'),
        content: const Text('Tem certeza que deseja fechar o caixa?'),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () async {
              dialogContext.pop();
              await _handleCloseCashier(context);
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }

  Future<void> testPrint(BuildContext context) async {
    try {
      showLoadingDialog(context);

      final testContent = '''
============================
    TESTE DE IMPRESSÃO
============================

Data: ${Formatters.formatDateTime(DateTime.now(), 'dd/MM/yyyy HH:mm')}

Este é um teste de impressão
da impressora GERTEC.

Linha 1
Linha 2
Linha 3

============================
   IMPRESSÃO REALIZADA
============================
''';

      await GertecService.printProfile(testContent);

      if (!context.mounted) return;
      Navigator.of(context).pop();

      showDialogConfirm(context, message: 'Impressão de teste enviada!');
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();

      showErrorDialog(context, message: 'Erro ao testar impressão: ${e.toString()}');
    }
  }

  Future<void> _handleCancelLastSale(BuildContext context) async {
    if (!_hasPendingSale()) {
      if (context.mounted) {
        showErrorDialog(context, message: 'Nenhuma venda para cancelar!');
      }
      return;
    }

    showLoadingDialog(context);

    final result = await _cancelSale();

    if (!context.mounted) return;

    Navigator.of(context).pop();

    result.fold(
      (failure) =>
          showErrorDialog(context, message: 'Erro ao cancelar a venda'),
      (_) {
        database.remove('lastSale');
        showDialogConfirm(context, message: 'Venda cancelada com sucesso!');
      },
    );
  }

  Future<void> _handleCloseCashier(BuildContext context) async {
    showLoadingDialog(context);

    final result = await _closeCashier();

    if (!context.mounted) return;

    Navigator.of(context).pop();

    result.fold(
      (failure) => showErrorDialog(context, message: 'Erro ao fechar o caixa'),
      (_) {
        database.remove('cashierSessionId');
        showDialogConfirm(context, message: 'Caixa Encerrado com sucesso!');
      },
    );
  }

  bool _hasPendingSale() {
    final lastSale = database.getString('lastSale');
    return lastSale != null && lastSale.isNotEmpty;
  }

  Future<Either<Exception, Unit>> _cancelSale() async {
    try {
      final lastSaleRaw = database.getString('lastSale');
      if (lastSaleRaw == null) return Left(Exception('Venda não encontrada'));

      final sale = jsonDecode(lastSaleRaw) as Map<String, dynamic>;

      sale['datDataCompra'] = Formatters.formatDateTime(
        DateTime.now(),
        'yyyy-MM-dd',
      );

      final response = await homeUsecase.call(sale);
      return response.isRight()
          ? const Right(unit)
          : Left(Exception('Erro ao cancelar a venda'));
    } catch (e) {
      return Left(Exception('Erro inesperado ao cancelar a venda'));
    }
  }

  Future<Either<Exception, String>> _closeCashier() async {
    try {
      final deviceId = posData.settings?.devices!.first.id ?? '';

      final currentSessionResult = await cashierUsecase.getCurrentSession(
        deviceId,
      );
      return await currentSessionResult.fold(
        (failure) async => Left(Exception(failure.message)),
        (cashier) async {
          if (cashier == null) {
            return Left(Exception('Nenhuma sessão de caixa ativa encontrada'));
          }

          try {
            final closeResult = await cashierUsecase.closeCashier(
              deviceId,
              cashier.id!,
            );
            return closeResult.fold(
              (failure) => Left(Exception(failure.message)),
              (success) => const Right(''),
            );
          } catch (e) {
            return Left(Exception('Erro ao fechar o caixa: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(Exception('Erro inesperado ao fechar o caixa'));
    }
  }
}
