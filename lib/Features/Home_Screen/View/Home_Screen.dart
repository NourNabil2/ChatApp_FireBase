
import 'dart:convert';
import 'dart:developer';
import 'package:chats/Core/Network/API.dart';
import 'package:chats/Core/widgets/Card_User.dart';
import 'package:chats/Features/Profile_Screen/View/Profile_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../../Core/Utils/constants.dart';
import '../Data/Users.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String id = 'HomeScreen';


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ChatUser> searchList = [];  // TODO
  List<ChatUser> UserList = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);

        });
  }

  @override
  Widget build(BuildContext context) {



    // HomeCubit Cubit = BlocProvider.of<HomeCubit>(context);
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          //if search is on & back button is pressed then close search
          //or else simple close current screen on back button click

            onWillPop: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
              return  Future.value(false);
              } else {
                return Future.value(true);
              }
            },
    child:  Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: APIs.me),));

            },
                icon: Icon(Icons.person, color: Colors.black,)),
          ],

          leading: IconButton(onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });

          }, icon: Icon( _isSearching? CupertinoIcons.clear_circled_solid : Icons.search_rounded  , color: Colors.black,)),
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title:_isSearching
              ? TextField(
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Name, Email, ...'),
            autofocus: true,
            style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
            //when search text changes then updated search list
            onChanged: (val) {
              //search logic
               searchList.clear();
                for (var i in UserList) {
                  if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                      i.email.toLowerCase().contains(val.toLowerCase())) {
                    searchList.add(i);
                    log("Data2: ${jsonEncode(i)}");
                 setState(() {
                   searchList;
                 });
                  }
                }


            },
          ) // todo :: make widget
              : const Text('We Chat'),
          centerTitle: true,
        ),


        body: StreamBuilder(
            stream: APIs.getMyUsersId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

              //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: APIs.firestore.collection('Users').where('id', isNotEqualTo: APIs.user.uid).snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                        //if data is loading
                          case ConnectionState.waiting:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.none:
                            return const Center(child: Text('No Network'));

                        //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:

                            final data = snapshot.data?.docs;
                            for (var i in data!) {
                                 UserList = data.map((e) => ChatUser.fromJson(e.data())).toList() ?? [] ;

                              log("Data1: ${jsonEncode(i.data())}");
                            }
                            if (UserList.isNotEmpty)
                            {
                              return ListView.builder(
                                  itemCount: _isSearching
                                      ? searchList.length
                                      : UserList.length,
                                  itemBuilder: (context, index) => ChatUserCardState(user: _isSearching
                                      ? searchList[index]
                                      : UserList[index]) );
                            }
                            else
                            {
                              return const Text('No connection Found'); // ToDO:: Handel this
                            }
                        }});}}))));}}




