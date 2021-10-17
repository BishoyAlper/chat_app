import 'package:chatapp/widgets/chat/messages.dart';
import 'package:chatapp/widgets/chat/new_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: [
            DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.white),
                      SizedBox(width: 8),
                      Text("LogOut", style: TextStyle(color: Colors.white))
                    ],
                  ),
                  value: 'logOut',
                ),
              ],
              onChanged: (itemIdentifer) {
                if (itemIdentifer == 'logOut') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Messages()
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }

}