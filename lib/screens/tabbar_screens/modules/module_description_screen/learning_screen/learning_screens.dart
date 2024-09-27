import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../ModuleDescriptionProvider.dart';
import '../vimeoPlayerScreen.dart';

class Learning_Screens extends StatefulWidget {
  String ? mdId;
  Learning_Screens({Key? key,this.mdId}) : super(key: key);

  @override
  State<Learning_Screens> createState() => _Learning_ScreensState();
}

class _Learning_ScreensState extends State<Learning_Screens> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();


  String getVimeoId(String url) {
    final regex = RegExp(r"vimeo\.com/(?:video/)?([0-9]+)");
    final match = regex.firstMatch(url);
    return match?.group(1)?? "";
  }


  @override
  Widget build(BuildContext context) {
    final descriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context);

    return Container(
      color: colorWhite,
      width: deviceWidth(context),
      height: deviceheight(context),
      child: SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: () async{
            print('aaa${descriptionScreenData.pageLearnIndex != 0}');
            if(descriptionScreenData.pageLearnIndex != 0){
              _pageController.animateToPage(
                descriptionScreenData.pageLearnIndex - 1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }else{
              Navigator.pop(context);
            }
            return false; // return true if the route to be popped
          },
          child: Scaffold(
            backgroundColor: colorWhite,
            body: descriptionScreenData.loading
                ? Center(child: CircularProgressIndicator())
                : descriptionScreenData.modulePagesContentListData!.isNotEmpty
                ? PageView.builder(

               physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: descriptionScreenData.modulePagesContentListData!.length,
              itemBuilder: (context, index) {
                final pageData = descriptionScreenData.modulePagesContentListData![index];
                return _buildPageContent(context, pageData, index);
              },
              onPageChanged: (index) {
                descriptionScreenData.pageLearnIndexFunction(index);
              },
            )
                : _buildNoDataContent(context),
          ),
        ),
      ),
    );
  }
  /// next button //////////////////

  Widget Next_Btn(context,DescriptionScreenData) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName:DescriptionScreenData.modulePagesContentListData!.isNotEmpty? (DescriptionScreenData.modulePagesContentListData.length-1 != DescriptionScreenData.pageLearnIndex?'Next':"Complete Learning"):"Complete Learning",
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
            if(DescriptionScreenData.modulePagesContentListData!.isEmpty){
              DescriptionScreenData.updateCustomerModuleViewStatus_api(widget.mdId.toString(),'2');
              Navigator.pop(context);
            }
            else{
              if(DescriptionScreenData.modulePagesContentListData.length-1 != DescriptionScreenData.pageLearnIndex )
              {
                _pageController.animateToPage(
                  DescriptionScreenData.pageLearnIndex + 1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
              else{
                final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);
                DescriptionScreenData.buttonTypeFunction('Start Applying');
                if (DescriptionScreenData.customerModuleViewStatusData!.cmvsStatus == 1){
                  DescriptionScreenData.updateCustomerModuleViewStatus_api(widget.mdId.toString(),'2');
                }

                Navigator.pop(context);

              }
              print('pageIndex:${DescriptionScreenData.pageLearnIndex}');
            }
            // _scrollToTop();
          });

          // final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);
          //  DescriptionScreenData.buttonTypeFunction('Start Applying');
          // Get.to(()=>Learning_Screens());
          //  Get.off(()=>ModuleDescriptionScreen());
          // Navigator.pop(context);
          // (context as Element).reassemble();
        },
      ),
    );
  }



  Widget _buildPageContent(BuildContext context,  pageData, int index) {
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context);

    return SingleChildScrollView(

      controller: _scrollController,
      physics: ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent == null||
              DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcMedia == null ?
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
                        print('bbb${DescriptionScreenData.pageLearnIndex != 0}');
                        if(DescriptionScreenData.pageLearnIndex != 0){
                          _pageController.animateToPage(
                            DescriptionScreenData.pageLearnIndex - 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );

                        }else{
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
          ): Container(


            color: colorgrey,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcMediaType == 0?
                  500/357:630/357,
                  child: Container(
                    // height: deviceheight(context,0.25),
                    // width: deviceWidth(context),
                    child: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcMediaType == 0?

                    Image.network(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcMedia??
                        "https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",fit: BoxFit.fill,
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
                      child: VimeoVideoPlayerScreen(videoId:getVimeoId(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcMedia!)),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcMediaType == 0?
                  500/357:630/357,
                  child: Container(

                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: (){
                                print('aaa${DescriptionScreenData.pageLearnIndex != 0}');
                                if(DescriptionScreenData.pageLearnIndex != 0){
                                  _pageController.animateToPage(
                                    DescriptionScreenData.pageLearnIndex - 1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }else{
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
          ),

          Container(
            //  color: colorgrey,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].mpTitle??"",
                    style: TextStyle(
                      fontSize: 27,
                      fontFamily: fontFamilyText,
                      color: colorRichblack,
                      fontWeight: fontWeight600,
                    ),),

                  //  sizedboxheight(10.0),
                  // Text(getVimeoId(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcMedia!)),


                  DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent != null?
                  Html(
                    data: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].modulePageContent!.mpcDetailHtml??"",
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

          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].detailsData!.isNotEmpty?sizedboxheight(10.0):Container(),

          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].detailsData!.isNotEmpty? Container(
            width: deviceWidth(context),

            padding: const EdgeInsets.only(left: 20,right: 20),
            child: ListView.builder(
                itemCount: DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].detailsData!.length,
                shrinkWrap: true,
                //controller: _scrollController,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,int index){
                  var detailsData = DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].detailsData![index];
                  final GlobalKey expansionTileKey = GlobalKey();
                  double? previousOffset;
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
                          // DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].detailsData!.length == 1?
                          // Container()
                          // :Text('${index + 1}. ', style: TextStyle(
                          //     fontSize: 16,
                          //     fontFamily: fontFamilyText,
                          //     color: HexColor('#3B4250'),
                          //     // height: 1.6,
                          //     fontWeight: fontWeight600,
                          //     overflow: TextOverflow.ellipsis
                          // )),
                          // sizedboxwidth(5.0),
                          Container(
                            width: deviceWidth(context,0.6),
                            child: Text(detailsData.mpdTitle??"",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: HexColor('#3B4250'),
                                  //height: 1.6,
                                  fontWeight: fontWeight600,
                                  overflow: TextOverflow.ellipsis
                              ),maxLines: 2,),
                          ),
                        ],
                      ),
                      // Contents
                      children: [
                        Container(
                          width: deviceWidth(context),
                          color: colorWhite,
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
          ):
          Container(),
          DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].imagesData!.isNotEmpty?
          Container(
            // width: deviceWidth(context),
            // height: deviceheight(context)*0.6,
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              color: colorWhite,
              // child: Image.network(DescriptionScreenData.modulePagesContentListData![pageIndex].imagesData![0].mpiName??""),
              child:  Container(
                // child: Image.asset('assets/FoodRelated/Ayla Mobile App Food Image 1200x2400.png',fit: BoxFit.fill,),
                child: Image.network(DescriptionScreenData.modulePagesContentListData![DescriptionScreenData.pageLearnIndex].imagesData![0].mpiName??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
         color: colorWhite,
          height: 40,
          width: deviceWidth(context),
          child: Padding(
            padding: const EdgeInsets.only(right: 20,left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                InkWell(
                    onTap: (){
                      print('bbb${DescriptionScreenData.pageLearnIndex != 0}');
                      if(DescriptionScreenData.pageLearnIndex != 0){
                        _pageController.animateToPage(
                          DescriptionScreenData.pageLearnIndex - 1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );

                      }else{
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
        Container(
          height: deviceheight(context) * 0.60,
          alignment: Alignment.center,
          child: SvgPicture.asset('assets/empty_content.svg', height: 100),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05),
          child: Next_Btn(context, DescriptionScreenData), // Handle no data case
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
