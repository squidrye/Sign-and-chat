import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String pass, String username, bool isLogin,
      BuildContext ctx,File? image) submitData;
  final bool isLoading;
  AuthForm(this.submitData, this.isLoading);
  @override
  State<StatefulWidget> createState() {
    return AuthFormState();
  }
}

class AuthFormState extends State<AuthForm> {
  @override
  final ImagePicker imagePicker = new ImagePicker();
  XFile? image;
  var _formKey = GlobalKey<FormState>();
  var isLogin = false;
  var username = "";
  var email = "";
  var pass = "";
  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (image == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Please Pick an image', style: TextStyle(color: Colors.red)),
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      File? imgFile;
      if(image!=null)
       imgFile=File(image!.path);
      widget.submitData(
          email.trim(), pass.trim(), username.trim(), isLogin, context,imgFile);
    }
  }

  Widget build(BuildContext ctx) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        color: Color(0xffFCF7FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 26),
                        child: isLogin
                            ? Text("Login",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 26))
                            : Text("Sign Up",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 26))),
                    if (!isLogin)
                      GestureDetector(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                backgroundImage: image != null
                                    ? FileImage(File(image!.path))
                                    : null,
                                radius: 45,
                              ),
                              Icon(Icons.add_a_photo)
                            ],
                          ),
                          onTap: () async {
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 50,
                                maxWidth:150,
                                );
                            setState(() {
                              image = file;
                            });
                          }),
                    if (!isLogin)
                      TextFormField(
                          key: Key("username"),
                          decoration: InputDecoration(
                              labelText: "Username",
                              prefixIcon: Icon(Icons.people),
                              contentPadding: EdgeInsets.only(bottom: 20)),
                          validator: (String? value) {
                            if (value!.isEmpty || value.length < 4) {
                              return "Enter at least 4 characters";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            username = value!;
                          }),
                    TextFormField(
                        key: Key("email"),
                        decoration: InputDecoration(
                            labelText: "Email ID",
                            prefixIcon: Icon(Icons.mail)),
                        validator: (String? value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Enter a valid email id";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        }),
                    TextFormField(
                        key: Key("pass"),
                        decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Enter a password with length greater than 7";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          pass = value!;
                        }),
                    SizedBox(
                      height: 22,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: isLogin ? Text("Login") : Text("Sign Up"),
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        child: isLogin ? Text("Sign Up") : Text("Login"),
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                      )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
