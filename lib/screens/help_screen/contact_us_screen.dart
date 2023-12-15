import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/Custom_chackbox_screen.dart';
import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/auth model/user_login_model.dart';
import 'package:http/http.dart' as http;

import '../onbording_screen/pre_question_loding_screen.dart';

class Contact_us_screen extends StatefulWidget {
  const Contact_us_screen({Key? key}) : super(key: key);

  @override
  State<Contact_us_screen> createState() => _Contact_us_screenState();
}

class _Contact_us_screenState extends State<Contact_us_screen> {
  final TextEditingController _textMessageController = TextEditingController();
  int? field1 = 0;
  bool hasFocus = false;
  int messageBox = 0;

  var success, message;
  String? tokanget ;
  Future<user_login_model> addMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog_popup(context,"Message add...");
      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();
      map["message"] = _textMessageController.text.toString().trim();
      map["contact_me"] = messageBox.toString();

      return map;
    }
    print(toMap());
    var response = await http.post(
      Uri.parse(Endpoints.baseURL+Endpoints.sendCustomerContactEmail),
      body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json',
        }
    );
    print(response.body.toString());
    success = (user_login_model.fromJson(json.decode(response.body)).status);
    message = (user_login_model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {
      if (success == 200) {
        Navigator.pop(context);
        _textMessageController.clear();
        _showDialog( context);
      }
    } else {
      Navigator.pop(context);
      FlutterToast_message(message);
    }
    return user_login_model.fromJson(json.decode(response.body));
  }

@override
  void dispose() {
    // TODO: implement dispose
    messageBox = 0;
    super.dispose();
    //
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontFamily: fontFamilyText,
            color: colorBlack,
            fontWeight: fontWeight600,

          ),
          icon: Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.clear,color: colorShadowBlue,)),

          title:  const Text("Form submitted",textAlign: TextAlign.center,),
          content:  Text("Thank you!\n We’ll be in touch.",
            style: TextStyle(
              fontSize: 18,
              fontFamily: fontFamilyText,
              color: colorPrimaryColor,
              fontWeight: fontWeight400,
            ),textAlign: TextAlign.center,).paddingOnly(left: 20,right: 20),
           actions: <Widget>[
            okayBtn(context).paddingOnly(left: 20,right: 20,bottom: 10)
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,color: colorRichblack,),
        ),
      ),
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        padding: EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact us',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: fontFamilyText,
                    color: colorPrimaryColor,
                    fontWeight: fontWeight600,
                ),
              ),
              sizedboxheight(5.0),
              Text('We want to hear from you! Fill out this form to get in touch with us.',
                style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: fontFamilyText,
                    color: HexColor('#6A707F'),
                    fontWeight: fontWeight600,
                ),
              ),
              sizedboxheight(20.0),
              Text('Message' ,style: TextStyle(
                fontSize: 12,
                fontFamily: fontFamilyText,
                color: colorRichblack,
                fontWeight: fontWeight600,
              ),),
            Focus(
            child: Builder(
              builder: (BuildContext context) {
                final FocusNode focusNode = Focus.of(context);
                 hasFocus = focusNode.hasFocus;
                return  TextFormField(
                  minLines: 5,
                  maxLines: 5,
                  textCapitalization:TextCapitalization.sentences,
                  controller: _textMessageController,
                  style:  TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight600,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#EFF1F9').withOpacity(0.6),
                    border: InputBorder.none,
                    hintText: "Placeholder",
                    helperStyle:  TextStyle(
                      fontSize: 16,
                      fontFamily: fontFamilyText,
                      color: colorShadowBlue,
                      fontWeight: fontWeight400,
                    ),
                  ),
                  onChanged: (val){
                    setState(() {
                      print(val.length);
                      field1 = val.length;
                    });
                  },
                );

              },
            ),
          ),
              sizedboxheight(8.0),
              Container(
                height: 50,
                width: deviceWidth(context),
                child: Custom_chackbox(
                  screentype: 1,
                  action:(){
                    setState(() {
                      if(messageBox==0){
                        messageBox = 1;
                      }else if(messageBox==1){
                        messageBox = 0;
                      }
                     // messageBox = !messageBox;
                    });
                  },
                  buttoninout:messageBox==0?false:true,
                  buttontext:"Please contact me about my message",
                  unchackborderclor: HexColor('#CCCCCC'),
                  chackborderclor: colorBluePigment,
                  chackboxunchackcolor: colorWhite,
                  chackboxchackcolor: colorWhite,
                  titel_textstyle: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyText,
                      color: colorRichblack,
                      fontWeight: fontWeight400,
                      overflow: TextOverflow.ellipsis
                  ),
                ),
              ),
              sizedboxheight(10.0),
              submitBtn(context)
            ],
          ),
        ),
      ),
    );
  }
  Widget submitBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Submit',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: field1 !=0 ? colorEnabledButton : colorDisabledButton,
        onPressed: () {

          if(_textMessageController.text.isNotEmpty){
            addMessage();
          }else{
            FlutterToast_message('Massage field is empty');
          }

         // Get.to(() => Pre_Question_Screen());
        },
      ),
    );
  }
  Widget okayBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Okay!',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorEnabledButton,
        onPressed: () {
           Get.back();
           Get.back();
        },
      ),
    );
  }
}
