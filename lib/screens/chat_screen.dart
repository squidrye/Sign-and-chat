import 'package:chatapp/widgets/chats/newmessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chats/messages.dart';
class ChatScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FlutterChat"), actions: [
        DropdownButton(
          icon: Icon(Icons.more_vert),
          items: [
            DropdownMenuItem(
              value:'logout',
                child: Container(
                    child: Row(children: [
              Icon(Icons.exit_to_app),
              Text("logout"),
            ]))),
          ],
       
          onChanged:(itemIdentifier){
            if(itemIdentifier=='logout'){
              FirebaseAuth.instance.signOut();
            }
          }
        ),
      ]),
      body: Container(
        child:Column(
          children:[
            Expanded(
              child:Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
     
    );
  }
}
