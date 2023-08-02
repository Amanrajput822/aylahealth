import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/commonwidgets/button.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/styles/const.dart';

class Resetpass_screen extends StatefulWidget {
  const Resetpass_screen({Key? key}) : super(key: key);

  @override
  State<Resetpass_screen> createState() => _Resetpass_screenState();
}

class _Resetpass_screenState extends State<Resetpass_screen> {
  TextEditingController txt_conform_pass = TextEditingController();
  TextEditingController txt_pass = TextEditingController();
  bool pass_show = true;
  int? field1 = 0;
  int? field2 = 0;

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

              sizedboxheight(deviceheight(context, 0.3)),
              Container(
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
                child: Column(
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
                        fontWeight: fontWeight600,
                      ),
                    ),
                    sizedboxheight(deviceheight(context,0.025)),
                    passwordfield(),
                    sizedboxheight(deviceheight(context,0.025)),
                    conformpasswordfield(),
                    sizedboxheight(deviceheight(context,0.025)),
                    signupBtn(context),

                  ],
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
        buttonName: 'Done',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: ((field1 !=0 && field2 !=0)? colorEnabledButton:colorDisabledButton),
        onPressed: () {
          if(field1 !=0 && field2 !=0){
            // if (_formKey.currentState!.validate()) {
            //   signin();
            // } else {
            //   // model.toggleautovalidate();
            // }

            // Get.to(() => Pre_Question_Screen());
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
            // suffixIcon: TextButton(
            //     onPressed: () {
            //       setState((){
            //         pass_show = !pass_show;
            //       });
            //     },
            //     child:pass_show? SvgPicture.asset(
            //       'assets/fi_eye-off.svg',
            //     ):SvgPicture.asset(
            //       'assets/eye 1.svg',
            //     )),

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
            validator: (value) {
              if (value.isEmpty) {
                return 'password is Required.';
              }
            },
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
            obsecureText: pass_show,
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            // suffixIcon: TextButton(
            //     onPressed: () {
            //       setState((){
            //         pass_show = !pass_show;
            //       });
            //     },
            //     child:pass_show? SvgPicture.asset(
            //       'assets/fi_eye-off.svg',
            //     ):SvgPicture.asset(
            //       'assets/eye 1.svg',
            //     )),

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
            validator: (value) {
              if (value.isEmpty) {
                return 'password is Required.';
              }
            },
          );
        },
      ),
    );


  }
}
