import 'package:app_chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //get instance of firebase & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //get user stream
  /*
  List<Map<String, dynamic>>
  [
    {
      'email': test@gmail.com,
      'id':...
    }
    {
      'email': test@gmail.com,
      'id':...
    }
    {
      'email': test@gmail.com,
      'id':...
    }
  ]
   */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currenUserID = _auth.currentUser!.uid;
    final String currenUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //creat a new message
    Message newMessage = Message(
        senderEmail: currenUserEmail,
        senderID: currenUserID,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);
    //contruct chat room ID for the two users(sorted to ensure uniquenes)
    List<String> ids = [currenUserID, receiverID];
    ids.sort(); //sort the ids (this ensure the chatroomId is the same for 2 any people)
    String chatRoomID = ids.join('_');
    //add new message to database
    _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //contruct a chatroom ID for two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
