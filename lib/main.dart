import 'dart:developer';

import 'package:chats/Core/Functions/CashSaver.dart';
import 'package:chats/Features/Auth_screen/Model_view/Sign_cubit.dart';
import 'package:chats/Features/Chat_Screen/View/chat_page.dart';
import 'package:chats/Features/Home_Screen/View/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'Features/Auth_screen/View/login_page.dart';
import 'Features/Auth_screen/View/resgister_page.dart';
import 'Features/Chat_Screen/Model_View/chat_cubit.dart';
import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await CashSaver.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((value) async {
    await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats',
      enableSound: true,
      allowBubbles: true,
      showBadge: true,
      enableVibration: true,

    );
  //  _initializeFirebase();
    runApp(const MyApp());
  });
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
        //BlocProvider(create: (context) => HomeCubit()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColorLight: Colors.white70,
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white,fontSize: 26),
          titleSmall: TextStyle(color: Colors.white,fontSize: 12,),
          labelSmall: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.bold),

        )
        ),
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
        },
        initialRoute: CashSaver.getData(key: 'Login')??false ? HomeScreen.id : LoginPage.id ,
      ),
    );
  }
}
_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats',
    enableSound: true,
    allowBubbles: true,
    showBadge: true,
    enableVibration: true,
  );
  log('\nNotification Channel Result: $result');
}