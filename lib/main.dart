import 'package:cleaner_together/Admin/Admin.dart';
import 'package:cleaner_together/Auth/Login.dart';
import 'package:cleaner_together/Auth/SignUp.dart';
import 'package:cleaner_together/Community/Feed.dart';
import 'package:cleaner_together/Home.dart';
import 'package:cleaner_together/Utilities.dart';
import 'package:cleaner_together/Which%20Bin/SearchItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Discover.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CleanerTogether());
}

class CleanerTogether extends StatefulWidget {
  @override
  CleanerTogetherState createState() => CleanerTogetherState();
}
class CleanerTogetherState extends State<CleanerTogether> with SingleTickerProviderStateMixin {
  //
  @override
  // DefaultTabController tabBarController;
  // int tabIndex = 1;
  // // static final _myTabbedPageKey = new GlobalKey<State<CleanerTogether>>();
  //
  // void _handleTabSelection() {
  //   setState(() {
  //     tabIndex = DefaultTabController.of(context).index;
  //     print(tabIndex);
  //   });
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   tabBarController = new DefaultTabController();
  //   TabController(initialIndex: 1, length: 3, vsync: this).addListener(_handleTabSelection);
  // }
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    // Utilities.save('user', '');

    return new MaterialApp(
      // key: _myTabbedPageKey,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Color(0xFFEDD098), //Green
        backgroundColor: Color(0xFF97BFD8), // Blue
        shadowColor: Color(0xFF8CC090), //Brown

        // Define the default font family.
        fontFamily: 'Raleway',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0),
          headline6: TextStyle(fontSize: 36.0),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
      ),
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          bottomNavigationBar: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [Color(0xFFEDD098), Color(0xFF97BFD8)],
              ),
            ),
            child: TabBar(
              // controller: tabBarController,
              labelStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ),
              labelColor: Colors.white,
              // indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey[100],
              unselectedLabelStyle: TextStyle(
                  fontFamily: 'Raleway'
              ),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.white, width: 4),
                insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 70.0),
              ),
              // indicatorWeight: 0,
              tabs: [
                // Tab(
                //   text: 'Home',
                //   icon: Icon(Icons.home),
                // ),
                Tab(
                  text: 'Discover',
                  icon: Icon(Icons.book_outlined),
                ),
                Tab(
                  text: 'Home',
                  icon: Icon(Icons.home_outlined),
                ),
                Tab(
                  text: 'Community',
                  icon: Icon(Icons.people_outline),
                ),
              ],
            ),
          ),
          body: TabBarView(
            // controller: tabBarController,
            children: <Widget>[
              // Home(),
              Discover(),
              SearchItem(),
              Feed(),
            ],
          ),
        ),
      ),
    );
  }
}