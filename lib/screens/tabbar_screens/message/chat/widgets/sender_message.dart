import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/const.dart';
import '../model/MessageModel.dart';

class SenderMessage extends StatelessWidget {
  final Message message;

  const SenderMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
    //     Padding(
    //       padding: const EdgeInsets.only(right: 90),
    //       child: Text(
    //           "You",
    //           style: TextStyle(color:Color(0xffBEBEBE),fontWeight: FontWeight.w400,
    // fontSize:12.0, fontFamily: fontFamilyText),
    //
    //           maxLines: 1,
    //           textAlign: TextAlign.end),
    //     ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(left: 20,right: 20,top: 8,bottom: 8),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                  minWidth: 0),
              decoration: BoxDecoration(
                  color: HexColor('#F6F8F9'),
                  borderRadius: BorderRadius.circular(25),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(message.text,
                  style: TextStyle(fontSize: 16,
                      fontFamily: fontFamilyText,
                  fontWeight: fontWeight400,
                  color: HexColor('#3B4250')),),
                ],
              ),
            ),
            SizedBox(width: 16,),

            // const Padding(
            //   padding: EdgeInsets.only(right: 16),
            //   child: CircleAvatar(
            //     radius: 25.0,
            //     backgroundImage: NetworkImage(
            //      'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg',
            //     ),
            //     backgroundColor: Colors.transparent,
            //   ),
            // ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(DateFormat('kk:mm:a').format(DateTime.parse(message.created.toDate().toString())),
                  style: TextStyle(color:colorShadowBlue,fontWeight: FontWeight.w400,
                  fontSize:12.0, fontFamily: fontFamilyText),

                  maxLines: 1,
                  textAlign: TextAlign.end),
            ),
      ],
    );
  }
}
