import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_bloc.dart';

mixin ProfilePageMixin {
  final profileBloc = getIt.get<ProfileBloc>();
  TextEditingController cpfController = MaskedTextController(
    mask: '000.000.000-00',
  );

  String formatCpf(String cpf) {
    return cpf.replaceAll(RegExp(r'[.-]'), '');
  }
}
