import 'dart:convert';
import 'dart:io';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/auth/login_screen.dart';
import 'package:aylahealth/screens/auth/signup_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../common/SharedPrefHelper.dart';
import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/new_bottombar_screen/New_Bottombar_Screen.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/auth model/user_login_model.dart';
import '../onbording_screen/pre_question_loding_screen.dart';
import 'google_authentication.dart';

import 'package:http/http.dart' as http;

class Signup_type extends StatefulWidget {
  const Signup_type({Key? key}) : super(key: key);

  @override
  State<Signup_type> createState() => _Signup_typeState();
}

class _Signup_typeState extends State<Signup_type> {

  String? divece_type;

  bool _isSigningIn = false;


  ////////////// FacebookLogin ///////////

  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;

  final plugin = FacebookLogin(debug: true);

  Future<void> _onPressedLogInButton() async {
    await plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo(plugin);
  }
  Future<void> _updateLoginInfo(plugin1) async {
    final plugin = plugin1;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;
    String? userid;
    if (token != null) {

      profile = await plugin.getUserProfile();
      userid= profile!.userId;
      print(userid.toString());
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
        social_login('2',profile.userId.toString(),profile.name,email);

      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }
   //////////// Google login //////////

  ///////////// initializeFirebase /////////////

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => UserInfoScreen(
      //       user: user,
      //     ),
      //   ),
      // );
    }
    return firebaseApp;
  }

