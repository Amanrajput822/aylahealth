import 'package:aylahealth/models/FAQs_Question_Answer_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/styles/const.dart';

class questionAnswerScreen extends StatefulWidget {
  List<QuestionData>? questionData;
  String? faqHeading;
   questionAnswerScreen({Key? key, this.questionData,this.faqHeading}) : super(key: key);

  @override
  State<questionAnswerScreen> createState() => _questionAnswerScreenState();
}

class _questionAnswerScreenState extends State<questionAnswerScreen> {
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
       // padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: widget.faqHeading??"",

              ).paddingOnly(left: 15,right: 15),
              // Text(widget.faqHeading??"",
              //   style: TextStyle(
              //       fontSize: 24,
              //       fontFamily: fontFamilyText,
              //       color: colorPrimaryColor,
              //       fontWeight: fontWeight600,
              //       overflow: TextOverflow.ellipsis
              //   ),
              //   maxLines: 2,
              // ).paddingOnly(top: 15,bottom: 15,left: 22,right: 22),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                  itemCount: widget.questionData!.length,
                  itemBuilder: (BuildContext context,int index){
                 var item = widget.questionData![index];
                return ExpansionTile(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  collapsedShape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ) ,
                  backgroundColor: colorWhite,
                  collapsedBackgroundColor: colorWhite,
                  iconColor:  HexColor('#3B4250'),
                  textColor: HexColor('#3B4250'),
                  collapsedTextColor: HexColor('#3B4250'),

                  title:
                  Html(
                    data: item.fqueText??"",

                  ),
                  // Text(item.fqueText??"",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontFamily: fontFamilyText,
                  //     color: HexColor('#3B4250'),
                  //     fontWeight: fontWeight600,
                  //
                  //   ),),
                  // Contents
                  children: [
                    item.answerData == null?Container(
                        color: colorWhite,
                        child:Text("Answer Not Found",
                          style: TextStyle(
                            fontSize: 14,
                            height: 2,
                            fontFamily: fontFamilyText,
                            color: colorSlateGray,
                            fontWeight: fontWeight400,

                          ),) ) :Container(
                      color: colorWhite,
                      child: Html(
                          data: item.answerData!.fansText??"",

                      ),
                    ).paddingOnly(left: 15,right: 15)


                  ],
                );
              })

            ],
          ),
        ),
      ),
    );
  }
}
