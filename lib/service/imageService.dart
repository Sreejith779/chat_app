import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ImageService{
final FirebaseStorage storage = FirebaseStorage.instance;
var uuid = Uuid();

  Future<String>uploadImage({required String imagePath})async{
    File file = File(imagePath);
    var v4 = uuid.v4();
    try{
   final ref = storage.ref().child("chat_images/$v4.jpg");
   await ref.putFile(file);
   final imageUrl = await ref.getDownloadURL();
   return imageUrl;

    }
        catch(e){
      print(e.toString());
       throw e;
        }


  }

}