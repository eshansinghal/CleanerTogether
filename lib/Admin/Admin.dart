import 'package:cleaner_together/Admin/FulfillItemRequest.dart';
import 'package:flutter/material.dart';
import 'EditItem.dart';

class Admin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            child: Text('Approve and Edit Items'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditItem(item: null)));
            },
          ),
          ElevatedButton(
            child: Text('Respond to Requested Items'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FulfillItemRequest()));
            },
          )
        ],
      ),
    );
  }
}