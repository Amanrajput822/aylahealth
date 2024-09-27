import 'package:aylahealth/screens/help_screen/question_answer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/styles/const.dart';
import 'faq_screen_provider.dart';

class FAQs_screen extends StatefulWidget {
  const FAQs_screen({Key? key}) : super(key: key);

  @override
  State<FAQs_screen> createState() => _FAQs_screenState();
}

class _FAQs_screenState extends State<FAQs_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FAQsProviderModel = Provider.of<FAQsScreenProvider>(context, listen: false);
    FAQsProviderModel.faq_qus_ans_api();
  }
  @override
  Widget build(BuildContext context) {
    final FAQsProviderModel = Provider.of<FAQsScreenProvider>(context);

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
       // padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
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
              ).paddingOnly(top: 15,left: 15,right: 15),
              sizedboxheight(20.0),
              FAQsProviderModel.loading!
                  ? Container(
                child: const Center(child: CircularProgressIndicator()),
              ) : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: FAQsProviderModel.FAQs_Heading_list!.length,
                  itemBuilder: (BuildContext context,int index){
                  return commenlisttile(FAQsProviderModel.FAQs_Heading_list![index].faqHeading??"", 'Text optional', (){
                  Get.to(() => questionAnswerScreen(
                      questionData: FAQsProviderModel.FAQs_Heading_list![index].questionData,
                      faqHeading: FAQsProviderModel.FAQs_Heading_list![index].faqHeading
                  ));
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget commenlisttile(String _title,String _subtitle, Function action){
    return  ListTile(
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      title: Html(
        data: _title.toString(),
        style: {
          "span": Style(
            fontSize: FontSize(16.0),
            fontWeight: fontWeight400,
            color: colorRichblack,
            fontFamily: fontFamilyText,
          ),
        },

      ),
      // Text(_title.toString(),
      //   style: TextStyle(
      //       fontSize: 16,
      //       fontFamily: fontFamilyText,
      //       color: colorRichblack,
      //       fontWeight: fontWeight400,
      //       overflow: TextOverflow.ellipsis
      //   ),
      //   maxLines: 1,
      // ),
      // subtitle: Text(_subtitle.toString(),
      //   style: TextStyle(
      //       fontSize: 12,
      //       fontFamily: fontFamilyText,
      //       color: HexColor('#79879C'),
      //       fontWeight: fontWeight400,
      //       overflow: TextOverflow.ellipsis
      //   ),
      //   maxLines: 1,
      // ).paddingOnly(left: 8),
      tileColor: colorWhite,
      textColor: colorRichblack,
      onTap: () => action() ,

    );
  }

}
