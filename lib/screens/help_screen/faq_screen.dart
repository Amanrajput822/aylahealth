import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/styles/const.dart';

class FAQs_screen extends StatefulWidget {
  const FAQs_screen({Key? key}) : super(key: key);

  @override
  State<FAQs_screen> createState() => _FAQs_screenState();
}

class _FAQs_screenState extends State<FAQs_screen> {
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
              Text('  FAQs',
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
              commenlisttile('Managing subscription', 'Text optional', (){
                // Get.to(() => FAQs_screen());
              }),


              commenlisttile('Modules', 'Text optional', (){
                // Get.to(() => FAQs_screen());
              }),

              commenlisttile('Recipes', 'Text optional', (){
                // Get.to(() => FAQs_screen());
              }),


              commenlisttile('My Meals', 'Text optional', (){
                // Get.to(() => FAQs_screen());
              }),

              commenlisttile('Privacy', 'Text optional', (){
               // Get.to(() => FAQs_screen());
              }),
            ],
          ),
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
