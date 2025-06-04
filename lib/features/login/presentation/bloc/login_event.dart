abstract class LoginEvent {}

class RealizeLogin extends LoginEvent {
  String username;
  String password;
  bool saveCredentials;
  RealizeLogin({
    required this.username,
    required this.password,
    required this.saveCredentials,
  });
}
