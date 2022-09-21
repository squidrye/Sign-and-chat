import 'package:chatapp/widgets/chats/messagebubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
 User ?user=FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return MessageBubble(
                chatSnapshots.data!.docs[index]['text'],
                chatSnapshots.data!.docs[index]['uid']==user!.uid,
                chatSnapshots.data!.docs[index]['username'],
                chatSnapshots.data!.docs[index]['imageUrl'],
                key:ValueKey(chatSnapshots.data!.docs[index].id)
              ) ;
            },
            reverse: true,
            itemCount: chatSnapshots.data!.docs.length,
          );
        });
  }
}
