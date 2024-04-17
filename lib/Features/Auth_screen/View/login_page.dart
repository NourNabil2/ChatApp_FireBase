import 'dart:developer';

import 'package:chats/Core/widgets/custom_button.dart';
import 'package:chats/Core/widgets/custom_text_field.dart';
import 'package:chats/Features/Auth_screen/View/resgister_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../Core/Functions/CashSaver.dart';
import '../../../Core/Network/API.dart';
import '../../../Core/Utils/Colors.dart';
import '../../../Core/Utils/constants.dart';
import '../../../Core/Functions/show_snack_bar.dart';
import '../../../Core/widgets/component.dart';
import '../../Chat_Screen/View/chat_page.dart';
import '../../Home_Screen/View/Home_Screen.dart';
import '../Model_view/Sign_cubit.dart';

class LoginPage extends StatelessWidget {
  bool isLoading = false;

  static String id = 'login page';

  GlobalKey<FormState> formKey = GlobalKey();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? email, password;
    SignCubit Cubit = BlocProvider.of<SignCubit>(context);
    return BlocConsumer<SignCubit, SignState>(
      listener: (context, state) async {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          isLoading = false;
          await CashSaver.SaveData(key: 'Login', value: true).then((value) async {

            if ((await APIs.userExists())) {
            Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.id,
            (route) => false,
            );
            } else {
            await APIs.createUser().then((value) {
            Navigator.pushNamed(context, HomeScreen.id);
            });
            }

          });


        } else if (state is LoginErorr) {
          isLoading = false;
          showSnackBar(context, state.messageErorr!);
        }
      },
      builder: (context, state) => ModalProgressHUD(
        progressIndicator: Image.asset(kindicator),
        inAsyncCall: isLoading,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              color: ColorApp.kPrimaryColor,
                image: DecorationImage(
                    image: AssetImage(kLogoscreen), fit: BoxFit.fill)),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Image.asset(
                    kLogo,
                    height: 200,
                  ),
                  Center(
                    child: Text(
                      'Wellcome to Chato',
                    style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Box(size: 120),
                  CustomFormTextField(
                    obscureText: false,
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: 'Email',
                  ),
                  CustomFormTextField(
                    obscureText: true,
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: 'Password',
                  ),
                  Box(size: 20),
                  CustomButon(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        Cubit.loginUser(email: email!, password: password!);
                      } else {}
                    },
                    text: 'LOGIN',
                  ),
                  Box(size: 20),
                  signInWithText(),
                  Box(size: 20),
                  GoogleButon(
                    onTap: () {
                      Cubit.handleGoogleBtnClick();
                    },
                    text: 'Sgin In With Google',
                  ),
                  Box(size: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont\'t have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Text(
                          '  Register',
                          style: TextStyle(
                            color: Color(0xffC7EDE6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Box(size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
