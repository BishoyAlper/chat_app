import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget{


  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages>{
  final _controller = TextEditingController();
  String _enterMessages = "";

  void sendMessages() async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enterMessages,
      'createdAt' : Timestamp.now(),
      'username' : userData['username'],
      'userImage' : userData['image_url'],
      'userId' : user.uid,
    });
    _controller.clear();

    setState(() {
      _enterMessages = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Theme.of(context).primaryColor,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  hintText: "Send Messages...",
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onChanged: (val){
                setState(() {
                  _enterMessages = val;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.white,
              icon: Icon(Icons.send),
              onPressed: _enterMessages.trim().isEmpty ? null : sendMessages,
          ),
        ],
      ),
    );
  }
}