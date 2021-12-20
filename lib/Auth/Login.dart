import 'package:cleaner_together/Auth/SignUp.dart';
import 'package:cleaner_together/Utilities.dart';
import 'package:cleaner_together/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  var email = '';
  var pass = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
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
              height: 100,
              image: AssetImage('assets/Transparent Logo.png'),
            ),
            SizedBox(height: 20,),
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
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ButtonTheme(
                child: ElevatedButton(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 24.0, backgroundColor: Theme.of(context).backgroundColor, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Theme.of(context).backgroundColor),
                  onPressed: () async {
                    if (email != null && pass != null) {
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email,
                            password: pass
                        );
                        await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get().then((qs) {
                          qs.docs.forEach((element) {
                            print(element.data()['username']);
                            Utilities.save('user', element.data()['username']);
                          });
                        });
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CleanerTogether()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Utilities.displayAlert('User not Found', 'No user was found for the email you entered. Please enter a different email or create an account.', context);
                        } else if (e.code == 'wrong-password') {
                          Utilities.displayAlert('Incorrect Password', ('The password you entered is incorrect. Please try again'), context);
                        }
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
                'Don\'t have an account? Sign Up!',
                style: TextStyle(
                  fontSize: 18.0,
                  backgroundColor: Colors.transparent,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
