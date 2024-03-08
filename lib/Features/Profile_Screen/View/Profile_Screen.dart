
import 'package:chats/Core/Network/API.dart';

import 'package:chats/Features/Auth_screen/View/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';


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
                // // user profile picture
                // Stack(
                //   children: [
                // //     profile picture
                //     _image != null
                //         ?
                //
                //     //local image
                //     ClipRRect(
                //         borderRadius:
                //         BorderRadius.circular(50 ),
                //         child: Image.file(File(_image!),
                //             width: mq.height * .2,
                //             height: mq.height * .2,
                //             fit: BoxFit.cover))
                //         :
                //     //image from server
                //     ClipRRect(
                //       borderRadius:
                //       BorderRadius.circular(mq.height * .1),
                //       child: CachedNetworkImage(
                //         width: mq.height * .2,
                //         height: mq.height * .2,
                //         fit: BoxFit.cover,
                //         imageUrl: widget.user.image,
                //         errorWidget: (context, url, error) =>
                //         const CircleAvatar(
                //             child: Icon(CupertinoIcons.person)),
                //       ),
                //     ),
                //
                //     //edit image button
                //     Positioned(
                //       bottom: 0,
                //       right: 0,
                //       child: MaterialButton(
                //         elevation: 1,
                //         onPressed: () {
                //          // _showBottomSheet();
                //         },
                //         shape: const CircleBorder(),
                //         color: Colors.white,
                //         child: const Icon(Icons.edit, color: Colors.blue),
                //       ),
                //     )
                //   ],
                // ),

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
}