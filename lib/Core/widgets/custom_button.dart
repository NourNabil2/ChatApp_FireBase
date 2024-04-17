import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Utils/Colors.dart';
import '../Utils/constants.dart';

class GoogleButon extends StatelessWidget {
  GoogleButon({this.onTap, required this.text});
  VoidCallback? onTap;
  String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(
            width: 1.0,
            color: ColorApp.TextFieldColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(kGoogleSVG),
            ),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: ColorApp.TextFieldColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButon extends StatelessWidget {
  CustomButon({this.onTap, required this.text});
  VoidCallback? onTap;
  String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child:Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorApp.ButtonColor,
            borderRadius: BorderRadius.circular(40.0),

          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: ColorApp.kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}




