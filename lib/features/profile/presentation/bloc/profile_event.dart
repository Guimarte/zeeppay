abstract class ProfileEvent {}

class ProfileEventLoad extends ProfileEvent {
  final String? document;

  ProfileEventLoad({this.document});
}
