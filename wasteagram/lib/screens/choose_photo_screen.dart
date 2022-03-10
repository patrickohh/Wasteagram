import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wasteagram/components/navigation.dart';


class ChoosePhoto extends StatefulWidget {
  const ChoosePhoto({ Key? key }) : super(key: key);

  @override
  State<ChoosePhoto> createState() => _ChoosePhotoState();
}

class _ChoosePhotoState extends State<ChoosePhoto> {

  final picker = ImagePicker();

  final date = DateTime.now();

  File? image;

  String? url;

  Future getAndUploadImage(bool isGallery) async{
    if(isGallery){
      final date = DateTime.now();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      image = File(pickedFile!.path);

      var fileName = date.toString() + '.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image!);
      await uploadTask;
      final retrievedImageURL = await storageReference.getDownloadURL();
      setState(() {
        url = retrievedImageURL;
      });
      pushAddPostScreen(context, url);
    }
    else{
      final date = DateTime.now();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      image = File(pickedFile!.path);

      var fileName = date.toString() + '.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image!);
      await uploadTask;
      final retrievedImageURL = await storageReference.getDownloadURL();
      setState(() {
        url = retrievedImageURL;
      });
      pushAddPostScreen(context, url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Photos'),
          centerTitle: true,),
        body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Semantics(
                      button: true,
                      enabled: true,
                      onTapHint: 'Tap to Select Photo from Gallery',
                      child: ElevatedButton(
                        onPressed: (){
                          getAndUploadImage(true);
                        }, 
                        child: const Text('Photo Gallery')
                      ),
                    ),
                    Semantics(
                      button: true,
                      enabled: true,
                      onTapHint: 'Tap to Take Photo With Camera',
                      child: ElevatedButton(
                        onPressed: (){
                          getAndUploadImage(false);
                        }, 
                        child: const Text('Camera')
                      ),
                    )
                  ],
                ),
            ),
      );
  }
}




