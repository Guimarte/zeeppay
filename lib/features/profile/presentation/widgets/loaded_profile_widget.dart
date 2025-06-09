import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_event.dart';
import 'package:zeeppay/features/profile/presentation/widgets/card_limit_client_widget.dart';
import 'package:zeeppay/features/profile/presentation/widgets/card_profile_widget.dart';
import 'package:zeeppay/features/profile/presentation/widgets/invoice_widget.dart';
import 'package:zeeppay/shared/service/print_service.dart';

class LoadedProfileWidget extends StatelessWidget {
  final ClienteModel client;
  final profileBloc;
  const LoadedProfileWidget({
    super.key,
    required this.client,
    required this.profileBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder(
                  bloc: profileBloc,
                  builder: (context, state) {
                    return GestureDetector(
                      child: Icon(Icons.arrow_back),
                      onTap: () {
                        profileBloc.add(ProfileSetInitialEvent());
                      },
                    );
                  },
                ),
                GestureDetector(
                  child: Icon(Icons.print),
                  onTap: () => PrinterService.printClientProfile(client),
                ),
              ],
            ),
            CardProfileWidget(client: client),
            const SizedBox(height: 16),
            CardLimitClientWidget(client: client),
            const SizedBox(height: 16),
            InvoiceCardWidget(client: client),
          ],
        ),
      ),
    );
  }
}
