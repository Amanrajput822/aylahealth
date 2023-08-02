import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class apple_login_demo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('display name: ${snapshot.data!.uid}'),
                      Text('email: ${snapshot.data!.email}'),
                      //  Text('provider id: ${snapshot.data!.providerId}'),
                      MaterialButton(
                          child: Text('Sign Out'),
                          color: Colors.lightGreen,
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          })
                    ],
                  ),
                ),
              );
              // return GreetingPage(user: snapshot.data);
            } else {
              return SignInPage(title: 'Apple Sign In Firebase Demo');
            }
          }),
    );
  }
}


class SignInPage extends StatefulWidget {
  SignInPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

Future<void> get_data () async {
  var appleIdCredential =
      await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    webAuthenticationOptions: WebAuthenticationOptions(
      clientId: 'de.lunaone.flutter.signinwithappleexample.service',

      redirectUri: Uri.parse(
        'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
      ),
    ),

  );

  // get an OAuthCredential
  var credential = OAuthProvider(AppleAuthProvider.PROVIDER_ID).credential(
    idToken: appleIdCredential.identityToken,
    accessToken: appleIdCredential.authorizationCode,
  );
  print('appleIdCredential.email');
  print(appleIdCredential.email);
  print(appleIdCredential.identityToken);
  print('appleIdCredential.identityToken');
  // use the credential to sign in to firebase
  await FirebaseAuth.instance.signInWithCredential(credential);
  var userdata = FirebaseAuth.instance.currentUser;
  print('appleIdCredential.email');
  print(userdata!.email);
  print(userdata.uid);
  print(userdata.phoneNumber);
  print(userdata.displayName);
  print(userdata.photoURL);
  print('appleIdCredential.identityToken');

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SignInWithAppleButton(
              onPressed: () async {
                get_data ();

              },
            )
          ],
        ),
      ),
    );
  }
}