import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<FirebaseApp> _awaitConnection = Firebase.initializeApp();
    return MaterialApp(
      home: FutureBuilder(
        future: _awaitConnection,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              content: Text("Something went wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Chat',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: TextTheme(bodyText2: TextStyle(color:Colors.white) )
              ),
              home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder:(context,userSnap){
                if(userSnap.hasData){
                  return ChatScreen();
                }
                return AuthScreen();
              } ,),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
