import 'dart:io';
import 'package:cleaner_together/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';

class MakePost extends StatefulWidget {
  @override
  MakePostState createState() => MakePostState();
}

class MakePostState extends State<MakePost> {
  var descrip = '';
  File image;
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Make Post',
          style: TextStyle(fontSize: 24.0,),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Text('Post'),
            onPressed: () {
              post();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          else if (username != null) {
            return Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        username,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'What are you up to?'
                      ),
                      onChanged: (String val) async {
                        descrip = val;
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 3,

                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                    height: 50,
                    child: SizedBox(
                      width: double.infinity,
                      child: ButtonTheme(
                        child: ElevatedButton(
                          child: Text(
                            'Pick Image',
                            style: TextStyle(fontSize: 30.0, backgroundColor: Theme.of(context).backgroundColor),
                          ),
                          style: ElevatedButton.styleFrom(primary: Theme.of(context).backgroundColor),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ),
                  ),
                  if (image != null) Image.file(image),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      )
    );
  }

  getUser() async {
    username = await Utilities.read('user');
  }
  post() async {
    final autoID = FirebaseFirestore.instance.collection('feed').doc().id;
    TaskSnapshot snapshot;
    String downloadUrl;
    if (image != null) {
      snapshot = await FirebaseStorage.instance.ref().child("Feed/$autoID.jpg").putFile(image);
      downloadUrl = await snapshot.ref.getDownloadURL();
    }
    final formatter = new DateFormat('yyyy-MM-dd');
    await FirebaseFirestore.instance.collection("feed").doc(autoID).set({
      'user': await Utilities.read('user'),
      'description': descrip,
      'datePost': formatter.format(DateTime.now()),
      'likes': [],
      'imageURL': image == null ? '' : downloadUrl,
    });
    Navigator.pop(context);
  }

  Future getImage() async {
    final i = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() async {
      image = await ImageCropper.cropImage(
        sourcePath: i.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        )
      );
      print(image);
    });
  }
}