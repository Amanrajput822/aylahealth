import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../../../common/formtextfield/mytextfield.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../common/styles/const.dart';
import '../modules_search_bar/modulesSearchBar.dart';
import '../module_description_screen/module_description_screen.dart';
import 'modules_screen_provider.dart';

class Modules_Screen extends StatefulWidget {
  const Modules_Screen({Key? key}) : super(key: key);

  @override
  State<Modules_Screen> createState() => _Modules_ScreenState();
}

class _Modules_ScreenState extends State<Modules_Screen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);
    modulesProviderData.get_moduleLibrary_api();
  //  modulesProviderData.continueLearningModuleList_api();
    modulesProviderData.freeModuleList_api();
  }
  @override
  Widget build(BuildContext context) {
    final modulesProviderData = Provider.of<ModulesScreenProvider>(context);

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: _appbar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 50,
                  child: search_field()).paddingOnly(left: 15,right: 15),
              sizedboxheight(15.0),


              sizedboxheight(15.0),
              headingtile(modulesProviderData.learningStatus).paddingOnly(left: 15,right: 15),
              sizedboxheight(15.0),
              modulesProviderData.loading1
                  ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ): continue_learning(
                (modulesProviderData.freeModuleListData != null && modulesProviderData.freeModuleListData!.isNotEmpty)
                    ? modulesProviderData.freeModuleListData!
                    : (modulesProviderData.continueLearningModuleListData != null && modulesProviderData.continueLearningModuleListData!.isNotEmpty)
                    ? modulesProviderData.continueLearningModuleListData!
                    : [],
              ).paddingOnly(left: 15, right: 15),
              // continue_learning(modulesProviderData.freeModuleListData != null && modulesProviderData.freeModuleListData!.isNotEmpty
              //     ?modulesProviderData.freeModuleListData!:modulesProviderData.continueLearningModuleListData!).paddingOnly(left: 15,right: 15),
              // headingtile('Recommended for You').paddingOnly(left: 15,right: 15),
              // sizedboxheight(15.0),
              // recommended_list().paddingOnly(left: 15,right: 15),
              headingtile('Module Library').paddingOnly(left: 15,right: 15,top: 10),
              sizedboxheight(15.0),
              modulesProviderData.loading
                  ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ): module_library_list(),

              sizedboxheight(70.0),
            ],
          ),
        ),
      ),
    );
  }
  /// appbar ///

  AppBar _appbar(){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text('Modules',
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Playfair Display',
            color: colorPrimaryColor,
            fontWeight: fontWeight500,
            overflow: TextOverflow.ellipsis
        ),),


      backgroundColor: colorWhite,
    );
  }
  /// search_field ////////////////
  Widget search_field() {

    return  InkWell(
      onTap: (){
        Get.to(()=>const ModulesSearchBar());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorDisabledTextField,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: SvgPicture.asset(
                'assets/Search.svg',
                color: colorShadowBlue,
              ),
            ),
            Text('Search',
              style: TextStyle(
              fontSize: 16,
                fontFamily: fontFamilyText,
                fontWeight: fontWeight400,
                color: colorShadowBlue
            ),)
          ],
        ),
      ),
    );
  }


  /// heading function
  Widget headingtile(headingtext){
    return Container(
      width: deviceWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: deviceWidth(context,0.9),
            child: Text(headingtext,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight600,
                  overflow: TextOverflow.ellipsis
              ),),
          ),
         // const Icon(Icons.arrow_forward_ios_rounded,size: 18,)
        ],
      ),

    );
  }

  Widget continue_learning(continueLearningModuleListData){
  //  final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);

    return  Container(
      height: continueLearningModuleListData!.isEmpty?80:170,
      child: continueLearningModuleListData!.isEmpty?Container(
        child: Center(
          child: Text("When you start a module and don’t complete it, it will be shown here. Start a module now!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontFamily: fontFamilyText,
              color: colorgrey,
              fontWeight: fontWeight400,

          ),),
        ),
      ) : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: continueLearningModuleListData!.length,
          itemBuilder: (BuildContext context, int index){
            var continueLearningData = continueLearningModuleListData![index];
            return Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
              child: InkWell(
               onTap: (){
                 // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                 //   context,
                 //   settings: const RouteSettings(name: "/Modules"),
                 //   screen:  const ModuleDescriptionScreen(),
                 // );
                 PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                   context,
                   settings: const RouteSettings(name: "/Modules"),
                   screen:   ModuleDescriptionScreen(

                       moduleId:continueLearningData.mdId.toString(),
                     screenType:"module"
                   ),
                 );
               },

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                  ),

                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 500/357,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image:  DecorationImage(
                                fit: BoxFit.fill,
                               // image: AssetImage('assets/Screen Shot 2022-12-16 at 9.39 2.png')
                                image: NetworkImage(continueLearningData.image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=")
                            ),

                          ),
                        //  width: deviceWidth(context,0.68),
                         // height: 155,
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 500/357,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient:  LinearGradient(
                                  colors: [
                                    HexColor('#3B4250').withOpacity(0.6),
                                    HexColor('#3B4250').withOpacity(0.0),
                                  ],
                                  begin: FractionalOffset.bottomCenter,
                                  end: FractionalOffset.topCenter,
                                stops: [0.0, 0.35], // Apply the gradient to only the bottom 30%
                                tileMode: TileMode.clamp,
                              )
                          ),
                         // width: deviceWidth(context,0.68),
                        //  height: 155,
                          padding: const EdgeInsets.only(bottom: 10,left: 18),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(continueLearningData.mdTitle??"",style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontFamilyText,
                                color: colorWhite,
                                fontWeight: fontWeight600,
                                overflow: TextOverflow.ellipsis
                            ),maxLines: 2,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );

          }),
    );

  }


  Widget module_library_list(){
    final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);

    return Container(

      child: (modulesProviderData.moduleLibraryData == null || modulesProviderData.moduleLibraryData!.isEmpty)?Container(
        child: Center(
          child: Text("No module library",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: fontFamilyText,
              color: colorgrey,
              fontWeight: fontWeight400,

            ),),
        ),
      ) :ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: modulesProviderData.moduleLibraryData!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){

           var moduleLibraryListData = modulesProviderData.moduleLibraryData![index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: ExpansionTile(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  backgroundColor: HexColor('#E9ECF1'),
                  collapsedBackgroundColor: HexColor('#E9ECF1'),
                  trailing:  CircleAvatar(
                    backgroundColor: moduleLibraryListData.iconColor!?HexColor('#3B4250'):colorWhite,
                    radius: 15,
                    child: moduleLibraryListData.iconColor!?Icon(Icons.clear,color:colorWhite,size: 20,):Icon(Icons.add,color: HexColor('#3B4250'),size: 20,),
                  ),
                  title: Text(moduleLibraryListData.mcName!,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: HexColor('#3B4250'),
                        fontWeight: fontWeight400,
                        overflow: TextOverflow.ellipsis
                    ),),
                  onExpansionChanged: (value){
                    setState(() {
                     // modulesProviderData.IconColor(value);
                      moduleLibraryListData.iconColor = value;
                    });

                  },
                  // Contents
                  children: [
                    Container(
                      color: colorWhite,
                      child:moduleLibraryListData.subCategory!.isEmpty?
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('The content for this section is being prepared and we will notify you as it gets added.',
                           textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontFamilyText,
                                color: colorgrey,
                                fontWeight: fontWeight600,

                            ),),
                        ),):
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: moduleLibraryListData.subCategory!.length,
                          itemBuilder: (BuildContext context,int index1){
                            var subCategoryData = moduleLibraryListData.subCategory![index1];
                            return Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                              child: ExpansionTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                collapsedShape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ) ,
                                backgroundColor: HexColor('#E9ECF1'),
                                collapsedBackgroundColor: HexColor('#E9ECF1'),
                                iconColor:  HexColor('#3B4250'),
                                title: Text(subCategoryData.mscName!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fontFamilyText,
                                      color: HexColor('#3B4250'),
                                      fontWeight: fontWeight600,
                                      overflow: TextOverflow.ellipsis
                                  ),),
                                // Contents
                                children: [
                                  subCategoryData.moduleData!.isEmpty?
                                  Container(
                                    color: colorWhite,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text('The content for this section is being prepared and we will notify you as it gets added.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: fontFamilyText,
                                          color: colorgrey,
                                          fontWeight: fontWeight600,

                                        ),),
                                    ),): Container(
                                    color: colorWhite,
                                    child:  ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: subCategoryData.moduleData!.length,
                                        itemBuilder: (BuildContext context,int index2){
                                         var moduleListData = subCategoryData.moduleData![index2];
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                            child:  InkWell(
                                              onTap: (){
                                                if(modulesProviderData.learningStatus == 'Start Learning'){
                                                  FlutterToast_message('Before starting a module, please complete the Get Started module.');
                                                }
                                                else if(modulesProviderData.learningStatus == 'Continue Learning')
                                                {
                                                  modulesProviderData.updateCmvsStatus(moduleListData.mdId!, moduleListData.cmvsStatus == null?1:moduleListData.cmvsStatus!);
                                                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                                    context,
                                                    settings: const RouteSettings(name: "/Modules"),
                                                    screen:   ModuleDescriptionScreen(
                                                        moduleId:moduleListData.mdId.toString(),
                                                        screenType:"module"
                                                    ),
                                                  );
                                                }
                                              else {
                                                  modulesProviderData.updateCmvsStatus(moduleListData.mdId!, moduleListData.cmvsStatus == null?1:moduleListData.cmvsStatus!);
                                                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                                    context,
                                                    settings: const RouteSettings(name: "/Modules"),
                                                    screen:   ModuleDescriptionScreen(
                                                        moduleId:moduleListData.mdId.toString(),
                                                        screenType:"module"
                                                    ),
                                                  );
                                                }

                                              },
                                              child: Container(
                                                width: deviceWidth(context),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Row(
                                                    children: [
                                                      moduleListData.cmvsStatus == 3?
                                                      SvgPicture.asset('assets/image/learnCompleteIcon.svg')
                                                      :SvgPicture.asset('assets/image/play-circle 1.svg'),
                                                      sizedboxwidth(10.0),
                                                      Container(
                                                        width: deviceWidth(context,0.7),
                                                        child: Text(moduleListData.mdTitle!,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: fontFamilyText,
                                                              color: HexColor('#3B4250'),
                                                              fontWeight: fontWeight400,
                                                              overflow: TextOverflow.ellipsis
                                                          ),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        })

                                    // Column(
                                    //   children: [
                                    //     Container(
                                    //      width: deviceWidth(context),
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.all(15.0),
                                    //         child: Row(
                                    //           children: [
                                    //             SvgPicture.asset('assets/image/play-circle 1.svg'),
                                    //            sizedboxwidth(10.0),
                                    //             Container(
                                    //               width: deviceWidth(context,0.7),
                                    //               child: Text('True Healthy Eating',
                                    //                 style: TextStyle(
                                    //                     fontSize: 16,
                                    //                     fontFamily: fontFamilyText,
                                    //                     color: HexColor('#3B4250'),
                                    //                     fontWeight: fontWeight400,
                                    //                     overflow: TextOverflow.ellipsis
                                    //                 ),),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Container(
                                    //       width: deviceWidth(context),
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.all(15.0),
                                    //         child: Row(
                                    //           children: [
                                    //             SvgPicture.asset('assets/image/lock_icon.svg'),
                                    //             sizedboxwidth(10.0),
                                    //             Container(
                                    //               width: deviceWidth(context,0.7),
                                    //               child: Text('Fad Diets vs Healthy Eating',
                                    //                 style: TextStyle(
                                    //                     fontSize: 16,
                                    //                     fontFamily: fontFamilyText,
                                    //                     color: colorShadowBlue,
                                    //                     fontWeight: fontWeight400,
                                    //                     overflow: TextOverflow.ellipsis
                                    //                 ),),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //
                                    //   ],
                                    // ),
                                  )


                                ],
                              ),
                            );
                          }),
                    )

                  ],
                ),
              ),
            );

          }),
    );
  }
}
