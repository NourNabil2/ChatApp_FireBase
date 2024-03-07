
import 'dart:convert';
import 'dart:developer';
import 'package:chats/Core/Network/API.dart';
import 'package:chats/Core/widgets/Card_User.dart';
import 'package:chats/Features/Profile_Screen/View/Profile_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    }
  @override
  Widget build(BuildContext context) {
    List<ChatUser> UserList = [];
   // HomeCubit Cubit = BlocProvider.of<HomeCubit>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [

          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: APIs.me),));
          },
              icon: Icon(Icons.person, color: Colors.black,)),


          IconButton(onPressed: () {},
              icon: Icon(Icons.search_rounded, color: Colors.black,)),


        ],
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
    stream: APIs.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? []),
    builder: (context, snapshot) {
    switch (snapshot.connectionState) {
    //if data is loading
    case ConnectionState.waiting:
    case ConnectionState.none:
    return const Center(child: CircularProgressIndicator());

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
    itemCount: UserList.length,
    itemBuilder: (context, index) => ChatUserCardState(user: UserList[index]) );
    }
    else
    {
    return const Text('No connection Found'); // ToDO:: Handel this
    }
    }});}}));}}




