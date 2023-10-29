import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  bool isMe;
  String userName;
  Key key;
  String imageUrl;
  MessageBubble(this.message, this.isMe, this.userName, this.imageUrl,
      {required this.key});
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: isMe ? Colors.green : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft:
                          isMe ? Radius.circular(0) : Radius.circular(15),
                      bottomRight: isMe ? Radius.circular(15) : Radius.zero,
                    )),
                width: 140,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Text(userName,
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .headline1!
                                .color,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        message,
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .headline1!
                              .color,
                        ),
                      ),
                    ],),
              ),
            ],),
        Positioned(
            top: -8,
            left: isMe ? null : 120,
            right: isMe ? 122 : null,
            child: CircleAvatar(backgroundImage: NetworkImage(imageUrl))),
      ],
      clipBehavior: Clip.none,
    );
  }
}
