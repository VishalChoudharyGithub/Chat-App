import 'dart:convert';

import 'package:flash_chat/Components/MessageBubble.dart';
import 'package:flash_chat/Services/Encryption.dart';
import 'package:flash_chat/Services/Networking.dart';
import 'package:flash_chat/Services/Prefs.dart';
import 'package:flash_chat/Services/SocketService.dart';
import 'package:flash_chat/Services/StreamSocket.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

String _loggedInUser, _loggedEmail;
StreamSocket streamSocket;
List<MessageBubble> messageBubbles;

class ChatScreen extends StatefulWidget {
  static const String id = "chatScreen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  NetworkHelper networkHelper;
  SocketService socketService;
  Encryption encryption;
  Prefs _prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageBubbles = [];

    _prefs = Prefs();
    streamSocket = StreamSocket();
    networkHelper = NetworkHelper();
    encryption = Encryption();
    socketService = SocketService(streamSocket);

    getCurrentUser();
//    handleSocket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socketService.disposeSocket();
    super.dispose();
  }

  void getCurrentUser() async {
    _loggedInUser = await _prefs.getLoggedInUser();
    _loggedEmail = await _prefs.getLoggedInEmail();

    if (_loggedInUser == null || _loggedEmail == null) {
      await _prefs.clear();
      Navigator.popAndPushNamed(context, LoginScreen.id);
    }
    loadMessages();
  }

  void loadMessages() async {
    http.Response response = await networkHelper.getMessages();
    List<dynamic> messagesList = jsonDecode(response.body);

    streamSocket.addToStream(messagesList, context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderData>(
      create: (context) => ProviderData(),
      child: Scaffold(
        appBar: AppBar(
          primary: true,
          shape: RoundedRectangleBorder(),
          centerTitle: true,
          elevation: 8,
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  bool isCleared = await _prefs.clear();
                  if (isCleared) {
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                  }
                }),
          ],
          title: Text('Chat'),
          backgroundColor: Color(0xff0C161E),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(
                networkHelper: networkHelper,
                token: _loggedInUser,
              ),
              Container(
                decoration: kMessageContainerDecoration.copyWith(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        String message = messageTextController.text.trim();
                        if (message.length > 0) {
                          messageTextController.clear();
                          socketService.getsocket().emit(
                              "message_sent",
                              jsonEncode({
                                "message": encryption.encrypt(message),
                                "token": _loggedInUser
                              }));
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatefulWidget {
  final NetworkHelper networkHelper;
  final String token;

  MessagesStream({this.networkHelper, this.token});

  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  ScrollController _scrollController;
  bool showLoader = false;
  NetworkHelper networkHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    networkHelper = widget.networkHelper;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          showLoader = true;
        });
        loadMoreMessages();
      }
    });
  }

  void loadMoreMessages() async {
    http.Response response = await networkHelper.getMessages();
    if (response.statusCode == 200) {
      List<dynamic> messagesList = jsonDecode(response.body);
      streamSocket.addToPreviousStream(messagesList);
      setState(() {
        showLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: streamSocket.getStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
          );
        }
        return Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: messageBubbles.length + 1,
            cacheExtent: 100.0,
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemBuilder: (context, index) {
              if (index == messageBubbles.length) {
                return showLoader
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      )
                    : SizedBox();
              }
              return messageBubbles[(messageBubbles.length - 1) - index];
            },
          ),
        );
      },
    );
  }
}

class ProviderData extends ChangeNotifier {
  bool showLoader = true;
  void hideLoader() {
    showLoader = false;
    notifyListeners();
  }
}
