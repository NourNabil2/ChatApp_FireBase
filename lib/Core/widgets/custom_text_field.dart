import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/Colors.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField({this.hintText, this.onChanged , this.obscureText =false});
  Function(String)? onChanged;
  String? hintText;
  bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsetsDirectional.all(2),
        decoration: BoxDecoration(color: ColorApp.TextFieldColor,borderRadius: BorderRadius.circular(40)),
        child: TextFormField(
          cursorColor: Colors.black,
          style: Theme.of(context).textTheme.labelSmall,
          obscureText:obscureText!,
          validator: (data) {
            if (data!.isEmpty) {
              return '        field is required';
            }
          },
          onChanged: onChanged,
          decoration: InputDecoration(

            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none
          ),
          ),
        ),
      ),
    );
  }
}