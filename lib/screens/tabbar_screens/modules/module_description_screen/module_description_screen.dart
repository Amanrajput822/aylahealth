import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../../../common/SharedPrefHelper.dart';
import '../../../../common/commonwidgets/button.dart';
import '../../../../common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../common/styles/const.dart';

import '../../../../models/modules/moduleLibraryDataModel.dart';
import '../../../../models/modules/searchModuleModel.dart';
import '../../../subscription_screens/sub_popup/subscription_plan_popup.dart';
import '../modules_screen/modules_screen_provider.dart';
import 'ModuleDescriptionProvider.dart';
import 'applying_screens/applying_screen.dart';
import 'learning_screen/learning_screens.dart';


class ModuleDescriptionScreen extends StatefulWidget {
  String? moduleId;
  searchModuleResponse? searchData;
  String? screenType;
  String? screenName;

   ModuleDescriptionScreen({Key? key,
    this.moduleId,
    this.searchData,
     this.screenType,
     this.screenName
   }) : super(key: key);

  @override
  State<ModuleDescriptionScreen> createState() => _ModuleDescriptionScreenState();
}

class _ModuleDescriptionScreenState extends State<ModuleDescriptionScreen> {
  // String? buttonType = 'Start Module';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context,listen: false);
  //  DescriptionScreenData.buttonTypeFunction('Start Module');
      if(widget.screenType=="search"){
         DescriptionScreenData.customerModuleViewStatus_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString());
        }
      DescriptionScreenData.moduleDetailsForApp_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString());

  }



  @override
  Widget build(BuildContext context) {
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context);

    return Container(
      color: colorWhite,
      width: deviceWidth(context),
      height: deviceheight(context),
      child: SafeArea(
        top: true,
        child: Scaffold(
         backgroundColor: colorWhite,
          body:  DescriptionScreenData.loading1? Container(
            height: deviceheight(context),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ): Container(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(

                  //  height: deviceheight(context,0.25),
                    width: deviceWidth(context),
                    color: colorgrey,
                    child: Stack(
                      children: [

                        Container(
                          // height: deviceheight(context,0.25),
                          width: deviceWidth(context),
                          //child: Image.asset("assets/img.png",fit: BoxFit.fill,
                          child:  AspectRatio(
                            aspectRatio: 500/357,
                            child: SizedBox(

                              child: Image.network((widget.screenType=="search"?widget.searchData!.image:DescriptionScreenData.moduleDetailsForAppData!.image)??
                                  "https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE="
                                ,fit: BoxFit.fill,
                                errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                  fit: BoxFit.fill,),
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },),
                            ),
                          ),


                        ),
                        Container(
                          height: deviceheight(context,0.25),
                          width: deviceWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 12.5,
                                        child: SvgPicture.asset('assets/backbutton.svg',color: colorBluePigment,height: 13,))),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DescriptionScreenData.loading? Container(
                    height: deviceheight(context)*0.2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ):Container(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.screenType=="search"?widget.searchData!.mscName??"":DescriptionScreenData.moduleDetailsForAppData!.mscName??"",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: HexColor('#3B4250'),
                              fontWeight: fontWeight400,
                            ),),
                          Text(widget.screenType=="search"?widget.searchData!.mdTitle.toString():DescriptionScreenData.moduleDetailsForAppData!.mdTitle??"",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: fontFamilyText,
                              color: HexColor('#151A26'),
                              fontWeight: fontWeight600,
                            ),),
                          sizedboxheight(8.0),
                          DescriptionScreenData.customerModuleViewStatusData != null? DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 3? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/image/learnCompleteIcon.svg',
                                  color: colorBluePigment,width: 20, height: 20,),
                              sizedboxwidth(5.0),
                              Text("Completed",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontFamilyText,
                                  color: colorBluePigment,
                                  fontWeight: fontWeight400,
                                ),),
                            ],
                          ):Container():Container(),
                          DescriptionScreenData.buttonType == 'Completed'? sizedboxheight(8.0):Container(),
                          Container(
                            child: Wrap(

                              children: [
                                  Card(
                                    elevation: 0,
                                    color: HexColor('#F6F8F9'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 6,bottom: 6),
                                      child: Text(widget.screenType=="search"?widget.searchData!.mcName.toString():DescriptionScreenData.moduleDetailsForAppData!.mcName??"", style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fontFamilyText,
                                        color: colorShadowBlue,
                                        fontWeight: fontWeight400,

                                      ),),
                                    ),
                                  ),


                              ],
                            ),
                          ),
                          sizedboxheight(10.0),
                          Text(widget.screenType=="search"?widget.searchData!.mdSummary.toString():DescriptionScreenData.moduleDetailsForAppData!.mdSummary??"", style: TextStyle(
                            fontSize: 16,height: 1.5,
                            fontFamily: fontFamilyText,
                            color: HexColor('#3B4250'),
                            fontWeight: fontWeight400,
                          ),),

                          sizedboxheight(10.0),

                          InkWell(
                            onTap: (){
                              setState(() {

                                DescriptionScreenData.buttonTypeFunction('Start Module');
                                // buttonType = 'Start Module';
                              });
                            },
                            child: Container(
                              height: 50,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: DescriptionScreenData.buttonType == 'Start Module'?
                                HexColor('#F6F8F9'):colorWhite,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    DescriptionScreenData.customerModuleViewStatusData == null?
                                    SvgPicture.asset('assets/image/play-circle 1.svg',
                                        color: colorPrimaryColor):Container(),
                                    DescriptionScreenData.customerModuleViewStatusData != null?
                                    DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 1?
                                    SvgPicture.asset('assets/image/play-circle 1.svg',
                                      color: colorPrimaryColor):Container():Container(),
                                    DescriptionScreenData.customerModuleViewStatusData != null?
                                    DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 2?
                                    SvgPicture.asset('assets/image/learnCompleteIcon.svg',
                                      color: colorShadowBlue,):Container():Container(),
                                    DescriptionScreenData.customerModuleViewStatusData != null?
                                    DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 3?
                                    SvgPicture.asset('assets/image/learnCompleteIcon.svg',
                                      color: colorShadowBlue,):Container():Container(),
                                 sizedboxwidth(10.0),
                                    Text("Learn",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: fontFamilyText,
                                        color: DescriptionScreenData.buttonType == 'Start Module'?
                                        colorPrimaryColor:colorShadowBlue,
                                        fontWeight: fontWeight600,
                                      ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          sizedboxheight(10.0),
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 2 ||DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 3){
                                  DescriptionScreenData.buttonTypeFunction('Start Applying');
                                }
                                else{
                                  FlutterToast_message('The apply section gets unlocked once the learning is completed');
                                }
                               // buttonType = 'Start Applying';
                              });
                            },
                            child: Container(
                              height: 50,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: DescriptionScreenData.buttonType == 'Start Applying'?
                                HexColor('#F6F8F9'):colorWhite,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    DescriptionScreenData.customerModuleViewStatusData == null?
                                    SvgPicture.asset('assets/image/lock_icon.svg',
                                        color:colorShadowBlue):Container(),

                                    DescriptionScreenData.customerModuleViewStatusData != null?
                                    DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 2?
                                    SvgPicture.asset('assets/image/play-circle 1.svg',
                                        color: colorPrimaryColor):Container():Container(),

                                    DescriptionScreenData.customerModuleViewStatusData != null?
                                    DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 3?
                                    SvgPicture.asset('assets/image/learnCompleteIcon.svg',
                                      color: colorShadowBlue,):Container():Container(),

                                    DescriptionScreenData.customerModuleViewStatusData != null?
                                    DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 1?
                                    SvgPicture.asset('assets/image/lock_icon.svg',
                                        color:colorShadowBlue):Container():Container(),

                                    sizedboxwidth(10.0),
                                    Text("Apply",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: fontFamilyText,
                                        color:DescriptionScreenData.buttonType == 'Start Applying'?
                                        colorPrimaryColor:colorShadowBlue,
                                        fontWeight: fontWeight400,
                                      ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          sizedboxheight(10.0),

                          start_learning_Btn(context),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  /// start learning button //////////////////

  Widget start_learning_Btn(context) {
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context,listen: false);
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context,listen: false);
    final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);

    return Container(

    alignment: Alignment.center,
      child: Button(
        buttonName: DescriptionScreenData.buttonType,
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnHeight: 55,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        btnColor: DescriptionScreenData.buttonType!.isEmpty?colorDisabledButton:colorBluePigment,
        borderColor: DescriptionScreenData.buttonType!.isEmpty?colorDisabledButton:colorBluePigment,
        onPressed: () {
          print("status check 0 ${DescriptionScreenData.customerModuleViewStatusData}");

         if(modulesProviderData.learningStatus == 'Start Learning'||(widget.screenType=="search"?widget.searchData!.mdTitle.toString():DescriptionScreenData.moduleDetailsForAppData!.mdTitle??"")=='Get Started'){
           if(DescriptionScreenData.buttonType!.isNotEmpty){
             if(DescriptionScreenData.buttonType == 'Start Module'){
               Get.to(()=> Learning_Screens(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString()));
               DescriptionScreenData.pageLearnIndexFunction(0);
               DescriptionScreenData.modulePagesContentList_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString(),"1");
               print("status check 1 ${DescriptionScreenData.customerModuleViewStatusData}");
               if (DescriptionScreenData.customerModuleViewStatusData == null){
                 DescriptionScreenData.updateCustomerModuleViewStatus_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString(),'1');
               }

             }else if(DescriptionScreenData.buttonType == 'Start Applying'){
               //  Navigator.push(context, MaterialPageRoute(builder: (_)=>ApplyingScreen(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleData!.mdId.toString())));

               BottomNavBarProviderModel.barHideScreenFunction(false);
               BottomNavBarProviderModel.applyScreenFunction(true);

               // Get.to(()=> ApplyingScreen(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleData!.mdId.toString()));
               DescriptionScreenData.pageApplyIndexFunction(0);
               DescriptionScreenData.modulePagesContentList_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString(),"2");
               PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                 context,
                 settings: const RouteSettings(name: "/Recipes_Screen"),
                 screen:  ApplyingScreen(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString()),
               );
             }else if(DescriptionScreenData.buttonType == 'Back to Modules'){
               // Navigator.pop(context);
               if(widget.screenName == "Home"){
                 Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(1,context);
               }
               else{
                 Navigator.pop(context);
               }
             }
           }else{}
         }else{
           if(SharedPrefHelper.subscriptionStatus){
             if(DescriptionScreenData.buttonType!.isNotEmpty){
               if(DescriptionScreenData.buttonType == 'Start Module'){
                 Get.to(()=> Learning_Screens(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString()));
                 DescriptionScreenData.pageLearnIndexFunction(0);
                 DescriptionScreenData.modulePagesContentList_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString(),"1");
                 print("status check 1 ${DescriptionScreenData.customerModuleViewStatusData}");
                 if (DescriptionScreenData.customerModuleViewStatusData == null){
                   DescriptionScreenData.updateCustomerModuleViewStatus_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString(),'1');
                 }

               }else if(DescriptionScreenData.buttonType == 'Start Applying'){
                 //  Navigator.push(context, MaterialPageRoute(builder: (_)=>ApplyingScreen(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleData!.mdId.toString())));

                 BottomNavBarProviderModel.barHideScreenFunction(false);
                 BottomNavBarProviderModel.applyScreenFunction(true);

                 // Get.to(()=> ApplyingScreen(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleData!.mdId.toString()));
                 DescriptionScreenData.pageApplyIndexFunction(0);
                 DescriptionScreenData.modulePagesContentList_api(widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString(),"2");
                 PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                   context,
                   settings: const RouteSettings(name: "/Recipes_Screen"),
                   screen:  ApplyingScreen(mdId:widget.screenType=="search"?widget.searchData!.mdId.toString():widget.moduleId.toString()),
                 );
               }else if(DescriptionScreenData.buttonType == 'Back to Modules'){
                 // Navigator.pop(context);
                 if(widget.screenName == "Home"){
                   Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(1,context);
                 }
                 else{
                   Navigator.pop(context);
                 }
               }
             }else{}
           }
          else if(DescriptionScreenData.buttonType == 'Back to Modules'){
             // Navigator.pop(context);
             if(widget.screenName == "Home"){
               Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(1,context);
             }
             else{
               Navigator.pop(context);
             }
           }
           else{
             showSubscriptionPopup(context);
           }


         }



         // Navigator.pop(context);
          // (context as Element).reassemble();
        },
      ),
    );
  }

}
