import 'dart:io';

import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class AuthScreen extends StatefulWidget{
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  final _auth =  FirebaseAuth.instance;
  UserCredential authResult;
  bool _isLoading = false;

  _submitAuthForm(String email, String username, String password, bool isLogin, File image, BuildContext ctx) async{
    try {
      setState(() {
        _isLoading = true;
      });

      if(isLogin){
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

        final ref = FirebaseStorage.instance.ref().child('user_image').child(authResult.user.uid+".jpg");
        await ref.putFile(image);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'password' : password,
          'image_url' : url
        });
      }

    } on FirebaseAuthException catch (e) {
      String message = "error Occurred";

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(message) , backgroundColor: Theme.of(ctx).errorColor));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}