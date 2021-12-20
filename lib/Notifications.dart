import 'package:cleaner_together/Utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {

  var notificationsLoaded = false;
  var notificationImages = [];
  var notificationMessages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder(
        future: getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
          }
          else if (notificationsLoaded) {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: 200,
                child: ListView.builder(
                  itemCount: notificationImages.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          notificationMessages[i],
                        ),
                        leading: Image.network(notificationImages[i]),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  getNotifications() async {
    await FirebaseFirestore.instance.collection('users').doc(await Utilities.read('user')).collection('notifications').get().then((qs) {
      qs.docs.forEach((element) async {
        var data = element.data();
        final imageUrl = data['imageURL'] ?? '';
        final message = data['message'] ?? '';
        notificationImages.add(imageUrl);
        notificationMessages.add(message);
      });
    });
  }
}