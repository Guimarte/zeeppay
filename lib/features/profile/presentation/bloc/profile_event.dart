abstract class ProfileEvent {}

class ProfileCpfEventLoad extends ProfileEvent {
  final String document;

  ProfileCpfEventLoad({required this.document});
}

class ProfileCardEventLoad extends ProfileEvent {
  final String? cardNumber;

  ProfileCardEventLoad({this.cardNumber});
}

class ProfileCpfEventSet extends ProfileEvent {}
