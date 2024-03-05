part of 'Sign_cubit.dart';

@immutable
abstract class SignState {}

class SignInitial extends SignState {}

class LoginSuccess extends SignState {}
class LoginLoading extends SignState {}
class LoginErorr extends SignState {
  String? messageErorr;
  LoginErorr({required messageErorr});
}

class RegisterSuccess extends SignState {}
class RegisterLoading extends SignState {}
class RegisterErorr extends SignState {
  String? messageErorr;
  RegisterErorr({required messageErorr});
}

