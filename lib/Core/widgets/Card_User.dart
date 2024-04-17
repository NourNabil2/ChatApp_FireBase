

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/Core/Network/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../../Features/Chat_Screen/Data/message.dart';
import '../../Features/Chat_Screen/View/chat_page.dart';
import '../../Features/Home_Screen/Data/Users.dart';
import '../Functions/Time_Format.dart';
import 'Profile_Dialog_Pic.dart';


class ChatUserCardState extends StatefulWidget {
  final ChatUser user;

  const ChatUserCardState({super.key, required this.user});
  @override
  State<ChatUserCardState> createState() => _ChatUserCardStateState();
}

class _ChatUserCardStateState extends State<ChatUserCardState> {
  Message? _message;
  Message? _message_NotRead;
  @override

  Widget build (BuildContext context) {


    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),// TODO ::
      // color: Colors.blue.shade100,
      elevation: 0.5,// TODO ::
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatPage(user: widget.user)));
        },
    child: StreamBuilder(
      stream: APIs.getLastMessage(widget.user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

         final notread =
            data?.map((e) => Message.fromJson(e.data())).where((element) => element.read.isEmpty).toList() ?? [];

        if (list.isNotEmpty) _message = list[0];

      return ListTile(
//user profile picture
        leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => ProfileDialog(user: widget.user));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    width: 50 ,
                    height: 50 ,  // TODO::
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
              Container(
                width: 10,
                height: 10, // TODO ::
                decoration: BoxDecoration(
                    color: widget.user.isOnline ? Colors.green.shade400 : Colors.grey.shade400, // TODO::
                    borderRadius: BorderRadius.circular(10)),
              ),

            ]
        ),

//user name
        title: Text(widget.user.name),
//last message
        subtitle: Text(
            _message != null
                ? _message!.type == Type.image
                ? 'image'
                : _message!.msg
                : widget.user.about,
            maxLines: 1,overflow:TextOverflow.ellipsis,),
//last message time
        //last message time
        trailing: _message == null
            ? null //show nothing when no message is sent
            : _message!.read.isEmpty &&
            _message!.fromId != APIs.user.uid
            ?
        //show for unread message
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('${notread.length}')),
        )
            :
        //message sent time
        Text(
          Format_Time.getLastMessageTime(
              context: context, time: _message!.sent),
          style: const TextStyle(color: Colors.black54),
        ),

      );
    },)
    ),
    );
  }
}






