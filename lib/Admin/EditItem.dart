import 'dart:convert';
import 'dart:io';
import 'package:cleaner_together/ListData.dart';
import 'package:http/http.dart' as http;
import 'package:cleaner_together/Data%20Structures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class EditItem extends StatefulWidget {
  Item item;
  EditItem({this.item});
  @override
  EditItemState createState() => EditItemState(item);
}

class EditItemState extends State<EditItem> {
  Item item;
  EditItemState(this.item);

  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('Edit Item'),
        actions: [
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              await FirebaseFirestore.instance.collection(item.category).doc(item.id).delete();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              TaskSnapshot snapshot;
              String downloadUrl;
              if (image != null) {
                snapshot = await FirebaseStorage.instance.ref().child("${item.category[0].toUpperCase()}${item.category.substring(1)}/${item.id}.jpg").putFile(image);
                downloadUrl = await snapshot.ref.getDownloadURL();
              }
              await FirebaseFirestore.instance.collection(item.category).doc(item.id).update({
                'approved': true,
                'category': item.category,
                'image': downloadUrl,
                'whichBin': item.whichBin,
                'info': item.info,
                'material': item.material,
                'name': item.name,
                'username': item.username,
                'links': item.links,
                'alternateNames': item.alternateNames
              });
              Navigator.pop(context);
            },
          )
        ]
      ),
      body: FutureBuilder(
        future: item == null ? getItemInfo() : null,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
          }
          else if (item != null) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ButtonTheme(
                      child: ElevatedButton(
                        child: Text(
                          'Pick Image',
                          style: TextStyle(fontSize: 30.0, backgroundColor: Colors.blue),
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                    image != null ? Image.file(image) : (item.image != null ? Image.network(item.image) : Container()),
                    TextFormField(
                      initialValue: item.name,
                      decoration: InputDecoration(
                          labelText: 'Name'
                      ),
                      onChanged: (String val) async {
                        item.name = val;
                      },
                    ),
                    TextFormField(
                      initialValue: item.alternateNames,
                      decoration: InputDecoration(
                          labelText: 'Alternate Names'
                      ),
                      onChanged: (String val) async {
                        item.alternateNames = val;
                      },
                    ),
                    TextFormField(
                      initialValue: item.material,
                      decoration: InputDecoration(
                          labelText: 'Material'
                      ),
                      onChanged: (String val) async {
                        print(item.material);
                        item.material = val;
                      },
                    ),
                    TextFormField(
                      initialValue: item.whichBin,
                      decoration: InputDecoration(
                          labelText: 'Which Bin?'
                      ),
                      onChanged: (String val) async {
                        item.whichBin = val;
                      },
                    ),
                    TextFormField(
                      initialValue: item.info,
                      decoration: InputDecoration(
                          labelText: 'Info'
                      ),
                      onChanged: (String val) async {
                        item.info = val;
                      },
                    ),
                    TextFormField(
                      initialValue: item.links,
                      decoration: InputDecoration(
                          labelText: 'Links'
                      ),
                      onChanged: (String val) async {
                        item.links = val;
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  getItemInfo() async {
    print(item);
    List<String> materials = ['items', 'materials'];
    for (int i = 0; i < 6; i++) {
      await FirebaseFirestore.instance.collection(materials[i]).where('approved', isEqualTo: false).get().then((qs) {
        final element = qs.docs[0];
        var data = element.data();
        String id = element.id;
        final eid = data['id'] ?? '';
        final user = data['username'] ?? '';
        final name = data['name'] ?? '';
        final alternateNames = data['alternateNames'] ?? '';
        final material = data['material'] ?? '';
        final whichBin = data['whichBin'] ?? '';
        final image = data['image'] ?? '';
        final info = data['info'] ?? '';
        final links = data['links'] ?? '';
        if (item == null) {
          setState(() {
            item = Item(id, eid.toString(), user, name, alternateNames, material, whichBin, image, info, materials[i], links);
          });
        }
        print(item);
      });
    }
  }

  Future getImage() async {
    final i = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      image = File(i.path);
      print(item);
    });
  }
}