import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';

abstract class ProfileState {}

class ProfileStateInitial extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateSearchCpf extends ProfileState {}

class ProfileStateSearchCard extends ProfileState {
  final String cardNumber;

  ProfileStateSearchCard({required this.cardNumber});
}

class ProfileStateSucess extends ProfileState {
  final List<ClienteModel> cliente;
  ProfileStateSucess({required this.cliente});
}

class ProfileStateError extends ProfileState {
  final String message;

  ProfileStateError({required this.message});
}
