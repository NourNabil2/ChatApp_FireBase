import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chats/Core/Network/API.dart';
import 'package:chats/Core/widgets/Card_User.dart';
import 'package:chats/Core/widgets/component.dart';
import 'package:chats/Features/Profile_Screen/View/Profile_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Core/Functions/show_snack_bar.dart';
import '../../../Core/Utils/Colors.dart';
import '../../../Core/Utils/constants.dart';
import '../../../Core/widgets/Shimmer_Loading.dart';
import '../Data/Users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final List<ChatUser> searchList = []; // TODO
List<ChatUser> UserList = [];

bool _isSearching = false;

class _HomeScreenState extends State<HomeScreen> {
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
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
              //floating button to add new user
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FloatingActionButton(
                    onPressed: () {
                      addChatUserDialog(context);
                    },
                    child: const Icon(Icons.add_comment_rounded)),
              ),
              body: StreamBuilder(
                  stream: APIs.getMyUsersId(),

                  //get id of only known users
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                        return LoadingListPage();
                      case ConnectionState.none:
                        return LoadingListPage();

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return StreamBuilder(
                            stream: APIs.getAllUsers(
                                snapshot.data?.docs.map((e) => e.id).toList() ??
                                    []),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                //if data is loading
                                case ConnectionState.waiting:
                                  return LoadingListPage();
                                case ConnectionState.none:
                                  return const Center(
                                      child: Text('No Network'));

                                //if some or all data is loaded then show it
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  for (var i in data!) {
                                    UserList = data
                                            .map((e) =>
                                                ChatUser.fromJson(e.data()))
                                            .toList() ??
                                        [];

                                    log("Data1: ${jsonEncode(i.data())}");
                                  }
                                  if (UserList.isNotEmpty) {
                                    return CustomScrollView(
                                        physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics(),
                                        ),
                                        shrinkWrap: true,
                                        slivers: [
                                          SliverAppBar(
                                            backgroundColor:
                                                ColorApp.kPrimaryColor,
                                            expandedHeight: 200,
                                            pinned: true,
                                            stretch: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                              ),
                                            ),
                                            actions: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileScreen(
                                                                  user:
                                                                      APIs.me),
                                                        ));
                                                  },
                                                  icon: Icon(
                                                    Icons.person,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                            leading: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isSearching =
                                                        !_isSearching;
                                                  });
                                                },
                                                icon: Icon(
                                                  _isSearching
                                                      ? CupertinoIcons
                                                          .clear_circled_solid
                                                      : Icons.search_rounded,
                                                  color: Colors.black,
                                                )),
                                            title: _isSearching
                                                ? TextField(
                                                    decoration:
                                                        const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Name, Email, ...'),
                                                    autofocus: true,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        letterSpacing: 0.5),
                                                    //when search text changes then updated search list
                                                    onChanged: (val) {
                                                      //search logic
                                                      searchList.clear();
                                                      for (var i in UserList) {
                                                        if (i.name
                                                                .toLowerCase()
                                                                .contains(val
                                                                    .toLowerCase()) ||
                                                            i.email
                                                                .toLowerCase()
                                                                .contains(val
                                                                    .toLowerCase())) {
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
                                            flexibleSpace: FlexibleSpaceBar(
                                              centerTitle: true,
                                              stretchModes: const [
                                                StretchMode.blurBackground
                                              ],
                                              background: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child:
                                                                  Image.network(
                                                                height: 70,
                                                                width: 70,
                                                                fit: BoxFit
                                                                    .cover,
                                                                APIs.me.image,
                                                                errorBuilder: (context,
                                                                        url,
                                                                        error) =>
                                                                    const CircleAvatar(
                                                                        radius:
                                                                            35,
                                                                        child: Icon(
                                                                            CupertinoIcons.person)),
                                                              ),
                                                            ),
                                                            Text(
                                                              'You',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall,
                                                            )
                                                          ],
                                                        ),
                                                        Positioned(
                                                          bottom: 10,
                                                          child: const Icon(
                                                            CupertinoIcons
                                                                .add_circled_solid,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          UserList.length,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child:
                                                                  CachedNetworkImage(
                                                                height: 70,
                                                                width: 70,
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl:
                                                                    UserList[
                                                                            index]
                                                                        .image,
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const CircleAvatar(
                                                                        radius:
                                                                            35,
                                                                        child: Icon(
                                                                            CupertinoIcons.person)),
                                                              ),
                                                            ),
                                                            Container(
                                                                width: 60,
                                                                child: Text(
                                                                  UserList[
                                                                          index]
                                                                      .name,
                                                                  softWrap:
                                                                      false,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleSmall,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SliverToBoxAdapter(
                                              child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                top: 25,
                                                bottom: 10.0),
                                            child: Text(
                                              'Chats',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                          BuildHomeScreen(),
                                        ]);
                                  } else {
                                    return const Text(
                                        'No connection Found'); // ToDO:: Handel this
                                  }
                              }
                            });
                    }
                  }),
            )));
  }
}

Widget BuildHomeScreen() {
  return SliverGrid(
      delegate: SliverChildListDelegate(List.generate(
          _isSearching ? searchList.length : UserList.length,
          (index) => ChatUserCardState(
              user: _isSearching ? searchList[index] : UserList[index]))),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
        childAspectRatio: 5,
      ));
}
