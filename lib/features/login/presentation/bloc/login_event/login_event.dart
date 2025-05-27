abstract class LoginEvent {}

class RealizeLogin extends LoginEvent {
  String login;
  String password;
  RealizeLogin({required this.login, required this.password});
}
