import 'dart:async';
import 'dart:convert';

import 'package:aylahealth/screens/profile_settings/personal_setting/personal_setting.dart';
import 'package:aylahealth/screens/profile_settings/personal_setting/personal_setting_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/direct_logout.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/onboarding_screens_models/Gender_List_Model.dart';
import '../../models/profile/user_details_model.dart';
import '../tabbar_screens/support_screen/message/chat/firebase_services.dart';

class Edite_Profile_Screen extends StatefulWidget {


   Edite_Profile_Screen({Key? key }) : super(key: key);

  @override
  State<Edite_Profile_Screen> createState() => _Edite_Profile_ScreenState();
}

class _Edite_Profile_ScreenState extends State<Edite_Profile_Screen> {

  Future? _future;
  String? selectedgender;
  String? selectedvalue;

  TextEditingController txt_firstname = TextEditingController();
  TextEditingController txt_lastname = TextEditingController();
  TextEditingController txt_DOB = TextEditingController();
  TextEditingController txt_street_address = TextEditingController();
  TextEditingController txt_suburb = TextEditingController();
  TextEditingController txt_state = TextEditingController();
  TextEditingController txt_postcode = TextEditingController();
  TextEditingController txt_Phone_number = TextEditingController();
  TextEditingController txt_gender = TextEditingController();

