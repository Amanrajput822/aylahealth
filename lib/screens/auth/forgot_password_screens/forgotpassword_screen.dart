import 'package:aylahealth/screens/auth/forgot_password_screens/resetpass_screen.dart';
import 'package:aylahealth/screens/auth/forgot_password_screens/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/formtextfield/mytextfield.dart';
import '../../../common/formtextfield/validations_field.dart';
import '../../../common/styles/const.dart';
import 'forgot_pass_provider.dart';

class Forgotpass_screen extends StatefulWidget {
  const Forgotpass_screen({Key? key}) : super(key: key);

  @override
  State<Forgotpass_screen> createState() => _Forgotpass_screenState();
}

class _Forgotpass_screenState extends State<Forgotpass_screen> {
  TextEditingController txt_email = TextEditingController();
  int? field1 = 0;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final forgotPassProviderData = Provider.of<ForgotPassProvider>(context);

    return Scaffold(
      backgroundColor: colorBlizzardBlue,
      body:  Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [

              sizedboxheight(deviceheight(context, 0.3)),
              Form(
                key: formkey,
                child:  Container(
                  height: deviceheight(context, 0.7),
                  width: deviceWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: colorWhite
                  ),
                 // padding: EdgeInsets.all(20),
                  child: forgotPassProviderData.loading
                      ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  ) :  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10,top: 10),
                          child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: SvgPicture.asset('assets/backbutton.svg')),
                        ),
                        Text('Forgot your password?',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: fontFamilyText,
                            color: colorTextFieldHadingText,
                            fontWeight: fontWeight600,
                          ),
                        ).paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.025)),

                        Text('To reset your password, please enter your email address below. We’ll send a password reset code to this email.',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorBlack,
                            height: 1.5,
                            fontWeight: fontWeight400,
                          ),
                        ).paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.025)),
                        emailfield().paddingOnly(left: 20,right: 20),


                        sizedboxheight(deviceheight(context,0.025)),
                        sendBtn(context).paddingOnly(left: 20,right: 20),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget sendBtn(context) {
    final forgotPassProviderData = Provider.of<ForgotPassProvider>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Send',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: (field1 !=0? colorEnabledButton:colorDisabledButton),
        onPressed: () {
         if(field1 !=0){
          if(formkey.currentState!.validate()){
            forgotPassProviderData.forgotPasswordApi(context,txt_email.text.toString());
            txt_email.clear();
          }}
        },
      ),
    );
  }

  Widget emailfield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Email',
            // key: Key("email1"),
            //floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Email',
            hintText: 'Email address',

            controller: txt_email,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.email],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.emailAddress,
            validatorFieldValue: 'email',
            onChanged: (val){
              setState(() {
                print(val.length);
                field1 = val.length;
              });
            },
            validator: validateEmailField,
          );

        },
      ),
    );
  }

}
