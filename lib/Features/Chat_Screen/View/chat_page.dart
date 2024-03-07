import 'package:chats/Core/widgets/chat_buble.dart';
import 'package:chats/Features/Chat_Screen/Model_View/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../Core/Utils/constants.dart';
import '../Data/message.dart';


class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';
  final _controller = ScrollController();


  TextEditingController controller = TextEditingController();

  ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatCubit Cubit = BlocProvider.of<ChatCubit>(context);
    var email = ModalRoute
        .of(context)
        ?.settings
        .arguments;

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
            Text('chat'),
          ],
        ),
        centerTitle: true,
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
                      return Cubit.messagesList[index].id == email ? ChatBuble(
                        message: Cubit.messagesList[index],
                      ) : ChatBubleForFriend(message: Cubit.messagesList[index]);
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              onSubmitted: (data) {
                print("email is : $email");
                Cubit.sendmessage(message: data, );
                controller.clear();
                _controller.animateTo(0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: Icon(
                  Icons.send,
                  color: kPrimaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
