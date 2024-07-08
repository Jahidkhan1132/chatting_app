import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/auth/chat_service.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_title.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('StreamBuilder Error: ${snapshot.error}');
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('StreamBuilder: Waiting for data...');
          return const Text('Loading');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('StreamBuilder: No users found');
          return const Text('No users found');
        }
        print('StreamBuilder: Data received');
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    print('Building user list item for: ${userData["email"]}');
    if (userData["email"] != _authService.getCurrentUser()?.email) {
      return FutureBuilder<bool>(
        future: _chatService.hasUnreadMessages(userData['uid']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              title: Text(userData["email"]),
              leading: const CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return ListTile(
              title: Text(userData["email"]),
              leading: const Icon(Icons.error),
            );
          }

          bool hasUnreadMessages = snapshot.data ?? false;
          return UserTitle(
            text: userData["email"],
            onTop: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverEmail: userData["email"],
                    receiverId: userData['uid'],
                  ),
                ),
              );
            },
            hasUnreadMessages: hasUnreadMessages,
          );
        },
      );
    } else {
      return Container();
    }
  }
}
