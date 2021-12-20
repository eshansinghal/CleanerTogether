import 'package:cleaner_together/Auth/SignUp.dart';
import 'package:cleaner_together/Custom%20Widgets.dart';
import 'package:cleaner_together/Utilities.dart';
import 'package:cleaner_together/Which%20Bin/ItemInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:like_button/like_button.dart';

import '../Data Structures.dart';
import 'MakePost.dart';
import 'Comments.dart';

class Feed extends StatelessWidget {
  String username;
  var posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: TextStyle(fontSize: 24.0,),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      // endDrawer: SideMenu(),
      body: FutureBuilder(
        future: getFeed(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
          }
          else if (posts.length > 0) {
            return Container (
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        'What are you up to?',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser == null)
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                        else
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MakePost()));
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      scrollDirection: Axis.vertical,
                      addRepaintBoundaries: false,
                      itemBuilder: (context, i) {
                        return makePost(i, context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  Container makePost(int i, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: posts[i].user + '\n', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway', fontSize: 16.0, color: Colors.black)),
                    TextSpan(text: posts[i].description + '\n', style: TextStyle(fontSize: 16.0, fontFamily: 'Raleway', color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          posts[i].imageURL != '' ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Image.network(
              posts[i].imageURL,
              fit: BoxFit.cover,
            ),
          ) : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: <Widget>[
                LikeButton(
                  size: 35.0,
                  isLiked: posts[i].likes.contains(username),
                  circleColor:
                  CircleColor(start: Colors.grey, end: Colors.red),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Colors.red,
                    dotSecondaryColor: Colors.grey,
                  ),
                  likeBuilder: (bool isLiked) {
                    return isLiked ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30.0,
                    ) : Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                      size: 30.0,
                    );
                  },
                  likeCount: posts[i].likes.length,
                  countBuilder: (int count, bool isLiked, String text) {
                    var color = isLiked ? Colors.red : Colors.black;
                    return Text(
                      posts[i].likes.length.toString(),
                      style: TextStyle(
                        color: color,
                        fontSize: 20.0,
                      ),
                    );
                  },
                  onTap: (bool isLiked) async {
                    if (FirebaseAuth.instance.currentUser == null) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                      return isLiked;
                    }
                    else {
                      try {
                        if (isLiked) posts[i].likes.remove(await Utilities.read('user'));
                        else posts[i].likes.add(await Utilities.read('user'));
                        await FirebaseFirestore.instance.collection('feed').doc(posts[i].id).update({'likes': posts[i].likes,});
                        return !isLiked;
                      } on FirebaseException catch (e) {
                        Utilities.displayAlert('Error', e.code, context);
                        return isLiked;
                      }
                    }
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(
                    Icons.comment,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Comments(post: posts[i])));
                  },
                ),
                Spacer(),
                Text(
                    posts[i].daysAgo == 0 ? 'Posted Today' : 'Posted ${posts[i].daysAgo} Days Ago',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey))
              ],
            ),
          ),
          Divider(
            height: 10,
            thickness: 1,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  getFeed() async {
    username = await Utilities.read('user');
    posts = [];
    await FirebaseFirestore.instance.collection('feed').get().then((qs) {
      qs.docs.forEach((element) {
        var data = element.data();
        final date = DateTime.parse(data['datePost']);
        final daysAgo = DateTime.now().difference(date).inDays;
        posts.add(PostInfo(element.id, data['user'], data['description'], data['imageURL'], daysAgo, List.from(data['likes'])));
        print(posts);
      });
    });
    posts.sort((a, b) => a.daysAgo.compareTo(b.daysAgo));
  }


}