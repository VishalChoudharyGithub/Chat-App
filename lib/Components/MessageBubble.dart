import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});
  final String sender, text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                isMe ? EdgeInsets.only(right: 5) : EdgeInsets.only(left: 5),
            child: isMe
                ? null
                : Text(
                    sender,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 10,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Container(
              decoration: isMe
                  ? KButtonDecoration
                  : BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xff0C161E),
                    ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "$text",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
