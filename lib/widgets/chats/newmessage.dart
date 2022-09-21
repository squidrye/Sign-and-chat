import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class NewMessage extends StatefulWidget {
  NewMessageState createState() {
    return NewMessageState();
  }
}

class NewMessageState extends State<NewMessage> {
  var _enteredValue="";
  final _controller=new TextEditingController();
  void _sendMessage() async{
  final username=await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    FocusScope.of(context).unfocus();
    _controller.clear();
    FirebaseFirestore.instance.collection('chat').add({
      'text':_enteredValue,
      'time': Timestamp.now(),
      'uid':FirebaseAuth.instance.currentUser!.uid,
      'username':username['username'],
      'imageUrl':username['imageUrl'],
    });
  }
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Enter message..."),
              onChanged:(value){
                setState((){
                  _enteredValue=value;
                });
              }
            ),

          ),
          IconButton(
            icon:Icon(Icons.send),
            onPressed: _enteredValue.trim().isEmpty?null:_sendMessage,
          ),
        ],
      ),
    );
  }
}
