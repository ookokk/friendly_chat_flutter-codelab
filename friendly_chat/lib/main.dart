// ignore_for_file: prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: defaultTargetPlatform == TargetPlatform.iOS //new
          ? kIOSTheme //new
          : kDefaultTheme,
      title: "Friendlychat",
      home: ChatScreen(),
    );
  }
}

// Modify the ChatScreen class definition to extend StatefulWidget.

class ChatScreen extends StatefulWidget {
  //modified
  @override //new
  State createState() => ChatScreenState(); //new
}

// Add the ChatScreenState class definition in main.dart.

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[]; // new
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      //new
      _isComposing = false; //new
    }); //new
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  //new
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  //new
                  setState(() {
                    //new
                    _isComposing = text.length > 0; //new
                  }); //new
                }, //new
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? //modified
                    CupertinoButton(
                        //new
                        child: const Text("Send"), //new
                        onPressed: _isComposing //new
                            ? () => _handleSubmitted(_textController.text) //new
                            : null,
                      )
                    : //new
                    IconButton(
                        //modified
                        icon: const Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ],
        ),
      ),
    );
  }

  @override //new
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Friendlychat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      body: Container(
          //modified
          child: Column(
            //modified
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              const Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS //new
              ? const BoxDecoration(
                  //new
                  border: Border(
                    //new
                    top: BorderSide(color: Colors.grey), //new
                  ), //new
                ) //new
              : null), //modified
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.animationController});

  final String text;
  final String _name = "ookokk";
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        //new
        sizeFactor: CurvedAnimation(
            //new
            parent: animationController,
            curve: Curves.easeOut), //new
        axisAlignment: 0.0, //new
        child: Container(
          //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Text(_name[0])),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_name, style: Theme.of(context).textTheme.bodyMedium),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) //new
        );
  }
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
);

final ThemeData kDefaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
      .copyWith(secondary: Colors.orangeAccent[400]),
);
