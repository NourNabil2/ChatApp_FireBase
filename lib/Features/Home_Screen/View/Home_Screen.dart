import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Core/Utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String id = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            Text('Home'),
          ],
        ),
        centerTitle: true,
      ),
    );
  }
}
