import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/Core/widgets/chat_buble.dart';
import 'package:chats/Features/Chat_Screen/Model_View/chat_cubit.dart';
import 'package:chats/Features/Home_Screen/Data/Users.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Core/Functions/Time_Format.dart';
import '../../../Core/Network/API.dart';
import '../../../Core/Utils/constants.dart';
import '../../Profile_Screen/View/Profile_OtherUsers_Screen.dart';
import '../Data/message.dart';



class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';
  final ChatUser user;

  ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = ScrollController();

  bool showEmoji = false;

  List<Message> messagesList = [];

  TextEditingController controller = TextEditingController();



  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
   // ChatCubit Cubit = BlocProvider.of<ChatCubit>(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
    child: SafeArea(
    child: WillPopScope(
    //if emojis are shown & back button is pressed then hide emojis
    //or else simple close current screen on back button click
    onWillPop: () {
    if (showEmoji) {
      showEmoji = !showEmoji;
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
              child:StreamBuilder(
        stream: APIs.getAllMessages(widget.user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
          //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const SizedBox();

          //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              messagesList = data
                  ?.map((e) => Message.fromJson(e.data()))
                  .toList() ??
                  [];

              if (messagesList.isNotEmpty) {
                return ListView.builder(
                    reverse: true,
                    itemCount: messagesList.length,
                    padding: EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return MessageCard(message: messagesList[index]);
                    });
              } else {
                return const Center(
                  child: Text('Say Hii! 👋',
                      style: TextStyle(fontSize: 20)),
                );
              }
          }
        },
      ),
    ),

            //progress indicator for showing uploading
            if (_isUploading)
              const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2))),
            chatInput(context),
            if (showEmoji)
              SizedBox(
                height: 300,
                child: EmojiPicker(
                  textEditingController: controller,
                  config: Config(
                  columns: 8,emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0) ,

                  ),
                ),
              )
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
                  builder: (_) => Porfile_Other_Users(user: widget.user)));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
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
                      list.isNotEmpty ? list[0].image : widget.user.image,
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
                      Text(list.isNotEmpty ? list[0].name : widget.user.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),

                      //for adding some space
                      const SizedBox(height: 2),

                     // last seen time of user
                      Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                              ? 'Online'
                              : Format_Time.getLastActiveTime(
                              context: context,
                              lastActive: list[0].lastActive)
                              : Format_Time.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
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
                         FocusScope.of(context).unfocus();
                         setState(() => showEmoji = !showEmoji);
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
                         setState(() => _isUploading = true);
                         await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
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
                         setState(() => _isUploading = true);
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
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

                if (messagesList.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, controller.text, Type.text);
                } else {
                //  simply send message
                  APIs.sendMessage(
                      widget.user, controller.text, Type.text);
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



// BlocConsumer<ChatCubit, ChatState>(
// listener: (context, state) {
//
// },
// builder: (context, state) {
// return ListView.builder(
// reverse: true, // todo
// controller: _controller,
// itemCount: messagesList.length,
// itemBuilder: (context, index) {
// return messagesList[index].toId == widget.user.email ? MessageCard(
// message: messagesList[index],
// ) : MessageCard(message: messagesList[index]);
// });
// },
// ),
