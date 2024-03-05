import 'package:chats/Features/Auth_screen/Model_view/Sign_cubit.dart';
import 'package:chats/Features/Chat_Screen/View/chat_page.dart';
import 'package:chats/Features/Home_Screen/View/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Features/Auth_screen/View/login_page.dart';
import 'Features/Auth_screen/View/resgister_page.dart';
import 'Features/Chat_Screen/Model_View/chat_cubit.dart';
import 'firebase_options.dart';

void main() async {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          ChatPage.id: (context) => ChatPage()
        },
        initialRoute: HomeScreen.id,
      ),
    );
  }
}
