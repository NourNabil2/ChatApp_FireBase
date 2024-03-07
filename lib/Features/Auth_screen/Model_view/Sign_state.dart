part of 'Sign_cubit.dart';

@immutable
abstract class SignState {}

class SignInitial extends SignState {}

class LoginSuccess extends SignState {}
class LoginLoading extends SignState {}

class LoginErorr extends SignState {
 final String? messageErorr;
  LoginErorr(this.messageErorr);
}

class RegisterSuccess extends SignState {}
class RegisterLoading extends SignState {}
//ignore: must_be_immutable
class RegisterErorr extends SignState {
  String? messageErorr;
  RegisterErorr({required messageErorr});
}

