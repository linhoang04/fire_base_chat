import 'package:app_chat/components/my_text_field.dart';
import 'package:app_chat/services/auth/auth_service.dart';
import 'package:app_chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //send message
  void sendMessage() async {
    //if there is something inside the textfiled
    if (_messageController.text.isNotEmpty) {
      //sendMessage
      await _chatService.sendMessage(receiverID, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(
            child: _buildMessageList(),
          ),
          //user input
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: _buildUserInput(),
          ),
        ],
      ),
    );
  }

//build mess list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        //return list view
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build mess item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Text(data["message"]);
  }

  //build mess input
  Widget _buildUserInput() {
    return Row(
      children: [
        //textFiled should take up most of the space
        Expanded(
          child: MyTextField(
              hintext: 'Type a message',
              obscureText: false,
              controller: _messageController),
        ),
        //send button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
