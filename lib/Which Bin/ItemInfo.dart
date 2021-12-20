import 'package:cleaner_together/Admin/EditItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cleaner_together/Data Structures.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemInfo extends StatelessWidget {
  Item item;
  ItemInfo(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(item.name),
        // centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          FirebaseAuth.instance.currentUser != null && ['eshsinghal@yahoo.com', 'anita_singhal_25@yahoo.com'].contains(FirebaseAuth.instance.currentUser.email) ? TextButton(
            child: Text('Edit'),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditItem(item: item)));
            },
          ) : Container()
        ]
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(item.image),
              Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: item.name + '\n', style: TextStyle(fontSize: 36.0, color: Colors.white)),
                      // TextSpan(text: ' Material: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black)),
                      // TextSpan(text: item.material + '\n', style: TextStyle(fontSize: 24.0, color: Colors.white)),
                      // TextSpan(text: 'Disposal Method: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black)),
                      TextSpan(text: item.whichBin + '\n\n\n', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                      // TextSpan(text: 'Special Info: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black)),
                      TextSpan(text: item.info + '\n', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: item.links != '',
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: 'Additional Sources: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black)),
                          ],
                        ),
                      ),
                      Container(
                        height: (item.links.split(', ').length * 50).toDouble(),
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: item.links.split(', ').length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, i) {
                              final links = item.links.split(', ');
                              return Card(
                                child: ListTile(
                                  title: Text(links[i]),
                                  trailing: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    onPressed: () async {
                                      if (await canLaunch(links[i]))
                                        await launch(links[i]);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}