import 'package:bloc/bloc.dart';
import 'package:chats/Core/Utils/constants.dart';
import 'package:chats/Features/Chat_Screen/Data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  void sendmessage({required String message,}) {
    try{
      messages.add({kMessage: message, kCreatedAt: DateTime.now()});
      print('messagesList.toString()');
    } on Exception catch(e)
    {

    }

  }

  void getmessage()
  {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      List<Message> messagesList = [];
      for (var doc in event.docs)
        {

          messagesList.add(Message.fromJson(doc));
          print(messagesList.toString());
          print('messagesList.toString()');

          emit(ChatSuccess(messages: messagesList));
        }
        emit(ChatSuccess(messages: messagesList));
    });


  }
}
