
  import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  class Dialogs {
    static void showSnackbar(BuildContext context, String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Colors.blue.withOpacity(.8),
          behavior: SnackBarBehavior.floating));
    }

    static void showProgressBar(BuildContext context) {
      showDialog(
          context: context,
          builder: (_) => const Center(child: CircularProgressIndicator()));
    }
  }