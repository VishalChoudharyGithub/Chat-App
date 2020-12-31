import 'dart:async';

import 'package:flash_chat/Components/MessageBubble.dart';
import 'package:flash_chat/Services/Encryption.dart';
import 'package:flash_chat/Services/Prefs.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StreamSocket {
  Encryption encryption = Encryption();
  Prefs _prefs = Prefs();
  final _controller = StreamController<Map<String, dynamic>>();

  void addToStream(List<dynamic> messageList, BuildContext context) async {
    String me = await _prefs.getLoggedInEmail();

    if (messageList.length < 1) {
      print("No message");
    }
    for (var i = messageList.length - 1; i >= 0; i--) {
      var currentMessage = messageList[i];
      final messageBubble = MessageBubble(
        sender: currentMessage['sender'],
        text: encryption.decrypt(currentMessage['message']),
        isMe: me == currentMessage['sender'],
      );
      messageBubbles.add(messageBubble);
      _controller.sink.add(currentMessage);
    }
  }

  void addToPreviousStream(List<dynamic> messageList) async {
    String me = await _prefs.getLoggedInEmail();

    for (var currentMessage in messageList) {
      final messageBubble = MessageBubble(
        sender: currentMessage['sender'],
        text: encryption.decrypt(currentMessage['message']),
        isMe: me == currentMessage['sender'],
      );
      messageBubbles.insert(0, messageBubble);
      _controller.sink.add(currentMessage);
    }
  }

  void addSingleitem(Map<String, dynamic> data) async {
    String me = await _prefs.getLoggedInEmail();
    final messageBubble = MessageBubble(
      sender: data['sender'],
      text: encryption.decrypt(data['message']),
      isMe: me == data['sender'],
    );
    messageBubbles.add(messageBubble);
    _controller.sink.add(data);
  }

  Stream<Map<String, dynamic>> get getStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
