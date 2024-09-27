import 'package:custom_cupertino_picker/custom_cupertino_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../../../../../common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import '../../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../../common/styles/const.dart';
import '../../../../../models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import '../../../my_meals/My_Meals_Provider.dart';
import '../../../my_meals/calendar_evryday_json.dart';
import '../../../recipes screens/recipe_description/recipes_description_screen.dart';
import '../../../recipes screens/recipe_screen/RecipeData_Provider.dart';
import '../../modules_screen/modules_screen_provider.dart';
import '../ModuleDescriptionProvider.dart';
import '../vimeoPlayerScreen.dart';
import 'complete_applying_screen.dart';

class ApplyingScreen extends StatefulWidget {
   String? mdId;
   ApplyingScreen({Key? key, this.mdId}) : super(key: key);

  @override
  State<ApplyingScreen> createState() => _ApplyingScreenState();
}

class _ApplyingScreenState extends State<ApplyingScreen> {
  final ScrollController _scrollController = ScrollController();
 // final PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    mealsModel.get_meals_plantypelist_api();

  }


  String getVimeoId(String url) {
    final regex = RegExp(r"vimeo\.com/(?:video/)?([0-9]+)");
    final match = regex.firstMatch(url);
    return match?.group(1)?? "";
  }

  @override
  Widget build(BuildContext context) {
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context);
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context);

    return Container(
      color: colorWhite,
      width: deviceWidth(context),
      height: deviceheight(context),
      child: SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: () async{
            print('aaa${DescriptionScreenData.pageApplyIndex != 0}');
            if(DescriptionScreenData.pageApplyIndex != 0){
              setState(() {
              //  DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex-1);
              });
              DescriptionScreenData.pageController.animateToPage(
                DescriptionScreenData.pageApplyIndex - 1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }else{

              BottomNavBarProviderModel.barHideScreenFunction(true);
              BottomNavBarProviderModel.applyScreenFunction(false);
              Navigator.pop(context);

            }


            return false; // return true if the route to be popped
          },

          child: Scaffold(
            backgroundColor: colorWhite,
            body: DescriptionScreenData.loading?Container(
                width: deviceWidth(context),
                height: deviceheight(context),
                child: Center(child: CircularProgressIndicator())):
            Container(
              height: deviceheight(context),
              width: deviceWidth(context),
              child: DescriptionScreenData.modulePagesContentListData!.isNotEmpty?
              PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: DescriptionScreenData.pageController,
                itemCount: DescriptionScreenData.modulePagesContentListData!.length,
                itemBuilder: (context, index) {
                  final pageData = DescriptionScreenData.modulePagesContentListData![index];
                  return _buildPageContent(context, pageData, index);
                },
                onPageChanged: (index) {
                  DescriptionScreenData.pageApplyIndexFunction(index);
                },
              )
                  : _buildNoDataContent(context),
            ),
          ),
        ),
      ),
    );
  }

  /// next button //////////////////

  Widget Next_Btn(context,DescriptionScreenData) {
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: DescriptionScreenData.modulePagesContentListData.length-1 != DescriptionScreenData.pageApplyIndex?'Next':'Complete Module',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context)*0.89,
        btnHeight: 55,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        btnColor: colorBluePigment,
        borderColor: colorBluePigment,
        onPressed: () {

          setState(() {
            if(DescriptionScreenData.modulePagesContentListData.length-1 != DescriptionScreenData.pageApplyIndex )
            {
             // DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex+1);
              DescriptionScreenData.pageController.animateToPage(
                DescriptionScreenData.pageApplyIndex + 1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
            else{
              final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);
              final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);

              if (DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 2){
                DescriptionScreenData.updateCustomerModuleViewStatus_api(widget.mdId.toString(),'3');
                modulesProviderData.updateCmvsStatus(int.parse(widget.mdId.toString()), 3);
              }
              DescriptionScreenData.buttonTypeFunction('Back to Modules');
              setState(() {
                BottomNavBarProviderModel.barHideScreenFunction(true);
                BottomNavBarProviderModel.applyScreenFunction(false);
              });
              Navigator.pop(context);

            }
            print('pageIndex:${DescriptionScreenData.pageApplyIndex}');
            // print(screenNumber);
            // if(screenNumber == 1){
            //   screenNumber = 2;
            // }else if(screenNumber==2){
            //   screenNumber =3;
            // }
            // else if(screenNumber==3){
            //  Get.to(()=>const CompleteApplyingScreen());
            //
            // }
          });
         // _scrollToTop();
        },
      ),
    );
  }
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }


  Widget _buildPageContent(BuildContext context,  pageData, int index) {
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context);
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);

    return SingleChildScrollView(
      controller: _scrollController,
      physics: ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent != null ?
          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcMedia != null ?
          Container(

            // height: deviceheight(context,0.25),
            // width: deviceWidth(context),
            color: colorgrey,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio:DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcMediaType == 0?
                  500/357:630/357,
                  child: Container(
                    // height: deviceheight(context,0.25),
                    // width: deviceWidth(context),
                    child: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcMediaType == 0?
                    // Image.network(DescriptionScreenData.modulePagesContentListData![pageIndex].modulePageContent!.mpcMedia??"",
                    //   fit: BoxFit.fill,
                    //
                    // )
                    Image.network(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcMedia??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",fit: BoxFit.fill,
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
                      },
                    )
                        :Container(
                      //       height: deviceheight(context,0.25),
                      // width: deviceWidth(context),
                      child: VimeoVideoPlayerScreen(videoId:getVimeoId(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcMedia!)),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio:DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcMediaType == 0?
                  500/357:630/357,
                  child: Container(
                    // height: deviceheight(context,0.25),
                    // width: deviceWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: (){
                                print('aaa${DescriptionScreenData.pageApplyIndex != 0}');
                                if(DescriptionScreenData.pageApplyIndex != 0){
                                  setState(() {
                                  //  DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex-1);
                                  });
                                  DescriptionScreenData.pageController.animateToPage(
                                    DescriptionScreenData.pageApplyIndex - 1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }else{
                                  setState(() {
                                    BottomNavBarProviderModel.barHideScreenFunction(true);
                                    BottomNavBarProviderModel.applyScreenFunction(false);
                                  });
                                  Navigator.pop(context);

                                }

                              },
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 12.5,
                                  child: SvgPicture.asset('assets/backbutton.svg',color: colorBluePigment,height: 13,))),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              : Container(

            height: 40,
            width: deviceWidth(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  InkWell(
                      onTap: (){
                        print('bbb${DescriptionScreenData.pageApplyIndex != 0}');
                        if(DescriptionScreenData.pageApplyIndex != 0){
                          setState(() {
                           // DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex-1);
                          });
                          DescriptionScreenData.pageController.animateToPage(
                            DescriptionScreenData.pageApplyIndex - 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }else{
                          setState(() {
                            BottomNavBarProviderModel.barHideScreenFunction(true);
                            BottomNavBarProviderModel.applyScreenFunction(false);
                          });
                          Navigator.pop(context);
                        }

                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12.5,
                          child: SvgPicture.asset('assets/backbutton.svg',color: colorBluePigment,height: 13,))),

                ],
              ),
            ),
          ):
          Container(

            height: 40,
            width: deviceWidth(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  InkWell(
                      onTap: (){
                        print('bbb${DescriptionScreenData.pageApplyIndex != 0}');
                        if(DescriptionScreenData.pageApplyIndex != 0){
                          setState(() {
                          //  DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex-1);
                          });
                          DescriptionScreenData.pageController.animateToPage(
                            DescriptionScreenData.pageApplyIndex - 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }else{
                          setState(() {
                            BottomNavBarProviderModel.barHideScreenFunction(true);
                            BottomNavBarProviderModel.applyScreenFunction(false);
                          });
                          Navigator.pop(context);
                        }

                      },
                      child:CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12.5,
                          child: SvgPicture.asset('assets/backbutton.svg',color: colorBluePigment,height: 13,))),

                ],
              ),
            ),

          ),

          Container(

            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20),                              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].mpTitle??"",
                  style: TextStyle(
                    fontSize: 27,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight600,
                  ),),

                //  sizedboxheight(10.0),
                // Text(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcMedia!.split("?")[0].replaceAll("https://vimeo.com/", "")),

                //  sizedboxheight(10.0),
                DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent != null?
                Html(
                  data: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].modulePageContent!.mpcDetailHtml??"",
                  style: {
                    "span": Style(
                      fontSize: FontSize(16.0),
                      fontWeight: fontWeight400,
                      color: HexColor('#3B4250'),
                      fontFamily: fontFamilyText,
                    ),
                  },

                ):Container(),
              ],
            ),
            ),
          ),

          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].detailsData!.isNotEmpty?sizedboxheight(10.0):Container(),

          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].detailsData!.isNotEmpty? Container(
            width: deviceWidth(context),
            padding: const EdgeInsets.only(left: 20,right: 20),

            child: ListView.builder(
                itemCount: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].detailsData!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,int index){
                  var detailsData = DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].detailsData![index];
                  final GlobalKey expansionTileKey = GlobalKey();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ExpansionTile(
                      key: expansionTileKey,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      collapsedShape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ) ,
                      backgroundColor: HexColor('#E9ECF1'),
                      collapsedBackgroundColor: HexColor('#E9ECF1'),

                      iconColor:  HexColor('#3B4250'),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].detailsData!.length == 1?
                          //
                          // Container():Text('${index + 1}. ', style: TextStyle(
                          //     fontSize: 16,
                          //     fontFamily: fontFamilyText,
                          //     color: HexColor('#3B4250'),
                          //     // height: 1.6,
                          //     fontWeight: fontWeight600,
                          //     overflow: TextOverflow.ellipsis
                          // )),

                          Container(
                            width: deviceWidth(context,0.6),
                            child: Text(detailsData.mpdTitle??"",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: HexColor('#3B4250'),
                                  // height: 1.6,
                                  fontWeight: fontWeight600,
                                  overflow: TextOverflow.ellipsis
                              ),maxLines: 2,),
                          ),
                        ],
                      ),
                      // Contents
                      children: [
                        Container(
                          color: colorWhite,
                          width: deviceWidth(context),
                          child:Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(detailsData.mpdText??"",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamilyText,
                                color: HexColor('#3B4250'),
                                height: 1.6,
                                fontWeight: fontWeight400,

                              ),
                            ),
                          ),
                        )


                      ],
                    ),
                  );
                }),
          ): Container(),
          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].imagesData!.isNotEmpty?
          Container(

            // width: deviceWidth(context),
            // height: deviceheight(context)*0.6,
              padding: const EdgeInsets.only(left: 20.0,right: 20),

              // child: Image.network(DescriptionScreenData.modulePagesContentListData![pageIndex].imagesData![0].mpiName??""),
              child:  Container(
                child: Image.network(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].imagesData![0].mpiName??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                  fit: BoxFit.fill,
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
                  },
                ),
              )

          ):Container(),
          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].tagedRecipe!.isNotEmpty?
          Container(
              color: HexColor('#F6F7FB'),
              padding: EdgeInsets.only(left: 15,right: 15,top: 20),
              //height: 500,
              // child: CompleteApplyingScreen(recipeListData:DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].tagedRecipe,selectedRecipeCategory:_selectedRecipeCategory))
              child: recipesItemListViewSuggested(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageApplyIndex].tagedRecipe)

          )
              :Container(),
          sizedboxheight(10.0),
          Padding(
            padding:  EdgeInsets.only(left: deviceWidth(context)*0.05,right:deviceWidth(context)*0.05 ),
            child: Next_Btn(context,DescriptionScreenData),
          ),
          sizedboxheight(50.0)
        ],
      ),
    );
  }

  Widget _buildNoDataContent(BuildContext context) {
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context);
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                        setState(() {
                          BottomNavBarProviderModel.barHideScreenFunction(true);
                          BottomNavBarProviderModel.applyScreenFunction(false);
                        });
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
          Text('No Data'),
          Padding(
            padding:  EdgeInsets.only(left: deviceWidth(context)*0.05,right:deviceWidth(context)*0.05 ),
            child: Next_Btn(context,DescriptionScreenData),
          ),
        ],
      ),
    );
  }
  /// recipes_itam_listview for Suggested ///////////

  Widget recipesItemListViewSuggested(recipeListData){
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);

    return recipeListData!.isEmpty?SizedBox(
      width: deviceWidth(context),
      height: deviceheight(context,0.4),

      child:
      Align(
          alignment: Alignment.topCenter,
          child:Text('No Recipe Found', style: TextStyle(fontFamily: fontFamilyText ,fontSize: 16),
            textAlign: TextAlign.center,)).paddingOnly(left: 20,right: 20),) :

    DescriptionScreenData.loading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      // controller: recipeModel.controller,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: (recipeListData!.length % 2 == 0 ? recipeListData!.length ~/ 2 : recipeListData!.length ~/ 2 + 1),
      // itemCount: recipe_data_List!.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.green,
                    borderRadius: BorderRadius.circular(5)
                ),
                margin:  EdgeInsets.all(1.0),
                width: deviceWidth(context,0.44),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {

                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: "/Recipes_Screen"),
                          screen:  Recipes_Description_Screen(
                              rec_id:recipeListData![index * 2].recId,
                              rec_index:index * 2,
                              txt_search:'',
                              fav_filter:'0',
                              screen:"Notification"
                          ),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 7/5,
                        child: Container(
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 7/5,
                                child: Container(

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(recipeListData![index * 2].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                      height: 110,width: deviceWidth(context),fit: BoxFit.fill,
                                      errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=", width:deviceWidth(context,0.4) ,
                                        height: 110,
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
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(recipeListData![index * 2].favStatus == 0){
                                        recipeListData![index * 2].favStatus = 1;
                                        DescriptionScreenData.likeRecipeData1(context,recipeListData![index * 2].recId);
                                      }
                                      else if(recipeListData![index * 2].favStatus == 1){
                                        recipeListData![index * 2].favStatus = 0;
                                        DescriptionScreenData.unlikeRecipeData1(context,recipeListData![index * 2].recId);
                                        // if(recipeModel.fav_filter =='1'){
                                        //   recipeModel.getRecipeData(context,recipeModel.txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                                        // }
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 40,width: 40,
                                    alignment: Alignment.topRight,
                                    child:recipeListData![index * 2].favStatus == 1?Center(child: SvgPicture.asset('assets/image/Heart_lick.svg')): Center(child: SvgPicture.asset('assets/image/Heart_unlick.svg')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    sizedboxheight(10.0),
                    InkWell(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: "/Recipes_Screen"),
                          screen:  Recipes_Description_Screen(rec_id:recipeListData![index * 2].recId,rec_index:index * 2,txt_search:'',fav_filter:'0', screen:"Notification"),
                        );
                      },
                      child: Text(recipeListData![index * 2].recTitle??"",style:TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: HexColor('#3B4250'),
                        fontWeight: fontWeight600,
                        height: 1.3,
                        overflow: TextOverflow.ellipsis,
                      ) ,maxLines: 2,),
                    ),
                    sizedboxheight(5.0),
                    InkWell(
                      onTap: (){
                        if(recipeModel.meals_screen){
                          print(recipeModel.select_mealplanID_recipe.toString());

                        }else{
                          mealsModel.singleDayMeals_change(false);
                          recipeModel.selectedDay_data(DateTime.now());
                          recipeModel.selectedDate_string(null);
                          recipeModel.meal_plan_id_select_fuction_recipe(null);
                        }
                        add_meals_bottom_sheet_Suggested(recipeListData!,(index * 2));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/image/plus-circle .svg'),

                          sizedboxwidth(5.0),
                          Container(
                            width: deviceWidth(context,0.35),
                            child: Text('Add to my meals',style:TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamilyText,
                                color: HexColor('#79879C'),
                                fontWeight: fontWeight400,
                                height: 1.5,
                                overflow: TextOverflow.ellipsis
                            )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            if (index * 2 +1 < recipeListData!.length)

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  margin:  EdgeInsets.all(1.0),
                  width: deviceWidth(context,0.44),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: const RouteSettings(name: "/Recipes_Screen"),
                            screen:  Recipes_Description_Screen(rec_id:recipeListData![index * 2 + 1].recId,rec_index:index * 2+1,txt_search:'',fav_filter:'0', screen:"Notification"),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 7/5,
                          child: Container(
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 7/5,
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(recipeListData![index * 2 + 1].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                        height: 110,width: deviceWidth(context),fit: BoxFit.fill,
                                        errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=", width:deviceWidth(context,0.4) ,
                                          height: 110,
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
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        if(recipeListData![index * 2 + 1].favStatus == 0){
                                          recipeListData![index * 2 + 1].favStatus = 1;
                                          DescriptionScreenData.likeRecipeData1(context,recipeListData![index * 2 + 1].recId);
                                        }
                                        else if(recipeListData![index * 2 + 1].favStatus == 1){
                                          recipeListData![index * 2 + 1].favStatus = 0;
                                          DescriptionScreenData.unlikeRecipeData1(context,recipeListData![index * 2 + 1].recId);
                                          // if(recipeModel.fav_filter =='1'){
                                          //   recipeModel.getRecipeData(context,recipeModel.txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                                          // }
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 40,width: 40,
                                      alignment: Alignment.topRight,
                                      child:recipeListData![index * 2 + 1].favStatus == 1?Center(child: SvgPicture.asset('assets/image/Heart_lick.svg')): Center(child: SvgPicture.asset('assets/image/Heart_unlick.svg')),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      sizedboxheight(10.0),
                      InkWell(
                        onTap: () {


                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: const RouteSettings(name: "/Recipes_Screen"),
                            screen:  Recipes_Description_Screen(rec_id:recipeListData![index * 2 + 1].recId,rec_index:index * 2+1,txt_search:'',fav_filter:'0', screen:"Notification"),
                          );
                        },
                        child: Text(recipeListData![index * 2 + 1].recTitle??"",style:TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: HexColor('#3B4250'),
                            fontWeight: fontWeight600,
                            height: 1.3,
                            overflow: TextOverflow.ellipsis
                        ) ,maxLines: 2,),
                      ),
                      sizedboxheight(5.0),
                      InkWell(
                        onTap: (){
                          if(recipeModel.meals_screen){
                            print(recipeModel.select_mealplanID_recipe.toString());
                          }else{
                            mealsModel.singleDayMeals_change(false);
                            recipeModel.selectedDay_data(DateTime.now());
                            recipeModel.selectedDate_string(null);
                            recipeModel.meal_plan_id_select_fuction_recipe(null);
                          }
                          add_meals_bottom_sheet_Suggested(recipeListData!,(index * 2+1));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset('assets/image/plus-circle .svg'),

                            sizedboxwidth(5.0),
                            Container(
                              width: deviceWidth(context,0.35),
                              child: Text('Add to my meals',style:TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontFamilyText,
                                  color: HexColor('#79879C'),
                                  fontWeight: fontWeight400,
                                  height: 1.5,
                                  overflow: TextOverflow.ellipsis
                              )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  Future<void> add_meals_bottom_sheet_Suggested(recipe_data_List,index){
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isScrollControlled:true,
        backgroundColor: colorWhite,

        builder: (BuildContext context) {
          return Builder(
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, setState){
                      return Container(
                        // height: deviceheight(context,0.8),
                        child: Stack(
                          children: [
                            Container(
                              //  height: deviceheight(context,0.8),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15,bottom: 70),
                                child: SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: deviceWidth(context),
                                        height: 60,
                                        child: Center(
                                          child: Text('Add to My Meals',style:TextStyle(
                                              fontSize: 24,
                                              fontFamily: fontFamilyText,
                                              color: colorRichblack,
                                              fontWeight: fontWeight600,
                                              height: 1.5,
                                              overflow: TextOverflow.ellipsis
                                          )),
                                        ),
                                      ),
                                      sizedboxheight(deviceheight(context,0.01),),
                                      Container(
                                        height: 160,
                                        width: 260,

                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: NetworkImage(recipe_data_List[index].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE="),fit: BoxFit.fill
                                            )
                                        ),

                                      ),
                                      sizedboxheight(deviceheight(context,0.01),),
                                      Text(recipe_data_List[index].recTitle,style:TextStyle(
                                          fontSize: 16,
                                          fontFamily: fontFamilyText,
                                          color: colorRichblack,
                                          fontWeight: fontWeight400,
                                          height: 1.2,
                                          overflow: TextOverflow.ellipsis
                                      )),

                                      sizedboxheight(deviceheight(context,0.02),),
                                      InkWell(
                                          onTap: (){
                                            // _displayDialog( context);
                                            showBottomAlertDialogSuggested( context);
                                          },
                                          child: fieldContainerSuggested(recipeModel.selectedDate == null?'When do you want to eat this?':recipeModel.selectedDate.toString(),"Add to your calendar",recipeModel.selectedDate == null?1:0)
                                      ),
                                      sizedboxheight(deviceheight(context,0.02),),
                                      InkWell(
                                          onTap: (){
                                            _showPickerSuggested(context);
                                            //  recipeModel.meal_plan_id_select_fuction_recipe(mealsModel.get_meals_planlist_data![0].mtId.toString());

                                            //  _displayDialog( context);
                                          },
                                          child: fieldContainerSuggested(recipeModel.select_mealplanID_recipe == null?'At which meal will you eat this?':mealsModel.get_meals_planlist_data![int.parse(recipeModel.select_mealplanID_recipe!) -1].mtName.toString(),"Choose an eating occasion",recipeModel.select_mealplanID_recipe == null?'1':'0')
                                      ),
                                      sizedboxheight(deviceheight(context,0.02),),
                                      add_mymeals_Btn_Suggested(recipe_data_List[index].recId,recipe_data_List[index].recServes.toString()),
                                      sizedboxheight(deviceheight(context,0.01),),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      );
                    }
                );
              }
          );
        });
  }

  Widget fieldContainerSuggested(title,heading,showtype){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: HexColor('#F6F8F9')
      ),
      padding: EdgeInsets.all(15),
      width: deviceWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showtype==1? Text(heading,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: fontFamilyText,
                  color: HexColor('#3B4250'),
                  fontWeight: fontWeight400,
                ),
              ):Container(),
              showtype=='1'? Text(heading,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: fontFamilyText,
                  color: HexColor('#3B4250'),
                  fontWeight: fontWeight400,
                ),
              ):Container(),
              Text(title.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: fontFamilyText,
                  color: HexColor('#3B4250'),
                  fontWeight: fontWeight400,
                ),
              ),
            ],
          ),
          SvgPicture.asset('assets/image/chevron-down.svg',color: colorRichblack,)
        ],
      ),
    );
  }
  /// add meals button for Suggested /////////////

  Widget add_mymeals_Btn_Suggested(rec_id,String recServes) {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Add to my meals',
        textColor: colorWhite,

        btnfontsize: 20,
        btnfontweight: fontWeight400,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context,0.92),
        btnColor: colorEnabledButton,
        onPressed: () {
          if(recipeModel.select_mealplanID_recipe!=null){
            if(rec_id!=null){

              Navigator.pop(context);
              json_add_api_data_calendar_json_fuction(context,recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),recipeModel.selectedDay.day.toString(),[{"rec_id":rec_id.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":"","logged":"0","cust_serves":recServes??""}],int.parse(recipeModel.select_mealplanID_recipe.toString())-1);
            }
            else{
              FlutterToast_message('Add to your calendar');
            }
          }
          else{
            FlutterToast_message('Choose an eating occasion');
          }


          recipeModel.select_screen_data(false);
          mealsModel.singleDayMeals_change(false);
          mealsModel.get_meals_calendardata_api(context, recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),int.parse(recipeModel.select_mealplanID_recipe.toString())-1,"0",recipeModel.selectedDay);
        },
      ),
    );
  }

  /// add meals bottom sheet  for Suggested//////////////////////

  void showBottomAlertDialogSuggested(BuildContext context) {
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(16.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          padding: EdgeInsets.only(bottom: 10),
                          child: TableCalendar(
                            rowHeight: 35,
                            firstDay: DateTime(2022),
                            lastDay: DateTime(2050),
                            focusedDay:recipeModel.focusedDay,


                            startingDayOfWeek: StartingDayOfWeek.monday,
                            selectedDayPredicate: (day) => isSameDay(recipeModel.selectedDay, day),
                            calendarFormat: CalendarFormat.month,
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              weekendTextStyle: TextStyle(color: HexColor('#3B4250') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                              defaultTextStyle:TextStyle(color: HexColor('#3B4250') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                              disabledTextStyle:TextStyle(color: HexColor('#9E9E9E') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                              selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                              todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,),

                              selectedDecoration: BoxDecoration(shape: BoxShape.rectangle, color: colorBluePigment, borderRadius: BorderRadius.circular(5),),
                              defaultDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5),),
                              weekendDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                              disabledDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                              todayDecoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(5)),

                            ),


                            headerStyle: HeaderStyle(
                                titleCentered: true,
                                leftChevronMargin: EdgeInsets.only(left: 1),
                                leftChevronIcon: Icon(Icons.chevron_left,color: colorSlateGray,),
                                rightChevronIcon: Icon(Icons.chevron_right,color: colorSlateGray,),
                                rightChevronVisible: true,
                                // titleTextFormatter: (date, locale) => DateFormat.MMMM(locale).format(date),
                                formatButtonVisible : false,
                                formatButtonDecoration: BoxDecoration(

                                ),
                                titleTextStyle: TextStyle(
                                  color: colorRichblack,
                                  fontSize: 14,
                                  fontWeight: fontWeight600,
                                  fontFamily: fontFamilyText,
                                )
                            ),

                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                              weekendStyle:TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                            ),

                            onPageChanged: (focusedDay) {
                              setState(() {
                                recipeModel.focusedDay_data(focusedDay);

                              });
                            },

                            onDaySelected: (selectedDay, focusedDay) {
                              print(selectedDay.toString());
                              print(focusedDay.toString());
                              setState(() {
                                recipeModel.selectedDay_data(selectedDay);
                                recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(selectedDay));

                                Navigator.pop(context);

                                mealsModel.get_meals_calendardata_api(context, selectedDay.year.toString(),selectedDay.month.toString(),int.parse(recipeModel.select_mealplanID_recipe.toString())-1,"0",selectedDay);
                                //   mealsModel.get_meals_calendardata_multiple_months_api(context,selectedDay,int.parse(recipeModel.select_mealplanID_recipe.toString())-1);

                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }

  /// showPicker sheet  for Suggested//////////////////////
  void _showPickerSuggested(BuildContext ctx) {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    recipeModel.meal_plan_id_select_fuction_recipe(mealsModel.get_meals_planlist_data![0].mtId.toString());
    showCupertinoModalPopup(
        barrierDismissible:true,
        context: ctx,
        builder: (BuildContext bottomSheetContext) => Container(
          width: 250,
          height: 300,
          padding: EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
          ),
          child: Stack(
            children: [
              Container(

                decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: CustomCupertinoPicker(

                    highlighterBorder: Border(
                      top: BorderSide(
                        width: 0.5, color: HexColor('#BEBEBE'),
                      ),
                      bottom: BorderSide(
                        width: 0.5,  color: HexColor('#BEBEBE'),
                      ),
                    ),
                    highlighterBorderWidth: 80,
                    magnification:1.1,
                    scrollPhysics: const FixedExtentScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemExtent: 31.0,
                    useMagnifier: true,
                    squeeze: 1.0,diameterRatio: 1.5,

                    onSelectedItemChanged: (int value) {
                      print(value);
                      recipeModel.meal_plan_id_select_fuction_recipe(mealsModel.get_meals_planlist_data![value].mtId.toString());

                    },
                    children: mealsModel.get_meals_planlist_data!.map((item) {
                      return Text(
                        item.mtName??"",
                        style: TextStyle(fontSize: 16.0,
                            fontFamily: fontFamilyText,
                            fontWeight: fontWeight400,
                            color: colorRichblack
                        ),
                      );
                    }).toList()
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.clear_circled,
                    color: colorBluePigment, // Customize the color of the close icon
                    size: 25, // Adjust the icon size
                  ),
                  onPressed: () {
                    Navigator.of(bottomSheetContext).pop(); // Close the bottom sheet
                  },
                ),
              ),
            ],
          ),
        ));
  }

}
