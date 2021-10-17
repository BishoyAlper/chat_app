import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget{
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final ImagePicker _Picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    final pickedImageFile = await _Picker.getImage(source: src, imageQuality: 50, maxWidth: 150);

    if(pickedImageFile != null){
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickFn(_pickedImage);
    } else {
      print("No Image Selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton.icon(
                textColor: Theme.of(context).primaryColor,
                onPressed: ()=> _pickImage(ImageSource.camera),
                icon: Icon(Icons.camera_alt_outlined),
                label: Text("Add Image \n from camera", textAlign: TextAlign.center),
            ),
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              onPressed: ()=> _pickImage(ImageSource.gallery),
              icon: Icon(Icons.image_outlined),
              label: Text("Add Image \n from gallery", textAlign: TextAlign.center),
            ),
          ],
        )
      ],
    );
  }
}