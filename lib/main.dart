import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/demo_form.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: "hahaha",),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message;

  var facebookLogin = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title ?? ""),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.all(5.0),
              child: new RaisedButton(
                color: Colors.blue,
                child: new Center(child: new Text("Login with Facebook", style: new TextStyle(color: Colors.white),)),
                onPressed: () async {
                  var result =
                      await facebookLogin.logInWithReadPermissions(['email']);

                  switch (result.status) {
                    case FacebookLoginStatus.loggedIn:
//                    _sendTokenToServer(result.accessToken.token);
                      setState(() {
                        _message = result.accessToken.toMap().toString();
                      });
                      break;
                    case FacebookLoginStatus.cancelledByUser:
                      setState(() {
                        _message = "FacebookLoginStatus.cancelledByUser";
                      });
                      break;
                    case FacebookLoginStatus.error:
                      setState(() {
                        _message = "FacebookLoginStatus.error";
                      });
                      break;
                  }
                },
              ),
            ),
            new Container(
              margin: const EdgeInsets.all(5.0),
              child: new RaisedButton(
                color: Colors.red,
                child: new Center(child: new Text("Login with Google", style: new TextStyle(color: Colors.white),)),
                onPressed: () {
                  _handleSignIn().then((FirebaseUser user) {
                    print(user);
                    setState(() {
                      _message = "Hello ${user.displayName}";
                    });
                  }).catchError((e) {
                    print(e);
                    setState(() {
                      _message = "Error ${e.toString()}";
                    });
                  });
                },
              ),
            ),
            new Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: new BoxDecoration(borderRadius: new BorderRadius.all(new Radius.circular(6.0)), border: new Border.all()),
              child: new Text(
                'info = $_message',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
