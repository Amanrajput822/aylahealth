import 'package:aylahealth/screens/auth/forgot_password_screens/resetpass_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/formtextfield/mytextfield.dart';
import '../../../common/styles/const.dart';
import 'forgot_pass_provider.dart';

class VerifyScreen extends StatefulWidget {
   String? email;
   VerifyScreen({Key? key, this.email}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  TextEditingController txt_varify_code = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool pass_show = true;
  int? field1 = 0;
  String? showEmail ;
  String maskEmail(String email) {
    if (email.isEmpty) {return "";}
    List<String> parts = email.split("@");
    if (parts.length != 2) {
      // Invalid email format, return the original email.
      return email;
    }

    String username = parts[0];
    String domain = parts[1];
    String maskedUsername = username[0] + "*" * (username.length - 1);
    showEmail = "$maskedUsername@$domain";
    return "$maskedUsername@$domain";
  }

@override
  void initState() {
  final forgotPassProviderData = Provider.of<ForgotPassProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
    maskEmail(widget.email??"");
    forgotPassProviderData.textFieldValidationFunction(false);
  }

  @override
  Widget build(BuildContext context) {
    final forgotPassProviderData = Provider.of<ForgotPassProvider>(context);

    return Scaffold(
      backgroundColor: colorBlizzardBlue,
      body: SizedBox(
        height: deviceheight(context),
        width: deviceWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [

              sizedboxheight(deviceheight(context, 0.3)),
                 Form(
                   key: formkey,
                   child: Container(
                height: deviceheight(context, 0.7),
                width: deviceWidth(context),
                decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: colorWhite
                ),
                padding: EdgeInsets.all(20),
                child:forgotPassProviderData.loading
                      ? Container(
                    child: const Center(
                        child: CircularProgressIndicator()),
                ) :  Column(
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

                      Text('We sent a code to your email',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: fontFamilyText,
                          color: colorTextFieldHadingText,
                          fontWeight: fontWeight600,
                        ),
                      ),
                      sizedboxheight(deviceheight(context,0.025)),
                      Text('Enter the 6-digit verification code sent to $showEmail.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontFamilyText,
                          color: colorBlack,
                          fontWeight: fontWeight600,
                        ),
                      ),

                      sizedboxheight(deviceheight(context,0.025)),
                      verifyfield(),
                      forgotPassProviderData.textFieldValidation?
                      Text("That's not the right code.",
                        style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontFamily: fontFamilyText,
                        fontWeight: fontWeight400
                      ),):Container(),
                      sizedboxheight(deviceheight(context,0.025)),
                      submitBtn(context),
                      sizedboxheight(deviceheight(context,0.02)),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: (){
                            if(widget.email!.isNotEmpty){
                              txt_varify_code.clear();
                              forgotPassProviderData.forgotPasswordApi(context,widget.email.toString());
                            }

                          },
                          child: Text('Resend Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: colorBlack,
                              fontWeight: fontWeight600,
                            ),
                          ),
                        ),
                      ),
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
  Widget submitBtn(context) {
    final forgotPassProviderData = Provider.of<ForgotPassProvider>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Submit',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: ((field1 !=0 )? colorEnabledButton:colorDisabledButton),
        onPressed: () {
          if(field1 !=0){
            if(formkey.currentState!.validate()){
              forgotPassProviderData.verifyCodeApi(context,txt_varify_code.text.toString());
            }

          }
          // Get.to(() => Reset_Pass());
        },
      ),
    );
  }


  Widget verifyfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Password confirmation',
            // key: Key("email1"),
            //floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Verification code',
            hintText: 'Enter verification code',

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,

            controller: txt_varify_code,
            autofillHints: [AutofillHints.password],
            textInputAction: TextInputAction.done,

            keyBoardType: TextInputType.number,
            validatorFieldValue: 'password',
            onChanged: (val){
              setState(() {
                print(val.length);
                field1 = val.length;
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Verification code is Required.';
              }
            },
          );
        },
      ),
    );


  }
}
