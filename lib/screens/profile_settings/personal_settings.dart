import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/profile/user_details_model.dart';
import 'package:http/http.dart' as http;

import 'edit_profile_screen.dart';
class Personal_Settings extends StatefulWidget {
  user_details_esponse? user_details_data;
  int? screen;
   Personal_Settings({Key? key,this.user_details_data,this.screen}) : super(key: key);

  @override
  State<Personal_Settings> createState() => _Personal_SettingsState();
}

class _Personal_SettingsState extends State<Personal_Settings> {
  Future? _future;
  var success, message;
  var tokanget,user_id;
  user_details_esponse? user_details_data;
  Future<user_details_model> customer_ditels_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
      user_id = prefs.getString('login_user_id');
      user_id = user_id!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case

        showLoaderDialog_popup(context,"User Details ...");

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(beasurl+customerDetails),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    print(response.body.toString());
    success = (user_details_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);

      user_details_data = (user_details_model.fromJson(json.decode(response.body)).data);
      // Get.to(() => Pre_Question_Screen());
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Data');

    }
    return user_details_model.fromJson(json.decode(response.body));
  }



  Map toMap() {
    var map =  Map<String, dynamic>();

    map["cust_id"] = user_id;

    return map;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.screen==1){
      user_details_data = widget.user_details_data;
    }else{
      _future = customer_ditels_api();
    }

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
      body: widget.screen==1?Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Personal settings',
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: fontFamilyText,
                        color: colorPrimaryColor,
                        fontWeight: fontWeight600,
                        overflow: TextOverflow.ellipsis
                    ),
                    maxLines: 1,
                  ),
                  InkWell(
                      onTap: (){
                        Get.off(() => Edite_Profile_Screen(user_details_data:user_details_data,edit:0));
                      },
                      child: SvgPicture.asset('assets/image/edit 1.svg'))
                ],
              ),
              sizedboxheight(20.0),
              hedingcontainer('First name'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custFirstname??"name"),

              sizedboxheight(15.0),
              hedingcontainer('Last name'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custLastname??'name'),

              sizedboxheight(15.0),
              hedingcontainer('Date of birth'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custDOB??'DD/MM/YYYY'),

              sizedboxheight(15.0),
              hedingcontainer('Address'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custAddress??'street address'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custSuburb??'suburb'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custState??'state'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custPostcode??'postcode'),

              sizedboxheight(15.0),
              hedingcontainer('Phone number'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.custPhone??'Enter number'),

              sizedboxheight(15.0),
              hedingcontainer('Gender'),
              sizedboxheight(5.0),
              feildcontainer(user_details_data!.genName??'gender'),
              sizedboxheight(20.0),
            ],
          ),
        ),
      ):
      FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return  Container(
              height: deviceheight(context),
              width: deviceWidth(context),
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Personal settings',
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: fontFamilyText,
                              color: colorPrimaryColor,
                              fontWeight: fontWeight600,
                              overflow: TextOverflow.ellipsis
                          ),
                          maxLines: 1,
                        ),
                        InkWell(
                            onTap: (){
                              Get.off(() => Edite_Profile_Screen(user_details_data:user_details_data,edit:0));
                            },
                            child: SvgPicture.asset('assets/image/edit 1.svg'))
                      ],
                    ),
                    sizedboxheight(20.0),
                    hedingcontainer('First name'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custFirstname??"name"),

                    sizedboxheight(15.0),
                    hedingcontainer('Last name'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custLastname??'name'),

                    sizedboxheight(15.0),
                    hedingcontainer('Date of birth'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custDOB??'DD/MM/YYYY'),

                    sizedboxheight(15.0),
                    hedingcontainer('Address'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custAddress??'street address'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custSuburb??'suburb'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custState??'state'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custPostcode??'postcode'),

                    sizedboxheight(15.0),
                    hedingcontainer('Phone number'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.custPhone??'Enter number'),

                    sizedboxheight(15.0),
                    hedingcontainer('Gender'),
                    sizedboxheight(5.0),
                    feildcontainer(user_details_data!.genName??'gender'),
                    sizedboxheight(20.0),
                  ],
                ),
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
  Widget feildcontainer(title){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: HexColor('#F6F8F9')
      ),
      padding: EdgeInsets.all(10),
      width: deviceWidth(context),
      child: Text(title.toString(),
        style: TextStyle(
          fontSize: 16,
          fontFamily: fontFamilyText,
          color: HexColor('#79879C'),
          fontWeight: fontWeight400,
        ),
      ),
    );
  }
  Widget hedingcontainer(title){
    return Text(title.toString(),
      style: TextStyle(
      fontSize: 14,
      fontFamily: fontFamilyText,
      color: colorRichblack,
      fontWeight: fontWeight400,
    ),
    );
  }
}
