import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/commonwidgets/button.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/styles/const.dart';

class Contact_us_screen extends StatefulWidget {
  const Contact_us_screen({Key? key}) : super(key: key);

  @override
  State<Contact_us_screen> createState() => _Contact_us_screenState();
}

class _Contact_us_screenState extends State<Contact_us_screen> {
  bool hasFocus = false;
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
        padding: EdgeInsets.all(18),
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
            Text('We want to hear from you! Fill out this form to get in touch with us.',
              style: TextStyle(
                  fontSize: 14,
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
              );

            },
          ),
        ),

            sizedboxheight(20.0),
            submitBtn(context)
          ],
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
        btnColor: hasFocus ? colorEnabledButton : colorDisabledButton,
        onPressed: () {
         // Get.to(() => Pre_Question_Screen());
        },
      ),
    );
  }

}
