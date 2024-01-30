import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/styles/const.dart';
import 'contact_us_screen.dart';
import 'faq_screen.dart';

class Help_Screen extends StatefulWidget {
  const Help_Screen({Key? key}) : super(key: key);

  @override
  State<Help_Screen> createState() => _Help_ScreenState();
}

class _Help_ScreenState extends State<Help_Screen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('  Help',
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

            commenlisttile('FAQs', 'Find answers to frequently asked questions.', (){
              Get.to(() => FAQs_screen());
            }),

            commenlisttile('Contact us', 'Get in touch for support.', (){
              Get.to(() => Contact_us_screen());
            }),

          ],
        ),
      ),
    );
  }

  Widget commenlisttile(String _title,String _subtitle, Function action){
    return  ListTile(
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      title: Text(_title.toString(),
        style: TextStyle(
            fontSize: 16,
            fontFamily: fontFamilyText,
            color: colorRichblack,
            fontWeight: fontWeight400,
            overflow: TextOverflow.ellipsis
        ),
        maxLines: 1,
      ),
      subtitle: Text(_subtitle.toString(),
        style: TextStyle(
            fontSize: 12,
            fontFamily: fontFamilyText,
            color: HexColor('#79879C'),
            fontWeight: fontWeight400,
            overflow: TextOverflow.ellipsis
        ),
        maxLines: 1,
      ),
      tileColor: colorWhite,
      textColor: colorRichblack,
      onTap: () => action() ,

    );
  }

}
