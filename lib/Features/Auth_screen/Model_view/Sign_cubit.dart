


import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'Sign_state.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(SignInitial());

  Future<void> loginUser({required String email ,required String password}) async {
      emit(LoginLoading());
    try{
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());


    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(LoginErorr(messageErorr: 'user-not-found'));
      } else if (ex.code == 'wrong-password') {
        emit(LoginErorr(messageErorr: 'wrong-password'));
      }
    } catch (e) {
      emit(LoginErorr(messageErorr: 'there was an error'));
    }

  }


  Future<void> registerUser({required String email ,required String password}) async {
    emit(RegisterLoading());
    try {
       UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        emit(RegisterErorr(messageErorr: 'weak-password'));
      } else if (ex.code == 'email-already-in-use') {
        emit(RegisterErorr(messageErorr: 'email-already-in-use'));
      }
    } catch (e) {
      emit(RegisterErorr(messageErorr:  'there was an error'));


    }


  }

}
