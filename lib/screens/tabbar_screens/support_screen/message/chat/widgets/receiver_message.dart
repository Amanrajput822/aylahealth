import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/const.dart';
import '../model/MessageModel.dart';

class ReceiverMessage extends StatelessWidget {
  final Message message;

  const ReceiverMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 80,bottom: 5),
        //   child: Text("Emerald  Sun Tarot",
        //       style:TextStyle(color:Color(0xffBEBEBE),fontWeight: FontWeight.w400,
        //           fontSize:12.0, fontFamily: fontFamilyText),
        //       maxLines: 1,
        //       textAlign: TextAlign.end),
        // ),

        SizedBox(width: 16,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 16),
            //   child: Image.asset(
            //     "assets/images/reciever.png",
            //     height: 48,
            //     width: 48,
            //   ),
            // ),
            // SizedBox(width: 16,),

            Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(left: 20,right: 20,top: 8,bottom: 8),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65, minWidth: 0),
              decoration: BoxDecoration(
                  color: colorBluePigment,
                  borderRadius: BorderRadius.circular(25),
                 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.text,
                      style:TextStyle(fontSize: 16,
                          fontFamily: fontFamilyText,
                          fontWeight: fontWeight400,
                          color: colorWhite),
                      textAlign: TextAlign.start),

                ],
              ),
            ),

          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
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
