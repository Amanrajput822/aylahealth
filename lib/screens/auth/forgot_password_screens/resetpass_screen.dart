import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/formtextfield/mytextfield.dart';
import '../../../common/formtextfield/validations_field.dart';
import '../../../common/styles/const.dart';
import 'forgot_pass_provider.dart';

class ResetPassScreen extends StatefulWidget {
  String? userId;
   ResetPassScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  TextEditingController txt_conform_pass = TextEditingController();
  TextEditingController txt_pass = TextEditingController();
  bool pass_show = true;
  bool pass_show1 = true;
  int? field1 = 0;
  int? field2 = 0;
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final forgotPassProviderData = Provider.of<ForgotPassProvider>(context);
    return Scaffold(
      backgroundColor: colorBlizzardBlue,
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [

              sizedboxheight(deviceheight(context, 0.3)),
              Form(
                key: _formKey,
                child: Container(
                  height: deviceheight(context, 0.7),
                  width: deviceWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: colorWhite
                  ),
                  padding: EdgeInsets.all(20),
                  child:forgotPassProviderData.loading
                      ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  ) :   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20,top: 10),
                        child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset('assets/backbutton.svg')),
                      ),
                      Text('Reset password',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: fontFamilyText,
                          color: colorTextFieldHadingText,
                          fontWeight: fontWeight600,
                        ),
                      ),
                      sizedboxheight(deviceheight(context,0.025)),

                      Text('Enter your new password.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontFamilyText,
                          color: colorBlack,
                          fontWeight: fontWeight400,
                        ),
                      ),
                      sizedboxheight(deviceheight(context,0.025)),
                      passwordfield(),
                      sizedboxheight(deviceheight(context,0.025)),
                      conformpasswordfield(),
                      sizedboxheight(deviceheight(context,0.025)),
                      doneBtn(context),

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
  Widget doneBtn(context) {
    final forgotPassProviderData = Provider.of<ForgotPassProvider>(context, listen: false);
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Done',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: ((field1 !=0 && field2 !=0)? colorEnabledButton:colorDisabledButton),
        onPressed: () {
          if(field1 !=0 && field2 !=0){
            if(_formKey.currentState!.validate()){
              if(txt_pass.text==txt_conform_pass.text){
                forgotPassProviderData.resetPasswordApi(context,widget.userId,txt_pass.text.toString());
              }
              else{
                print('Passwords do NOT match');
                Fluttertoast.showToast(
                    msg: "Passwords do not match",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: colorFlutterToast,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }


          }
          // Get.to(() => Reset_Pass());
        },
      ),
    );
  }




  Widget passwordfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Password',
            // key: Key("email1"),
            //floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Password',
            hintText: 'password',
            obsecureText: pass_show,
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            suffixIcon: TextButton(
                onPressed: () {
                  setState((){
                    pass_show = !pass_show;
                  });
                },
                child:pass_show? SvgPicture.asset(
                  'assets/fi_eye-off.svg',
                ):SvgPicture.asset(
                  'assets/eye 1.svg',
                )),

            controller: txt_pass,
            autofillHints: [AutofillHints.password],
            textInputAction: TextInputAction.next,

            keyBoardType: TextInputType.visiblePassword,
            validatorFieldValue: 'password',
            onChanged: (val){
              setState(() {
                print(val.length);
                field1 = val.length;
              });
            },
            validator: validateNewPassword,
          );
        },
      ),
    );


  }
  Widget conformpasswordfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Password confirmation',
            // key: Key("email1"),
            //floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Password confirmation',
            hintText: 'Re-enter password',
            obsecureText: pass_show1,
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            suffixIcon: TextButton(
                onPressed: () {
                  setState((){
                    pass_show1 = !pass_show1;
                  });
                },
                child:pass_show1? SvgPicture.asset(
                  'assets/fi_eye-off.svg',
                ):SvgPicture.asset(
                  'assets/eye 1.svg',
                )),

            controller: txt_conform_pass,
            autofillHints: [AutofillHints.password],
            textInputAction: TextInputAction.next,

            keyBoardType: TextInputType.visiblePassword,
            validatorFieldValue: 'password',
            onChanged: (val){
              setState(() {
                print(val.length);
                field2 = val.length;
              });
            },
            validator: (PassCurrentValue){
              Pattern pattern = r'^(?=.*?[a-zA-Z])(?=.*?[0-9]).{8,}$';
              // Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
              // RegExp regex = new RegExp(pattern);

              RegExp regex =  RegExp(pattern as String);

              if (PassCurrentValue.isEmpty) {
                return 'Password is Required.';
              } else if (PassCurrentValue.length < 8) {
                return 'Password length cannot be less than 8 characters.';
              }
              else if (!regex.hasMatch(PassCurrentValue)) {
                return 'Password must contain numbers, letter, and at least 8 characters';
              } else if (txt_conform_pass.text != txt_pass.text) {
                return 'Passwords do not match';
              }
            },
          );
        },
      ),
    );


  }
}
