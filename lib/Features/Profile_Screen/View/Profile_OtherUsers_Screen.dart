
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/Core/Network/API.dart';

import 'package:chats/Features/Auth_screen/View/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


import '../../../Core/Functions/show_snack_bar.dart';
import '../../../Core/Utils/constants.dart';
import '../../Home_Screen/Data/Users.dart';


class Porfile_Other_Users extends StatefulWidget {
  final ChatUser user;
  Porfile_Other_Users({super.key, required this.user});

  static String id = 'ProfileScreen';

  @override
  State<Porfile_Other_Users> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Porfile_Other_Users> {
  final _formKey = GlobalKey<FormState>();

  String? _image;

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
               Text(widget.user.name), // TODO ::
            ],
          ),
          centerTitle: true,
        ),

        body:Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100,vertical: 50), // TODO
            child: SingleChildScrollView(
              child: Column(

                children: [

                  // user profile picture
                  _image != null
                      ?
                  //   local image
                  ClipRRect(
                      borderRadius:
                      BorderRadius.circular(50 ),
                      child: Image.file(File(_image!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover))
                      :
                  //   image from server
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      width: 100,
                      height:100,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  // for adding some space
                  SizedBox(height: 10),
                  // user email label
                  Text(widget.user.email,
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 16)),
                  // about input field
                  Text(
                     widget.user.about,
                  ),

                ],
              ),
            ),
          ),
        ));
  }

  // bottom sheet for picking a profile picture for user

}