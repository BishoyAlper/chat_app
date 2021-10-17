import 'package:chatapp/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }

        final docs = snapshot.data.docs;
        final user = FirebaseAuth.instance.currentUser;

        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, index) => MessagesBubble(
              docs[index]['text'],
              docs[index]['username'],
              docs[index]['userImage'],
              docs[index]['userId'] == user.uid,
              key: ValueKey(docs[index].id),
          ),
        );
      },
    );
  }

}