import 'package:app_chat/components/my_drawer.dart';
import 'package:app_chat/components/user_title.dart';
import 'package:app_chat/pages/chat_page.dart';
import 'package:app_chat/services/auth/auth_service.dart';
import 'package:app_chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        //return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTitle(
        onTap: () {
          //tapped on a user --> go to chat page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
        text: userData['email'],
      );
    } else {
      return Container();
    }
  }
}
