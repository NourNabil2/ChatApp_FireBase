import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/Core/widgets/chat_buble.dart';
import 'package:chats/Features/Chat_Screen/Model_View/chat_cubit.dart';
import 'package:chats/Features/Home_Screen/Data/Users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Core/Network/API.dart';
import '../../../Core/Utils/constants.dart';
import '../../Profile_Screen/View/Profile_OtherUsers_Screen.dart';
import '../Data/message.dart';



class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';
  final _controller = ScrollController();
  final ChatUser user;
  TextEditingController controller = TextEditingController();
  List<Message> list = [];
  ChatPage({Key? key, required this.user}) : super(key: key);

  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    ChatCubit Cubit = BlocProvider.of<ChatCubit>(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
    child: SafeArea(
    child: WillPopScope(
    //if emojis are shown & back button is pressed then hide emojis
    //or else simple close current screen on back button click
    onWillPop: () {
    if (Cubit.showEmoji) {
      Cubit.show_Emoji();
    return Future.value(false);
    } else {
    return Future.value(true);
    }
    },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: appBar(context),

        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {

                },
                builder: (context, state) {
                  return ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: Cubit.messagesList.length,
                      itemBuilder: (context, index) {
                        return Cubit.messagesList[index].toId == user.email ? MessageCard(
                          message: Cubit.messagesList[index],
                        ) : MessageCard(message: Cubit.messagesList[index]);
                      });
                },
              ),
            ),
            chatInput(context),
          ],
        ),
      ),
    )));


  }
  Widget appBar(context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Porfile_Other_Users(user: user)));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  //back button
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                      const Icon(Icons.arrow_back, color: Colors.black54)),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: 40,
                      height:40, //todo
                      imageUrl:
                      list.isNotEmpty ? list[0].image : user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(width: 10),

                  //user name & last seen time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //user name
                      Text(list.isNotEmpty ? list[0].name : user.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),

                      //for adding some space
                      const SizedBox(height: 2),

                      //last seen time of user
                      // Text(
                      //     list.isNotEmpty
                      //         ? list[0].isOnline
                      //         ? 'Online'
                      //         : MyDateUtil.getLastActiveTime(
                      //         context: context,
                      //         lastActive: list[0].lastActive)
                      //         : MyDateUtil.getLastActiveTime(
                      //         context: context,
                      //         lastActive: widget.user.lastActive),
                      //     style: const TextStyle(
                      //         fontSize: 13, color: Colors.black54)),
                    ],
                  )
                ],
              );
            }));
  }
  Widget chatInput(context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 5, horizontal: 5),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        // FocusScope.of(context).unfocus();
                        // setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),

                  Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          // if (Cubit.showEmoji) setState(() => _showEmoji = !_showEmoji);
                        },
                        decoration: const InputDecoration(
                            hintText: 'Type Something...',
                            hintStyle: TextStyle(color: Colors.blueAccent),
                            border: InputBorder.none),
                      )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                         // setState(() => _isUploading = true);
                         // await APIs.sendChatImage(widget.user, File(i.path));
                          //setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                         // setState(() => _isUploading = true);

                          // await APIs.sendChatImage(
                          //     widget.user, File(image.path));
                          // setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),

                  //adding some space
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                if (list.isEmpty) {
                  // //on first message (add user to my_user collection of chat user)
                  // APIs.sendFirstMessage(
                  //     widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  // APIs.sendMessage(
                  //     widget.user, _textController.text, Type.text);
                }
                controller.text = '';
              }
            },
            minWidth: 0,
            padding:
            const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}




