import 'package:chats/Core/widgets/custom_button.dart';
import 'package:chats/Core/widgets/custom_text_field.dart';
import 'package:chats/Features/Auth_screen/View/resgister_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../Core/Utils/constants.dart';
import '../../../Core/Functions/show_snack_bar.dart';
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
    SignCubit Cubit  = BlocProvider.of<SignCubit>(context)  ;
    return BlocConsumer<SignCubit, SignState>(
      listener: (context, state) {
        if (state is LoginLoading)
         {
           isLoading = true;
         }
         else if (state is LoginSuccess)
           {
             Navigator.pushNamed(context, HomeScreen.id);
           }
         else if (state is LoginErorr)
           {
             showSnackBar(context, state.messageErorr!);
           }
      },
      builder:(context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 75,
                  ),
                  Image.asset(
                    'assets/images/scholar.png',
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scholar Chat',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Row(
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomFormTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: 'Email',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFormTextField(
                    obscureText: true,
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: 'Password',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButon(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        Cubit.loginUser(email: email!, password: password!);

                      } else {}
                    },
                    text: 'LOGIN',
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
