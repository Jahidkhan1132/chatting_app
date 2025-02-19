import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/auth/chat_service.dart';
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

   const ChatPage({
    super.key,
    required this.receiverEmail,
     required this.receiverId
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController= TextEditingController();

  final ChatService _chatService= ChatService();
  final AuthService _authService= AuthService();

  FocusNode myFocusNode= FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        
        Future.delayed(Duration(milliseconds: 500),() => scrollDown,);
      }
    });

    Future.delayed(Duration(
      milliseconds: 500,)
      ,() => scrollDown(),);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }
  final ScrollController _scrollController= ScrollController();

  void scrollDown(){
     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
         duration: const Duration(seconds: 1),
         curve: Curves.fastOutSlowIn);
  }
  void sendMessage() async{

    if(_messageController.text.isNotEmpty){

      await _chatService.sendMessage(widget.receiverId, _messageController.text);

      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        centerTitle: true,
        backgroundColor:Colors.transparent ,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    String senderId= _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {

          if(snapshot.hasError){
            return const Text("Error");
          }
          if(snapshot.connectionState == ConnectionState.waiting){

            return const Text("Loading...");
          }
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        },);
  }

  Widget _buildMessageItem(DocumentSnapshot doc){

    Map<String,dynamic> data= doc.data() as Map<String,dynamic>;
    bool isCurrentUser= data['senderId'] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
          ],
        ));
  }

  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                controller: _messageController,
                hintText: "Type a message",
                obscureText: false,
                focusNode: myFocusNode,
              )),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle
            ),
            margin:const EdgeInsets.only(right: 12),
            child: IconButton(
                onPressed: sendMessage, icon: const Icon(Icons.send,color: Colors.white,)),
          )
        ],
      ),
    );
  }
}
