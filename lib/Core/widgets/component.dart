import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Functions/show_snack_bar.dart';
import '../Network/API.dart';

Widget signInWithText() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Expanded(child: Divider()),
      const SizedBox(
        width: 16,
      ),
      Text(
        'Or Sign in with',
        style: GoogleFonts.inter(
          fontSize: 12.0,
          color: const Color(0xFF969AA8),
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        width: 16,
      ),
      const Expanded(child: Divider()),
    ],
  );
}

void addChatUserDialog(context) {
  String email = '';

  showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(
            left: 24, right: 24, top: 20, bottom: 10),

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),

        //title
        title: Row(
          children: const [
            Icon(
              Icons.person_add,
              color: Colors.blue,
              size: 28,
            ),
            Text('  Add User')
          ],
        ),

        //content
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
              hintText: 'Email Id',
              prefixIcon: const Icon(Icons.email, color: Colors.blue),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),

        //actions
        actions: [
          //cancel button
          MaterialButton(
              onPressed: () {
                //hide alert dialog
                Navigator.pop(context);
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16))),

          //add button
          MaterialButton(
              onPressed: () async {
                //hide alert dialog
                Navigator.pop(context);
                if (email.isNotEmpty) {
                  await APIs.addChatUser(email).then((value) {
                    if (!value) {
                      Dialogs.showSnackbar(
                          context, 'User does not Exists!');
                    }
                  });
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ))
        ],
      ));
}

Widget Box({required double size })
{
  return SizedBox(
    height: size,
  );
}