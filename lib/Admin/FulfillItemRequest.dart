import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FulfillItemRequest extends StatefulWidget {
  @override
  FulfillItemRequestState createState() => FulfillItemRequestState();
}

class FulfillItemRequestState extends State<FulfillItemRequest> {

  String itemId;
  String itemImage;
  String itemUser;
  String itemMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Fulfill Item Request'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          actions: [
            TextButton(
              child: Text(
                'Save'
              ),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('requestedItems').doc(itemId).delete();
                await FirebaseFirestore.instance.collection('users').doc(itemUser).collection('notifications').doc().set({
                  'imageURL': itemImage,
                  'message': itemMessage,
                });
                Navigator.pop(context);
              },
            ),
          ]
      ),
      body: FutureBuilder(
        future: itemImage == null ? getItemInfo() : null,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
          }
          else if (itemImage != null) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Image.network(itemImage),
                    TextFormField(
                      initialValue: itemUser,
                      decoration: InputDecoration(
                          labelText: 'Name'
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Message'
                      ),
                      onChanged: (String val) async {
                        itemMessage = val;
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
    print(itemImage);
    await FirebaseFirestore.instance.collection('requestedItems').get().then((qs) {
      final element = qs.docs[0];
      var data = element.data();
      String id = element.id;
      final user = data['user'] ?? '';
      final image = data['imageURL'] ?? '';
      if (itemImage == null) {
        setState(() {
          itemId = id;
          itemImage = image;
          itemUser = user;
        });
      }
      print(itemImage);
    });
  }
}