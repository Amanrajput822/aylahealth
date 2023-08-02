import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/styles/const.dart';

class Notifocation_Screen extends StatefulWidget {
  const Notifocation_Screen({Key? key}) : super(key: key);

  @override
  State<Notifocation_Screen> createState() => _Notifocation_ScreenState();
}

class _Notifocation_ScreenState extends State<Notifocation_Screen> {
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
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
            Text('  Notifications',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: fontFamilyText,
                  color: colorPrimaryColor,
                  fontWeight: fontWeight600,
                  overflow: TextOverflow.ellipsis
              ),
              maxLines: 1,
            ),
            Text('   Manage your notification settings.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamilyText,
                color: colorRichblack,
                fontWeight: fontWeight400,
              ),
            ),

            ListTile(
              title: Text('Notification type 1',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ),
              subtitle:Text('Description of notification goes here.',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: fontFamilyText,
                    color: HexColor('#6A707F'),
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ) ,
              tileColor: colorWhite,
              textColor: colorRichblack,
              trailing: Switch(

                onChanged: (a){
                  setState(() {
                    isSwitched1 = a ;
                  });
                },
                value: isSwitched1,
                activeColor: HexColor('#2D3091'),
                activeTrackColor: HexColor('#2D3091').withOpacity(0.4),
                inactiveThumbColor: colorgrey,
                inactiveTrackColor: HexColor('#2D3091').withOpacity(0.4),
              ),

              onTap: (){
               // Get.to(() => Notifocation_Screen());
              },
            ),
            Divider(
              thickness: 1,height: 1,
              color: HexColor('#E9ECF1'),
            ),
            ListTile(
              title: Text('Notification type 2',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ),
              subtitle:Text('Description of notification',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: fontFamilyText,
                    color: HexColor('#6A707F'),
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ) ,
              tileColor: colorWhite,
              textColor: colorRichblack,
              trailing: Switch(

                onChanged: (a){
                  setState(() {
                    isSwitched2 = a ;
                  });
                },
                value: isSwitched2,
                activeColor: HexColor('#2D3091'),
                activeTrackColor: HexColor('#2D3091').withOpacity(0.4),
                inactiveThumbColor: colorgrey,
                inactiveTrackColor: HexColor('#2D3091').withOpacity(0.4),
              ),

              onTap: (){
                // Get.to(() => Notifocation_Screen());
              },
            ),
            Divider(
              thickness: 1,height: 1,
              color: HexColor('#E9ECF1'),
            ),
            ListTile(
              title: Text('Notification type 3',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ),
              subtitle:Text('Description of notification goes here.',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: fontFamilyText,
                    color: HexColor('#6A707F'),
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ) ,
              tileColor: colorWhite,
              textColor: colorRichblack,
              trailing: Switch(

                onChanged: (a){
                  setState(() {
                    isSwitched3 = a ;
                  });
                },
                value: isSwitched3,
                activeColor: HexColor('#2D3091'),
                activeTrackColor: HexColor('#2D3091').withOpacity(0.4),
                inactiveThumbColor: colorgrey,
                inactiveTrackColor: HexColor('#2D3091').withOpacity(0.4),
              ),

              onTap: (){
                // Get.to(() => Notifocation_Screen());
              },
            ),
            Divider(
              thickness: 1,height: 1,
              color: HexColor('#E9ECF1'),
            ),
          ],
        ),
      ),
    );
  }
}
