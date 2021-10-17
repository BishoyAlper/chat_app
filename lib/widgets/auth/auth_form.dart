import 'dart:io';

import 'package:chatapp/pickers/user_image_pickers.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget{
  final void Function(String email, String username, String password, bool isLogin, File image, BuildContext ctx) submitAuthForm;
  final bool isLoading;

  AuthForm(this.submitAuthForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>{
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _Password = "";
  String _username = "";
  File _userImageFile;

  void _pickedImage(File _pickedImage){
    _userImageFile = _pickedImage;
  }

  void _submit(){
    final isValid = _formKey.currentState.validate();
    // dah 3shan y3'lek el keyboard
    FocusScope.of(context).unfocus();

    if(!_isLogin && _userImageFile == null){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("please pick image") , backgroundColor: Theme.of(context).errorColor));
      return;
    }

    if(isValid){
      _formKey.currentState.save();
      widget.submitAuthForm(_email.trim(), _username.trim(), _Password.trim(), _isLogin, _userImageFile, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                //arage3 dah
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey('email'),
                    validator: (val){
                      if(val.isEmpty || !val.contains("@")){
                        return "please ener email address";
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  if(!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      key: ValueKey('username'),
                      validator: (val){
                        if(val.isEmpty || val.length < 4){
                          return "please ener email UserName";
                        }
                        return null;
                      },
                      onSaved: (val) => _username = val,
                      decoration: InputDecoration(labelText: "UserNaame"),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (val){
                      if(val.isEmpty || val.length < 7){
                        return "please ener password";
                      }
                      return null;
                    },
                    onSaved: (val) => _Password = val,
                    decoration: InputDecoration(labelText: "password"),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  if(widget.isLoading)
                    CircularProgressIndicator(),
                  if(!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'LogIn' : 'SignUp'),
                      onPressed: _submit,
                    ),
                  if(!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                          _isLogin ? "Create new account" : "I already have an account"
                      ),
                      onPressed: (){
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          )
      ),
    );
  }
}