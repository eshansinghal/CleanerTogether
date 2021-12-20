import 'dart:io';
import 'dart:convert';
import 'package:cleaner_together/Custom%20Widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:cleaner_together/Auth/SignUp.dart';
import 'package:cleaner_together/Which%20Bin/ItemInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleaner_together/Data Structures.dart';
import 'package:cleaner_together/Utilities.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:camera/camera.dart';
import 'package:cleaner_together/Which Bin/PickRecyclingFacility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cleaner_together/Notifications.dart';

class SearchItem extends StatefulWidget {
  @override
  SearchItemState createState() => SearchItemState();
}

class SearchItemState extends State<SearchItem> {
  var items = [];
  Future<bool> itemsLoaded;

  var searchTerm = '';
  var searchResults = [];

  final itemNameController = TextEditingController();
  FocusNode itemNameNode = new FocusNode();
  var itemName = '';

  CameraController controller;
  List<CameraDescription> cameras;

  double slidingMin;
  double slidingMax;
  double slidingTop;

  PanelController slidingController = PanelController();
  FloatingSearchBarController searchController = FloatingSearchBarController();
  ScrollController itemsController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemsLoaded = getItems();
    itemsController.addListener(() {
      print(itemsController.position.userScrollDirection);
      final panelClosed = slidingController.isPanelClosed;
      if (itemsController.position.userScrollDirection == ScrollDirection.reverse && panelClosed == true) {
        print('open');
        slidingController.open();
      } else if (itemsController.position.userScrollDirection == ScrollDirection.forward && itemsController.position.atEdge == true) {
        print('close');
        setState(() {
          searchTerm = '';
        });
        slidingController.close();
      }
    });
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // App state changed before we got the chance to initialize.
  //   if (controller == null || !controller.value.isInitialized) {
  //     return;
  //   }
  //   if (state == AppLifecycleState.inactive) {
  //     controller?.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     if (controller != null) {
  //       setupCamera();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    slidingMin = MediaQuery.of(context).size.height - 430;
    print(MediaQuery.of(context).padding);
    print(slidingMin);
    slidingMax = MediaQuery.of(context).size.height - 180;
    slidingTop = slidingMin;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      endDrawer: SideMenu(),
      body: FutureBuilder(
          future: itemsLoaded,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Utilities.displayAlert('Error', snapshot.error, context);
            } else if (items.length > 0) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: FloatingSearchBar(
                    controller: searchController,
                    backdropColor: Colors.transparent,
                    automaticallyImplyDrawerHamburger: false,
                    automaticallyImplyBackButton: false,
                    clearQueryOnClose: false,
                    onFocusChanged: (changed) {
                      if (changed) {
                        if (searchController.isClosed)
                          slidingController.close();
                        if (searchController.isOpen)
                          print('open sliding panel');
                        slidingController.open();
                      }
                    },
                    leadingActions: [
                      FloatingSearchBarAction(
                        showIfClosed: true,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Image.asset('assets/Transparent Logo.png')),
                      ),
                    ],
                    body: Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://cleanertogether.com/wp-content/uploads/2020/06/scenic-view-of-agricultural-field-against-sky-during-sunset-325944.jpg',
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.bottomCenter),
                      ),
                      child: SlidingUpPanel(
                        parallaxEnabled: true,
                        controller: slidingController,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0)),
                        minHeight: slidingMin,
                        maxHeight: slidingMax,
                        onPanelSlide: (double pos) => setState(() {
                          setState(() {
                            searchTerm = '';
                            searchController.clear();
                          });
                          slidingTop = pos * (slidingMax - slidingMin) + 30;
                          print(slidingTop);
                        }),
                        panel: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView(
                                  controller: itemsController,
                                  scrollDirection: Axis.vertical,
                                  addRepaintBoundaries: false,
                                  children: makeItemsList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        body: Container(
                          padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                          child: Column(
                            children: <Widget>[
                              // Container(
                              //   height: 35,
                              //   child: Align(
                              //     alignment: Alignment.topRight,
                              //     child: FloatingActionButton(
                              //       heroTag: 3,
                              //       backgroundColor: Colors.white,
                              //       child: Icon(
                              //         Icons.camera_alt,
                              //         color: Colors.grey[600],
                              //         size: 20.0,
                              //       ),
                              //       onPressed: () async {
                              //         if (FirebaseAuth.instance.currentUser ==
                              //             null)
                              //           Navigator.of(context).push(
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       SignUp()));
                              //         else {
                              //           final photoItem =
                              //           await controller.takePicture();
                              //           submitItemRequestDialog(photoItem);
                              //         }
                              //       },
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 65),
                              Container(
                                height: 70,
                                child: Text(
                                  'Cleaning the world through tech and teamwork',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 150,
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SizedBox(height: 85),
                                        TextButton(
                                          child: Text(
                                            'Cleaner Together',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400
                                                // foreground: Paint()
                                                //   ..style = PaintingStyle.stroke
                                                //   ..strokeWidth = 1
                                                //   ..color = Colors.black,
                                                ),
                                          ),
                                          onPressed: () async {
                                            if (await canLaunch(
                                                'https://cleanertogether.com/'))
                                              await launch(
                                                  'https://cleanertogether.com/');
                                          },
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: <Widget>[
                                        FloatingActionButton(
                                          heroTag: 1,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.location_on,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          onPressed: () async {
                                            recyclingCenterPressed();
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FloatingActionButton(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          heroTag: 2,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            if (FirebaseAuth
                                                    .instance.currentUser ==
                                                null)
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignUp()));
                                            else
                                              addItemAlertDialog();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      searchTerm == '' ? 'Search for an item' : searchTerm,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: searchTerm == '' ? Colors.grey : Colors.black),
                    ),
                    hint: 'Search for an item',
                    onSubmitted: (String item) {
                      searchController.close();
                    },
                    actions: [
                      FloatingSearchBarAction(
                        showIfClosed: true,
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications_active,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Notifications()));
                          },
                        ),
                      ),
                      FloatingSearchBarAction(
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.grey),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      ),
                      FloatingSearchBarAction(
                        showIfOpened: true,
                        showIfClosed: false,
                        child: IconButton(
                            icon: Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              searchController.clear();
                              searchController.close();
                            }),
                      )
                    ],
                    onQueryChanged: (query) {
                      setState(() {
                        searchTerm = query;
                        searchResults = [];
                        for (int i = 0; i < items.length; i++) {
                          if ((items[i].name.toLowerCase() +
                                  items[i].alternateNames.toLowerCase())
                              .contains(query.toLowerCase()))
                            searchResults.add(items[i]);
                        }
                        // searchController.close();
                      });
                    },
                    isScrollControlled: true,
                    transitionDuration: Duration(),
                    builder: (context, transition) {
                      return Container();
                    }),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<Widget> makeItemsList() {
    var rows = <Widget>[];
    bool head = true;
    int i = -1;
    print(searchResults.length);
    if (searchResults.length == 0) {
      rows.add(Spacer(),);
      rows.add(
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height - 200,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Sorry, the item you are searching is not currently in our database. Please change the wording of your search or add the item you entered to our database by pressing the add sign on the screen.',
              style: TextStyle(color: Colors.grey, fontSize: 18.0),
            ),
          ),
        ),
      );
      rows.add(Spacer(),);
    }
    else {
      while (i < searchResults.length) {
        if (i == -1) {
          rows.add(
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey[300],
                ),
              ),
            ),
          );
          rows.add(
            SizedBox(
              height: 20,
            ),
          );
          rows.add(
            Align(
              alignment: Alignment.center,
              child: Text(
                'Find an Item',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
          rows.add(makeHeader(searchResults[0].name.substring(0, 1)));
          i++;
        } else if (head ||
            (searchResults[i].name.substring(0, 1) ==
                searchResults[i - 1].name.substring(0, 1))) {
          head = false;
          rows.add(makeItem(searchResults[i], context));
          i++;
        } else {
          head = true;
          rows.add(makeHeader(searchResults[i].name.substring(0, 1)));
        }
      }
    }
    return rows;
  }

  setupCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    print(controller);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  submitItemRequestDialog(XFile image) {
    var alertDialog = AlertDialog(
      title: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: 'Submit Item Request\n',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black)),
            TextSpan(
                text:
                    'The image below will be sent to our team to determine if it is recyclable and we will send an answer as soon as possible.',
                style: TextStyle(fontSize: 16.0, color: Colors.black))
          ],
        ),
      ),
      content: Image.file(File(image.path)),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'Send',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                backgroundColor: Colors.transparent),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 0,
          ),
          onPressed: () async {
            final autoID = FirebaseFirestore.instance
                .collection('requestedItems')
                .doc()
                .id;
            TaskSnapshot snapshot;
            String downloadUrl;
            snapshot = await FirebaseStorage.instance
                .ref()
                .child("RequestedItems/$autoID.jpg")
                .putFile(File(image.path));
            downloadUrl = await snapshot.ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection("requestedItems")
                .doc(autoID)
                .set({
              'user': await Utilities.read('user'),
              'imageURL': downloadUrl,
              'message': '',
            });
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  addItemAlertDialog() {
    var alertDialog = AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      title: Text(
        'Add an Item',
        style: TextStyle(fontSize: 24.0, color: Theme.of(context).shadowColor),
      ),
      content: Text(
        'If you cannot find the object you are looking for, please enter it below to help expand our database of items!',
        style: TextStyle(fontSize: 18.0, color: Theme.of(context).shadowColor),
      ),
      actions: <Widget>[
        Container(
          height: 60,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            obscureText: false,
            controller: itemNameController,
            focusNode: itemNameNode,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 3),
              ),
              labelText: 'Item Name',
              labelStyle: TextStyle(
                color: itemNameNode.hasFocus
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              suffix: ButtonTheme(
                buttonColor: Colors.transparent,
                child: ElevatedButton(
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor,
                        backgroundColor: Colors.transparent),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    if (FirebaseAuth.instance.currentUser == null)
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUp()));
                    else {
                      await FirebaseFirestore.instance
                          .collection("other")
                          .doc()
                          .set({
                        'name': itemName,
                        'username': await Utilities.read('user'),
                        'approved': false,
                      });
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      var alertDialog = AlertDialog(
                        titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        title: Text(
                          'Item Addition Sent',
                          style: TextStyle(fontSize: 24.0, color: Theme.of(context).shadowColor),
                        ),
                        content: Text(
                          'The item you have submitted will be reviewed by our team and added to the database very soon!',
                          style: TextStyle(fontSize: 18.0, color: Theme.of(context).shadowColor),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            },
                          ),
                        ],
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alertDialog;
                        }
                      );
                    }
                  },
                ),
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(itemNameNode);
              });
            },
            onChanged: (String val) async {
              itemName = val;
            },
          ),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  recyclingCenterPressed() async {
    if (await Utilities.read('recyclingCenter') == '')
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PickRecyclingFacility()));
    else {
      final centerId = await Utilities.read('recyclingCenter');
      final facilityIn =
          'http://api.earth911.com/earth911.getProgramDetails?api_key=783aa93e81e2003e&program_id=$centerId';
      final facilityInfo =
          json.decode((await http.get(Uri.parse(facilityIn))).body);
      var alertDialog = AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: facilityInfo['result'][centerId]['description'] + '\n',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                      color: Colors.black)),
              TextSpan(
                  text: facilityInfo['result'][centerId]['phone'] + '\n',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w300,
                  )),
              TextSpan(
                  text: facilityInfo['result'][centerId]['notes_public'],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w300,
                  )),
            ],
          ),
        ),
        content: Container(
          height: 50,
          child: TextButton(
            child: Align(
              child: Text(
                facilityInfo['result'][centerId]['url'],
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            onPressed: () async {
              if (await canLaunch(facilityInfo['result'][centerId]['url']))
                await launch(facilityInfo['result'][centerId]['url']);
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Align(
              child: Text(
                'Change Recycling Facility',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.transparent,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PickRecyclingFacility()));
            },
          ),
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog;
          });
    }
  }

  Future<bool> getItems() async {
    print(itemsLoaded);
    String userCenter = await Utilities.read('recyclingCenter');
    print('getting data');
    await FirebaseFirestore.instance
        .collection('items')
        .where('approved', isEqualTo: true)
        .get()
        .then((qs) {
      qs.docs.forEach((element) async {
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
        final item = Item(id, eid.toString(), user, name, alternateNames,
            material, whichBin, image, info, 'items', links);
        if (data['image'] != null &&
            data['material'] != null &&
            !items.contains(item)) {
          print(data);
          items.add(item);
        }
      });
    });
    print(items.length);
    items.sort((a, b) => a.name.compareTo(b.name));
    if (userCenter != '') {
      for (int i = 0; i < items.length; i++) {
        if (items[i].eid != '') {
          items[i].whichBin = 'Trash';
        }
      }
      print(userCenter);
      final locationUrl =
          'http://api.earth911.com/earth911.getProgramDetails?api_key=783aa93e81e2003e&program_id=$userCenter';
      final locationInfo =
          json.decode((await http.get(Uri.parse(locationUrl))).body);
      print(locationInfo);
      for (int i = 0;
          i < locationInfo['result'][userCenter]['materials'].length;
          i++) {
        print(locationInfo['result'][userCenter]['materials'][i]);
        int index = items.indexWhere((item) =>
            item.eid.toString() ==
            locationInfo['result'][userCenter]['materials'][i]['material_id']
                .toString());
        print(index);
        if (index != -1) {
          items[index].whichBin = 'Accepted by ';
          if (locationInfo['result'][userCenter]['materials'][i]['pickup'])
            items[index].whichBin += '(Curbside) ';
          if (locationInfo['result'][userCenter]['materials'][i]['dropoff'])
            items[index].whichBin += '(Dropoff)';
          if (locationInfo['result'][userCenter]['materials'][i]['notes'] != '')
            items[i].info +=
                '\n*${locationInfo['result'][userCenter]['materials'][i]['notes']}';
        }
      }
    }
    searchResults = items;
    print('items loaded');
    print(itemsLoaded);
    return true;
  }

  Text makeHeader(String letter) {
    return Text(
      letter,
      style: TextStyle(
        fontSize: 36.0,
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Card makeItem(Item item, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          item.whichBin,
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Image.network(item.image),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemInfo(item),
              ));
        },
      ),
    );
  }
}
