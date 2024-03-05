
import 'package:chats/Features/Chat_Screen/View/chat_page.dart';
import 'package:chats/Features/Register_screen/View/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Features/Register_screen/Model_view/Sign_cubit.dart';
import 'Features/Register_screen/View/resgister_page.dart';
import 'firebase_options.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignCubit(),
      child: MaterialApp(
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          ChatPage.id : (context) => ChatPage()
        },
        initialRoute: LoginPage.id,
      ),
    );
  }
}

