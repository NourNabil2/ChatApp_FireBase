
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


class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  ProfileScreen({super.key, required this.user});

  static String id = 'ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            const Text('Profile'), // TODO ::
          ],
        ),
        centerTitle: true,
      ),
        //floating button to log out
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                //for showing progress dialog
                Dialogs.showProgressBar(context);

               // await APIs.updateActiveStatus(false);

                //sign out from app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    APIs.auth = FirebaseAuth.instance;
                    //replacing home screen with login screen
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.id , (route) => false);
                  });
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout')),
        ),

      body:Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50), // TODO
          child: SingleChildScrollView(
            child: Column(
              children: [
                // for adding some space
                SizedBox(width: 50, height: 30),
                // user profile picture
                Stack(

                  children: [
                //     profile picture
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

                    //edit image button
                    Positioned(
                      bottom: -10,
                      right: -30,
                      child: MaterialButton(
                        elevation: 1,
                        onPressed: () {
                          _showBottomSheet();
                        },
                        shape: const CircleBorder(),
                        color: Colors.white,
                        child: const Icon(Icons.edit, color: Colors.blue),
                      ),
                    )
                  ],
                ),

                // for adding some space
                SizedBox(height: 10),

                // user email label
                Text(widget.user.email,
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 16)),

                // for adding some space
                SizedBox(height: 10),

                // name input field
                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty
                      ? null
                      : 'Required Field',
                  decoration: InputDecoration(
                      prefixIcon:
                      const Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Happy Singh',
                      label: const Text('Name')),
                ),

                // for adding some space
                SizedBox(height: 10),

                // about input field
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (val) => APIs.me.about = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty
                      ? null
                      : 'Required Field',
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.info_outline,
                          color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Feeling Happy',
                      label: const Text('About')),
                ),

                // for adding some space
                SizedBox(height: 20),

                // update profile button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(20, 20)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      APIs.updateUserInfo().then((value) {
                        Dialogs.showSnackbar(
                            context, 'Profile Updated Successfully!'); //todo
                      });
                    }
                  },
                  icon: const Icon(Icons.edit, size: 28),
                  label:
                  const Text('UPDATE', style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          ),
        ),
      ));
}

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(2))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: 10, bottom: 10),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: 20),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(20, 10)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/add_image.png')),
                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(20, 15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}