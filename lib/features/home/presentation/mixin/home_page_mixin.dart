import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/home/domain/repository/home_repository.dart';
import 'package:zeeppay/features/home/domain/usecase/home_usecase.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';

mixin HomePageMixin {
  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  final HomeUsecase homeUsecase = GetIt.instance<HomeUsecase>();
  final Database database = GetIt.instance<Database>();
  final HomeRepository homeRepository = GetIt.instance<HomeRepository>();

  Future<void> cancelLastSale() async {
    String lastSale = database.getString('lastSale') ?? '';
    if (lastSale.isNotEmpty) {
      Map<String, dynamic> sale = jsonDecode(database.getString('lastSale')!);
      sale.addEntries(
        {
          'datDataCompra': Formatters.formatDateTime(
            DateTime.now(),
            'yyyy-MM-dd',
          ),
        }.entries,
      );
      final response = homeUsecase.call(sale);
      if (response == true) {
        database.remove('lastSale');
        ScaffoldMessenger.of(
          GetIt.instance<GlobalKey<NavigatorState>>().currentContext!,
        ).showSnackBar(
          const SnackBar(content: Text('Última venda cancelada com sucesso!')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        GetIt.instance<GlobalKey<NavigatorState>>().currentContext!,
      ).showSnackBar(
        const SnackBar(content: Text('Nenhuma venda para cancelar!')),
      );
    }
  }

  void showCancelDialog(BuildContext context) {
    context.pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Última Venda'),
        content: const Text('Tem certeza que deseja cancelar a última venda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // cancela
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await cancelLastSale();
            },
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );
  }
}
