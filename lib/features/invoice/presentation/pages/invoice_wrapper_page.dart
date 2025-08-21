import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injector.dart';
import '../bloc/invoice_bloc.dart';
import 'invoice_page.dart';

class InvoiceWrapperPage extends StatelessWidget {
  const InvoiceWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (context) => getIt<InvoiceBloc>(),
      child: const InvoicePage(),
    );
  }
}