import 'package:cleaner_together/Auth/SignUp.dart';
import 'package:cleaner_together/Which%20Bin/ItemInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:cleaner_together/Data Structures.dart';
import 'package:cleaner_together/Utilities.dart';

class Comments extends StatefulWidget {
  PostInfo post;
  Comments({this.post});
  @override
  CommentsState createState() => CommentsState(post);
}
class CommentsState extends State<Comments> {
  PostInfo post;
  CommentsState(this.post);

  var comments = [];
  var commentsQueried = false;

  final addCommentController = TextEditingController();
  FocusNode addCommentNode = new FocusNode();
  var comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
          style: TextStyle(fontSize: 24.0,),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
          future: getComments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Error: ${snapshot.error.toString()}');
            }
            else if (commentsQueried) {
              return Container (
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: post.user + ' ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black)),
                              TextSpan(text: post.description + '\n', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                              TextSpan(text: post.daysAgo == 0 ? 'Posted Today' : 'Posted ${post.daysAgo} Days Ago', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Expanded(
                      child: comments.length != 0 ? ListView.builder(
                        itemCount: comments.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(text: comments[i].user + ' ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black)),
                                          TextSpan(text: comments[i].comment + '\n', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                                          TextSpan(text: comments[i].daysAgo == 0 ? 'Posted Today' : 'Posted ${comments[i].daysAgo} Days Ago', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 20,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              ]
                            ),
                          );
                        },
                      )  : Center(
                        child: Text(
                          'No one has commented on this post. Be the first!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: 70,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        obscureText: false,
                        controller: addCommentController,
                        focusNode: addCommentNode,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).backgroundColor, width: 3),
                          ),
                          labelText: 'Add a comment',
                          labelStyle: TextStyle(
                            color: addCommentNode.hasFocus ? Theme.of(context).backgroundColor : Colors.grey,
                          ),
                          suffix: TextButton(
                            child: Text(
                              'Post',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                backgroundColor: Colors.transparent
                              ),
                            ),
                            onPressed: () async {
                              if (FirebaseAuth.instance.currentUser == null)
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => SignUp()));
                              else {
                                final formatter = new DateFormat('yyyy-MM-dd');
                                await FirebaseFirestore.instance.collection("feed").doc(post.id).collection('comments').doc().set({
                                  'user': await Utilities.read('user'),
                                  'comment': comment,
                                  'datePost': formatter.format(DateTime.now())
                                });
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(addCommentNode);
                          });
                        },
                        onChanged: (String val) async {
                          comment = val;
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

  getComments() async {
    await FirebaseFirestore.instance.collection('feed').doc(post.id).collection('comments').get().then((qs) {
      qs.docs.forEach((element) {
        var data = element.data();
        final date = DateTime.parse(data['datePost']);
        final daysAgo = DateTime.now().difference(date).inDays;
        comments.add(Comment(element.id, data['user'], data['comment'], daysAgo));
        print(comments);
      });
    });
    comments.sort((a, b) => a.daysAgo.compareTo(b.daysAgo));
    commentsQueried = true;
  }
}