  void api_dta(){
    final uerdatamodal = Provider.of<userprofile_Provider>(context, listen: false);

    txt_firstname.text = uerdatamodal.user_details_data!.custFirstname??"";
    txt_lastname.text = uerdatamodal.user_details_data!.custLastname??"";
    selectedDate = uerdatamodal.user_details_data!.custDOB??"";
    txt_street_address.text = uerdatamodal.user_details_data!.custAddress??"";
    txt_suburb.text = uerdatamodal.user_details_data!.custSuburb??"";
    txt_state.text = uerdatamodal.user_details_data!.custState??"";
    txt_postcode.text = uerdatamodal.user_details_data!.custPostcode??"";
    txt_Phone_number.text = uerdatamodal.user_details_data!.custPhone??"";
    selectedgender = uerdatamodal.user_details_data!.custGender.toString();
    selectedvalue = uerdatamodal.user_details_data!.genName.toString();

    print(uerdatamodal.user_details_data!.custFirstname.toString());
    print(uerdatamodal.user_details_data!.custLastname.toString());
    print(uerdatamodal.user_details_data!.custAddress.toString());
    print(uerdatamodal.user_details_data!.custSuburb.toString());
    print(uerdatamodal.user_details_data!.custState.toString());
    print(uerdatamodal.user_details_data!.custPostcode.toString());
    print(uerdatamodal.user_details_data!.custPhone.toString());
  }

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
     print(toMap());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.updateCustomer),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    if(response.statusCode==200){
    print(response.body.toString());
    success = (user_details_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);

      user_details_data = (user_details_model.fromJson(json.decode(response.body)).data);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'login_user_name',
            (  "${json.encode(
              user_details_model.fromJson(json.decode(response.body))
                  .data!
                  .custFirstname ?? '',
            )}""\t""${json.encode(
              user_details_model.fromJson(json.decode(response.body))
                  .data!
                  .custLastname ?? '',
            )}")
        );
        FlutterToast_message('Profile updated successfully');
      final uerdatamodal = Provider.of<userprofile_Provider>(context, listen: false);
      uerdatamodal.customer_ditels_api(context);
      FirebaseData.instance.userUpdate();
    } else {
      Navigator.pop(context);
      print('else==============');
      FlutterToast_message('No Data');
    }}
    else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
    }
    return user_details_model.fromJson(json.decode(response.body));
  }

  Map toMap() {
    var map =  Map<String, dynamic>();

    map["cust_id"] = user_id;
    map["cust_firstname"] = txt_firstname.text.toString();
    map["cust_lastname"] = txt_lastname.text.toString();
    map["cust_phone"] = txt_Phone_number.text.toString();
    map["cust_address"] = txt_street_address.text.toString();
    map["cust_suburb"] = txt_suburb.text.toString();
    map["cust_state"] = txt_state.text.toString();
    map["cust_postcode"] = txt_postcode.text.toString();
    map["cust_DOB"] = selectedDate.toString();
    map["cust_gender"] = selectedgender.toString();

    return map;
  }

  String? selectedDate ;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: colorBluePigment, // header background color
                onPrimary: colorWhite, // header text color
                onSurface: colorBlack, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: colorBluePigment, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate =  DateFormat("dd-MMMM-yyyy").format(picked);
      });
    }
  }

  //////////////////////// gender_List_api api ////////////////////

  List<Gender_List_recponse>? grnder_list;

  Future<Gender_List_Model> gender_List_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.get(
        Uri.parse(Endpoints.baseURL+Endpoints.genderList),
        headers: {
          'Authorization': 'Bearer $tokanget',
        }
    );
    print(response.body.toString());
    success = (Gender_List_Model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {

      grnder_list = (Gender_List_Model.fromJson(json.decode(response.body)).data);

    } else {
      Navigator.pop(context);
      print('else==============');
      FlutterToast_message('No Data found');
    }
    return Gender_List_Model.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api_dta();
    final uerdatamodal = Provider.of<userprofile_Provider>(context, listen: false);
    uerdatamodal.customer_ditels_api(context);
    _future = gender_List_api();
  }
  //
  // Future<bool> _willPopCallback() async {
  //   if(widget.edit != 0){
  //     Get.off(() => Personal_Setting(user_details_data:widget.user_details_data,screen:1));
  //
  //   }
  //  else if(widget.edit == 0){
  //    //Navigator.pop(context);
  //     Get.off(() => Personal_Setting(user_details_data:widget.user_details_data,screen:1));
  //   }
  //   return true; // return true if the route to be popped
  // }

  Future<void> _asyncSimpleDialog(BuildContext context) async {
    return await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter set) {
              return SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: Text(
                  'Select gender ',
                  style: TextStyle(
                      color: colorRichblack,
                      // fontFamily: 'Nunito',
                      fontFamily: 'Messina Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                children: <Widget>[
                  for(int i=0;i<grnder_list!.length;i++)
                    Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              activeColor: colorBluePigment,
                              value:grnder_list![i].genName.toString(),
                              groupValue: selectedvalue ?? grnder_list![0].genName.toString(),
                              focusColor: colorWhite,

                              onChanged: (value){
                                setState(() {
                                  set((){});
                                  print(value.toString());
                                  selectedgender = grnder_list![i].genId.toString();
                                  selectedvalue = grnder_list![i].genName.toString();
                                  Navigator.pop(context);

                                });
                              },
                            ),
                            Container(
                              width: deviceWidth(context,0.45),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    set((){});
                                    selectedgender=grnder_list![i].genId.toString();
                                    selectedvalue = grnder_list![i].genName.toString();
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text(grnder_list![i].genName.toString(),style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: colorRichblack,
                                  fontWeight: fontWeight400,
                                ),
                                ),
                              ),
                            )
                          ],
                        )),

                ],
              );
            }
          );
        });
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
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              sizedboxheight(20.0),
              // Text('First name',
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontFamily: fontFamilyText,
              //     color: colorRichblack,
              //     fontWeight: fontWeight400,
              //   ),
              // ),
              // sizedboxheight(5.0),
              firstnamefield(),
              sizedboxheight(15.0),

              lastnamefield(),
              sizedboxheight(10.0),

             dobfield(),
              sizedboxheight(10.0),

              addressfield(),
              sizedboxheight(15.0),

              suburbfield(),
              sizedboxheight(15.0),

              statefield(),
              sizedboxheight(15.0),

              postcodefield(),
              sizedboxheight(15.0),

              mobilefield(),
              sizedboxheight(15.0),

              Genderfield(),
              sizedboxheight(20.0),

              saveBtn(context),
              sizedboxheight(20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Save',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorEnabledButton,
        onPressed: () {

          customer_ditels_api();
          
        },
      ),
    );
  }

  Widget firstnamefield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Email',
            // key: Key("email1"),
           // floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'name',
            labelText: 'First Name',
            controller: txt_firstname,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.name],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.text,
            validatorFieldValue: 'first name',

            validator: (value) {
              if (value.isEmpty) {
                return 'first name is Required.';
              }
            },
          );

        },
      ),
    );
  }
  Widget lastnamefield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Email',
            // key: Key("email1"),
           // floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'name',
            labelText: 'Last Name',
            controller: txt_lastname,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.name],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.text,
            validatorFieldValue: 'last name',

            validator: (value) {
              if (value.isEmpty) {
                return 'last name is Required.';
              }
            },
          );

        },
      ),
    );
  }

  Widget dobfield() {
    return   Container(
      width: deviceWidth(context),
      height: 60,

      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(6),
        color: colorWhite,
      ),
      child: Stack(
        children: [
          Center(
            child: InkWell(
              onTap: ()  {
                _selectDate( context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(6),
                  color: colorDisabledTextField,
                ),
                width: deviceWidth(context),
                height: 48,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(selectedDate==''?"Select Date":selectedDate.toString().split(" ")[0],
                        style: TextStyle(
                            color: colorRichblack,
                            // fontFamily: 'Nunito',
                            fontFamily: 'Messina Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 14),),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('Date Of Birth',
                style: TextStyle(
                    color: colorTextFieldHadingText,
                    // fontFamily: 'Nunito',
                    fontFamily: 'Messina Sans',
                    fontWeight: FontWeight.w400,
                    fontSize:  10 )),
          )
        ],
      ),
    );
  }
  Widget addressfield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Email',
            // key: Key("email1"),
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'street address',
            labelText: 'Street Address',
            controller: txt_street_address,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.addressState],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.streetAddress,
            validatorFieldValue: 'street address',

            validator: (value) {
              if (value.isEmpty) {
                return 'street address is Required.';
              }
            },
          );

        },
      ),
    );
  }
  Widget suburbfield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Email',
            // key: Key("email1"),
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'suburb',
            labelText: 'Suburb',
            controller: txt_suburb,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.addressCity],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.streetAddress,
            validatorFieldValue: 'suburb',

            validator: (value) {
              if (value.isEmpty) {
                return 'suburb is Required.';
              }
            },
          );

        },
      ),
    );
  }
  Widget statefield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Email',
            // key: Key("email1"),
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'state',
            labelText: 'State',
            controller: txt_state,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.addressState],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.streetAddress,
            validatorFieldValue: 'state',

            validator: (value) {
              if (value.isEmpty) {
                return 'state is Required.';
              }
            },
          );

        },
      ),
    );
  }
  Widget postcodefield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Email',
            // key: Key("email1"),
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'postcode',
            labelText: 'Postcode',
            controller: txt_postcode,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.postalCode],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.number,
            validatorFieldValue: 'postcode',

            validator: (value) {
              if (value.isEmpty) {
                return 'postcode is Required.';
              }
            },
          );

        },
      ),
    );
  }

  Widget mobilefield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Email',
            // key: Key("email1"),
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'Enter number',
            labelText: 'Phone Number',
            controller: txt_Phone_number,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.telephoneNumber],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.number,
            validatorFieldValue: 'number',

            validator: (value) {
              if (value.isEmpty) {
                return 'Phone number is Required.';
              }
            },
          );

        },
      ),
    );
  }

  Widget Genderfield() {
    return InkWell(
      onTap: (){
        _asyncSimpleDialog( context);
      },
      child: Container(
        width: deviceWidth(context),
        height: 60,

        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(6),
          color: colorWhite,
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(6),
                  color: colorDisabledTextField,
                ),
                width: deviceWidth(context),
                height: 48,
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            selectedvalue??"select gender".toString(),
                            style: TextStyle(
                                color: colorRichblack,
                                // fontFamily: 'Nunito',
                                fontFamily: 'Messina Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    } else {
                      return const Center();
                    }
                  },
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Gender',
                  style: TextStyle(
                      color: colorTextFieldHadingText,
                      // fontFamily: 'Nunito',
                      fontFamily: 'Messina Sans',
                      fontWeight: FontWeight.w400,
                      fontSize:  10 )),
            )
          ],
        ),
      ),
    );
  }
  // Future show_diloge(){
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text("Select Grade System and No of Subjects"),
  //         actions: <Widget>[
  //           // Radio(value: 0, groupValue: groupValue, onChanged: selectRadio),
  //           // Radio(value: 1, groupValue: groupValue, onChanged: selectRadio),
  //         ],
  //       ));
  // }
}
