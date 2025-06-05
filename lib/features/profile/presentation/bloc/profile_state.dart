import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';

abstract class ProfileState {}

class ProfileStateInitial extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateSucess extends ProfileState {
  final ClienteModel cliente;
  ProfileStateSucess({required this.cliente});
}

class ProfileStateError extends ProfileState {
  final String message;

  ProfileStateError({required this.message});
}
