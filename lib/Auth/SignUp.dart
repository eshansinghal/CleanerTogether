import 'package:cleaner_together/Auth/Login.dart';
import 'package:cleaner_together/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleaner_together/Utilities.dart';

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  var email = '';
  var user = '';
  var pass = '';
  var repass = '';

  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repassController = TextEditingController();

  FocusNode userNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();
  FocusNode repassNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(fontSize: 24.0),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
            children: <Widget>[
              Image(
                height: 80,
                image: AssetImage('assets/Transparent Logo.png'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Sign up below to add items the Cleaner Together database, post on our community, and much more!',
                style: TextStyle(fontSize: 18.0, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                controller: userController,
                focusNode: userNode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).backgroundColor, width: 3),
                  ),
                  labelText: 'Enter Username',
                  labelStyle: TextStyle(
                    color: userNode.hasFocus ? Theme.of(context).backgroundColor : Colors.grey,
                  ),
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      userController.clear();
                      user = '';
                    },
                  ),
                ),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(userNode);
                  });
                },
                onChanged: (String val) async {
                  user = val;
                },
              ),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                controller: emailController,
                focusNode: emailNode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).backgroundColor, width: 3),
                  ),
                  labelText: 'Enter Email',
                  labelStyle: TextStyle(
                    color: emailNode.hasFocus ? Theme.of(context).backgroundColor : Colors.grey,
                  ),
                  prefixIcon: Icon(Icons.email_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      emailController.clear();
                      email = '';
                    },
                  ),
                ),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(emailNode);
                  });
                },
                onChanged: (String val) async {
                  email = val;
                },
              ),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                controller: passController,
                focusNode: passNode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).backgroundColor, width: 3),
                  ),
                  labelText: 'Enter Password',
                  labelStyle: TextStyle(
                    color: passNode.hasFocus ? Theme.of(context).backgroundColor : Colors.grey,
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      passController.clear();
                      pass = '';
                    },
                  ),
                ),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(passNode);
                  });
                },
                onChanged: (String val) async {
                  pass = val;
                },
              ),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                controller: repassController,
                focusNode: repassNode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).backgroundColor, width: 3),
                  ),
                  labelText: 'Re-Enter Password',
                  labelStyle: TextStyle(
                    color: repassNode.hasFocus ? Theme.of(context).backgroundColor : Colors.grey,
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      repassController.clear();
                      repass = '';
                    },
                  ),
                ),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(repassNode);
                  });
                },
                onChanged: (String val) async {
                  repass = val;
                },
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ButtonTheme(
                  child: ElevatedButton(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 24.0, backgroundColor: Theme.of(context).backgroundColor, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(primary: Theme.of(context).backgroundColor),
                    onPressed: () async {
                      if (email != null && user != null && pass != null && repass != null) {
                        if (pass == repass) {
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email,
                              password: pass,
                            );
                            FirebaseFirestore.instance.collection('users').doc(user).set({
                              'username': user,
                              'email': email,
                              'password': pass
                            });
                            Utilities.save('user', user);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CleanerTogether()));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              Utilities.displayAlert('Weak Password', 'Please ensure the password you entered has at least 6 characters.', context);
                            } else if (e.code == 'email-already-in-use') {
                              Utilities.displayAlert('Duplicate Email', 'An account with this email already exists. Please login into that account or sign up with a different email.', context);
                            }
                          } catch (e) {
                            Utilities.displayAlert('Error', e, context);
                          }
                        }
                        else {
                          Utilities.displayAlert('Passwords are Different', 'The passwords you entered are different. Please change them so that they are the same.', context);
                        }
                      }
                      else {
                        Utilities.displayAlert('Some Fields not Filled In', 'Please ensure all fields are filled in before attempting to sign up.', context);
                      }
                    },
                  ),
                ),
              ),
              Spacer(),
              TextButton(
                child: Text(
                  'Already have an account? Log in!',
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ],
          ),
      ),
    );
  }
}
