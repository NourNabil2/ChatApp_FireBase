import 'package:bloc/bloc.dart';
import 'package:chats/Core/Network/API.dart';
import 'package:chats/Core/Utils/constants.dart';
import 'package:chats/Features/Chat_Screen/Data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messagesList = [];
  CollectionReference messages =
      APIs.firestore.collection(kMessagesCollections);

  void sendmessage({
    required String message,
  }) {
    try {
      messages.add({kMessage: message, kCreatedAt: DateTime.now()});
    } on Exception catch (e) {}
  }

  void getmessage() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess());
    });
  }
}