  ///////////////// signInWithGoogle //////////

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }


  //////////////// Apple login /////////

  Future<void> apple_login_fuction () async {
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

    await FirebaseAuth.instance.signInWithCredential(credential);
    var userdata = FirebaseAuth.instance.currentUser;
    social_login('3',userdata!.uid.toString(),userdata.displayName,userdata.email.toString());
    print('appleIdCredential.email');
    print(userdata!.email);
    print(userdata.uid);
    print(userdata.phoneNumber);
    print(userdata.displayName);
    print(userdata.photoURL);
    print('appleIdCredential.identityToken');

  }


  ////////////////  type_check ////////
  void type_check(){
    if (Platform.isIOS) {
      divece_type= '2';
    } else if(Platform.isAndroid)  {
      divece_type= '1';
    }
    else{
      divece_type= '1';
    }
  }

  /////////////// social_login api /////////////

  var success, message, id, email;
  Future<user_login_model> social_login(social_name,social_id,user_name,user_email) async {

    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog_popup(context,"Sign In...");
      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();

      map["cust_social_name"] = social_name;
      map["cust_social_id"] = social_id.toString();
      map["cust_login_by"] = divece_type.toString();
     if(user_name != null) {
        map["cust_firstname"] = user_name.toString();
      }
     if(user_email != null) {
        map["cust_email"] = user_email.toString();
      }

      return map;
    }
    print(toMap());
    var response = await http.post(
      Uri.parse(Endpoints.baseURL+Endpoints.socialLogin),
      body: toMap(),
    );
    print(response.body.toString());
    success = (user_login_model.fromJson(json.decode(response.body)).status);
    message = (user_login_model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {
      if (success == 200) {
        Navigator.pop(context);
        FlutterToast_message(message);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString(
          'login_user_id',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.custId ?? '',
          ),
        );
        prefs.setString(
            'login_user_name',
            (  "${json.encode(
              user_login_model.fromJson(json.decode(response.body))
                  .data!
                  .custFirstname ?? '',
            )}""\t""${json.encode(
              user_login_model.fromJson(json.decode(response.body))
                  .data!
                  .custLastname ?? '',
            )}")
        );
        prefs.setString(
          'login_user_email',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.custEmail ?? '',
          ),
        );
        prefs.setString(
          'login_user_token',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.accessToken ?? '',
          ),
        );
        prefs.setString(
          'login_user_profilepic',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.image ?? '',
          ),
        );
        prefs.setString(
          'login_user_profilepic',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.image ?? '',
          ),
        );
        prefs.setBool(
          'user_login_time',
          user_login_model.fromJson(json.decode(response.body)).data!.custLoginStatus! ,
        );
        final user = user_login_model.fromJson(json.decode(response.body)).data!;

        SharedPrefHelper.userId = int.tryParse(user.custId.toString());
        SharedPrefHelper.name =  "${user.custFirstname}""\t""${user.custLastname}";
        SharedPrefHelper.email = user.custEmail ?? "";
        SharedPrefHelper.authToken = user.accessToken ?? "";

        if(user_login_model.fromJson(json.decode(response.body)).data!.custLoginStatus == 0){
          prefs.setBool(
            'user_login_time', false,
          );
          Get.offAll(() => Pre_Question_Screen());

        }
        else if(user_login_model.fromJson(json.decode(response.body)).data!.custLoginStatus == 1){
          prefs.setBool(
            'user_login_time', true,
          );
          Get.offAll(() => New_Bottombar_Screen());

        }
        else{
          Get.offAll(() => New_Bottombar_Screen());
        }

        FlutterToast_message(message);
      }
    } else {
      Navigator.pop(context);
      print('else==============');
      FlutterToast_message(message);
    }
    return user_login_model.fromJson(json.decode(response.body));
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    type_check();
  }


  Future<void> _onPressedLogOutButton() async {
    await plugin.logOut();
    await _updateLoginInfo(plugin);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlizzardBlue,
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              sizedboxheight(deviceheight(context, 0.15)),
              Container(
                height: deviceheight(context, 0.1),
                child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/Logo (1).svg')),
              ),
              sizedboxheight(deviceheight(context, 0.05)),
              Container(
                height: deviceheight(context, 0.7),
                width: deviceWidth(context),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: colorWhite
                ),
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedboxheight(deviceheight(context, 0.03)),
                      Text('Get started.',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: fontFamilyText,
                          color: colorPrimaryColor,
                          fontWeight: fontWeight700,
                        ),
                      ),

                      sizedboxheight(deviceheight(context,0.02)),

                      signupBtn(context),
                      
                      sizedboxheight(deviceheight(context,0.01)),
                    Divider(
                      color: HexColor('#D0D4DB'),
                      thickness: 1,
                    ),
                      Platform.isIOS? sizedboxheight(deviceheight(context,0.02)):Container(),
                      Platform.isIOS? applebutton():Container(),
                      sizedboxheight(deviceheight(context,0.02)),
                      facebookbutton(),
                      sizedboxheight(deviceheight(context,0.02)),
                      googlebutton(),
                      sizedboxheight(deviceheight(context,0.02)),
                      // TextButton(onPressed: () async {
                      //   _onPressedLogOutButton();
                      //   // setState(() {
                      //   //   _isSigningOut = true;
                      //   // });
                      //   // await Authentication.signOut(context: context);
                      //   // setState(() {
                      //   //   _isSigningOut = false;
                      //   // });
                      // }, child: Text("Logout")),
                      Align(
                          alignment: Alignment.center,
                          child:RichText(
                            text:  TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamilyText,
                                color: colorShadowBlue,
                                fontWeight: fontWeight400,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Login',
                                    style:  TextStyle(
                                      fontSize: 14,
                                      fontFamily: fontFamilyText,
                                      color: colorRichblack,
                                      fontWeight: fontWeight400,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {


                                        Navigator.push(
                                          context,
                                          PageTransition(duration:Duration(milliseconds: 400) ,
                                            type: PageTransitionType.bottomToTop,
                                            child: LogIn(),
                                          ),
                                        );
                                        //Code to launch your URL
                                      }),
                              ],
                            ),
                          )


                      ),
                      sizedboxheight(deviceheight(context,0.1)),
                      Align(
                        alignment:Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Terms of use',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamilyText,
                                color: colorShadowBlue,
                                fontWeight: fontWeight400,
                              ),
                            ),
                            Text('Privacy & cookies',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamilyText,
                                color: colorShadowBlue,
                                fontWeight: fontWeight400,
                              ),
                            )
                          ],
                        ),
                      )
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
  Widget signupBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Sign up with Email',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorEnabledButton,
        onPressed: () {
           Get.to(() => Signup_screen());
        },
      ),
    );
  }
  Widget applebutton(){
    return Container(
      height:  57.0,
      width: deviceWidth(context),
      decoration: BoxDecoration(

        color:  colorWhite,
        borderRadius:  BorderRadius.circular(8.0),

      ),
      child: MaterialButton(
        splashColor: Colors.grey,
        // animationDuration: Duration(seconds: 10),
        hoverColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(8.0),
          side: BorderSide(color:  colorPrimaryColor),
        ),

        elevation:  3,
        onPressed: (){
          apple_login_fuction ();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: deviceWidth(context,0.1),
                child: SvgPicture.asset('assets/path4.svg')),
            sizedboxwidth(8.0),
            Container(
              width: deviceWidth(context,0.6),
              child: Text('Sign up with Apple',
                style:
                    TextStyle(
                        inherit: true,
                        color: colorRichblack,
                        fontFamily: 'Messina Sans',
                        fontWeight: fontWeight600,
                        fontSize: 20,
                        letterSpacing: 0.3,
                        overflow: TextOverflow.ellipsis
                    ),
                maxLines: 1,),
            )
          ],
        ),
      ),
    );
  }
  Widget facebookbutton(){
    return Container(
      height:  57.0,
      width: deviceWidth(context),
      decoration: BoxDecoration(

        color:  colorWhite,
        borderRadius:  BorderRadius.circular(8.0),

      ),
      child: MaterialButton(
        splashColor: Colors.grey,
        // animationDuration: Duration(seconds: 10),
        hoverColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(8.0),
          side: BorderSide(color:  colorPrimaryColor),
        ),

        elevation:  3,
        onPressed: (){
          _onPressedLogInButton();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: deviceWidth(context,0.1),
                child: Image.asset('assets/facebook.png')),
            sizedboxwidth(8.0),
            Container(
              width: deviceWidth(context,0.6),
              child: Text('Sign up with Facebook',
                style:
                TextStyle(
                    inherit: true,
                    color: colorRichblack,
                    fontFamily: 'Messina Sans',
                    fontWeight: fontWeight600,
                    fontSize: 20,
                    letterSpacing: 0.3,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,),
            )
          ],
        ),
      ),
    );
  }
  Widget googlebutton(){
    return Container(
      height:  57.0,
      width: deviceWidth(context),
      decoration: BoxDecoration(
        color:  colorWhite,
        borderRadius:  BorderRadius.circular(8.0),

      ),
      child:   FutureBuilder(
        future: initializeFirebase(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error initializing Firebase');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return  MaterialButton(
              splashColor: Colors.grey,
              // animationDuration: Duration(seconds: 10),
              hoverColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(8.0),
                side: BorderSide(color:  colorPrimaryColor),
              ),

              elevation:  3,
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User? user = await signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  social_login('1',user.uid.toString(),user.displayName,user.email);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: deviceWidth(context,0.1),
                      child: SvgPicture.asset('assets/logo googleg 48dp.svg')),
                  sizedboxwidth(8.0),
                  Container(
                    width: deviceWidth(context,0.6),
                    child: Text('Sign up with Google',
                      style:
                      TextStyle(
                          inherit: true,
                          color: colorRichblack,
                          fontFamily: 'Messina Sans',
                          fontWeight: fontWeight600,
                          fontSize: 20,
                          letterSpacing: 0.3,
                          overflow: TextOverflow.ellipsis
                      ),
                      maxLines: 1,),
                  )
                ],
              ),
            );
          }
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              colorgrey,
            ),
          );
        },
      ),
    );
  }
}
