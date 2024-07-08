import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  final FirebaseAuth _auth= FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
      print('Firestore snapshot received');

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
  Future<void> sendMessage(String receiverId,message)async{

    final String currentUserId= _auth.currentUser!.uid;
    final String currentUserEmail= _auth.currentUser!.email!;
    final Timestamp timestamp= Timestamp.now();

    Message newMessage= Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
    );

    List<String> ids= [currentUserId,receiverId];
    ids.sort();
    String chatRoomID= ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

  }

  Stream<QuerySnapshot> getMessages(String userId,otherUserId){

    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatRoomID = ids.join('_');
    
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",descending: false)
        .snapshots();
  }

  Future<bool> hasUnreadMessages(String userId) async {
    // Implement the logic to check if the user has unread messages.
    // This is a placeholder for your actual implementation.
    // For example, query your database to check for unread messages.
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return userId == 'user1'; // Example: only 'user1' has unread messages
  }
}
