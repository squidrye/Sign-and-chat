import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/authentication/AuthForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthFormFirebase(String email, String password, String username,
      bool isLogin, BuildContext ctx, File? image) async {
    //submit data to firebase to create new users or sign in existing ones
    print(email);
    print(password);
    print(username);
    print(isLogin);
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        setState(() {
          _isLoading = false;
        });
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref=FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');

            await ref.putFile(image!).whenComplete((){});

           final url= await ref.getDownloadURL();


        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl':url,
        });
        //identifier of document then accessing setData to add additional data to doc having same id as that of authresult
        //extra data stored in a document is in form of a map
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = "An error ocurred, please check your credentials";

      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff296073),
                Color(0xff0089BA),
                Color(0xffFBEAFF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        AuthForm(_submitAuthFormFirebase, _isLoading),
      ]),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
