
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chats/Core/Functions/CashSaver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../../Core/Network/API.dart';
part 'Sign_state.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(SignInitial());

  Future<void> loginUser({required String email ,required String password}) async {
      emit(LoginLoading());
    try{
      UserCredential user = await APIs.auth.signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());

    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(LoginErorr('user-not-found'));
      } else if (ex.code == 'wrong-password') {
        emit(LoginErorr('wrong-password'));
      }
      else {
        emit(LoginErorr('Wrong Email or Passwork'));
      }
    } catch (e) {
      emit(LoginErorr('there was an error'));
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

  Future<UserCredential?> _signInWithGoogle() async {
    emit(LoginLoading());
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
       return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      emit(LoginErorr('Failed login with Google, try again'));

    }
  }

  handleGoogleBtnClick() {

    _signInWithGoogle().then((user) async {
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        emit(LoginSuccess());
      }
        // if ((await APIs.userExists())) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        // } else {
        //   await APIs.createUser().then((value) {
        //     Navigator.pushReplacement(
        //         context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        //   }

    });
  }

}
