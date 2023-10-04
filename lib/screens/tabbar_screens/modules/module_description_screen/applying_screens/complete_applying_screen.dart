import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../../../../../common/styles/const.dart';

class CompleteApplyingScreen extends StatefulWidget {
  const CompleteApplyingScreen({Key? key}) : super(key: key);

  @override
  State<CompleteApplyingScreen> createState() => _CompleteApplyingScreenState();
}

class _CompleteApplyingScreenState extends State<CompleteApplyingScreen> {
  List  recipecategory_list_data = ['Suggested','Favourites'];
  int? _selectedIndex_RecipeCategory = 0;
  String? _selectedRecipeCategory = 'Suggested';

  List<Widget> choiceChips_RecipeCategory() {
    List<Widget> chips = [];
    for (int i = 0; i < recipecategory_list_data.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(recipecategory_list_data[i]??""),
          labelStyle: TextStyle(
              color: _selectedIndex_RecipeCategory == i?colorWhite:colorBluePigment,
              fontSize: 14,
              fontFamily: fontFamilyText,
              fontWeight: fontWeight400
          ),
          backgroundColor: colorWhite,
          selected: (_selectedIndex_RecipeCategory == i),

          selectedColor: colorBluePigment,
          shape: StadiumBorder(side: BorderSide(color: colorBluePigment)),
          onSelected: (bool value) {
            setState(() {

                _selectedIndex_RecipeCategory = i;
                _selectedRecipeCategory = recipecategory_list_data[i];


              print(_selectedIndex_RecipeCategory);
              print(_selectedRecipeCategory);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  colorWhite,
        leading: IconButton(onPressed: (){
          Get.back();
        },icon:  Icon(Icons.arrow_back_ios_new,color: colorRichblack,size: 20),),
      ),
      body: Stack(
        children: [
          Container(
            width: deviceWidth(context),
            height: deviceheight(context),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Try these recipes",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: fontFamilyText,
                      color: colorRichblack,
                      fontWeight: fontWeight600,
                    ),),

                  sizedboxheight(10.0),
                  Text("Add recipes to My Meals to solidify your learning.",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyText,
                      color: HexColor('#3B4250'),
                      fontWeight: fontWeight400,
                    ),),

                  Container(
                    color: colorWhite,

                    height: 55,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: choiceChips_RecipeCategory(),
                    ),
                  ),
                  sizedboxheight(20.0),

                  recipes_itam_listview()


                ],
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              left: deviceWidth(context,0.04),
              right: deviceWidth(context,0.04),
              child: compleate_Btn(context))
        ],
      ),
    );
  }
  /// next button //////////////////

  Widget compleate_Btn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Complete applying',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context,0.9),
        btnHeight: 55,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        btnColor: colorBluePigment,
        borderColor: colorBluePigment,
        onPressed: () {


          // Get.to(()=>Learning_Screens());
          // Navigator.pop(context);
          // (context as Element).reassemble();
        },
      ),
    );
  }

  /// recipes_itam_listview ///////////
  ScrollController? controller;
  List recipe_data_List  = [
    'Rainbow Fruit Smoothie Bowl',
    'Rainbow Fruit Smoothie Bowl',
    'Rainbow Fruit Smoothie Bowl',
    'Rainbow Fruit Smoothie Bowl',
    'Rainbow Fruit Smoothie Bowl',
    'Rainbow Fruit Smoothie Bowl',
    'Rainbow Fruit Smoothie Bowl'];
  Widget recipes_itam_listview(){

    return Container(
      height: deviceheight(context),
      width: deviceWidth(context),
      color: HexColor('#F6F7FB'),

      child: Column(
        children: [
          Container(
            height: deviceheight(context,0.6),
            width: deviceWidth(context),
            color: HexColor('#F6F7FB'),

            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              scrollDirection: Axis.vertical,
              itemCount: (recipe_data_List.length % 2 == 0 ? recipe_data_List.length ~/ 2 : recipe_data_List.length ~/ 2 + 1),
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
                        width: deviceWidth(context,0.42),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {

                              },
                              child: Container(
                                height: 110,width: deviceWidth(context),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset('assets/img.png',
                                    height: 110,width: deviceWidth(context),fit: BoxFit.cover,)

                                  // Image.network(recipe_data_List![index * 2].image??"",
                                  //   height: 110,width: deviceWidth(context),fit: BoxFit.cover,
                                  //   loadingBuilder: (BuildContext context, Widget child,
                                  //       ImageChunkEvent? loadingProgress) {
                                  //     if (loadingProgress == null) return child;
                                  //     return Center(
                                  //       child: CircularProgressIndicator(
                                  //         value: loadingProgress.expectedTotalBytes != null
                                  //             ? loadingProgress.cumulativeBytesLoaded /
                                  //             loadingProgress.expectedTotalBytes!
                                  //             : null,
                                  //       ),
                                  //     );
                                  //   },),
                                ),
                              ),
                            ),
                            sizedboxheight(10.0),
                            InkWell(
                              onTap: () {
                                // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                //   context,
                                //   settings: const RouteSettings(name: "/Recipes_Screen"),
                                //   screen:  Recipes_Description_Screen(rec_id:recipeModel.recipe_data_List![index * 2].recId,rec_index:index * 2,txt_search:txt_search.text.toString(),fav_filter:recipeModel.fav_filter),
                                // );
                              },
                              child: Text(recipe_data_List[index * 2]??"",style:TextStyle(
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

                    if (index * 2 +1 <recipe_data_List.length)

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.green,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          margin:  EdgeInsets.all(1.0),
                          width: deviceWidth(context,0.42),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {

                                },
                                child: Container(
                                  height: 110,width: deviceWidth(context),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset('assets/img.png',
                                      height: 110,width: deviceWidth(context),fit: BoxFit.cover,),
                                  ),
                                ),
                              ),
                              sizedboxheight(10.0),
                              InkWell(
                                onTap: () {

                                },
                                child: Text(recipe_data_List[index * 2 + 1]??"",style:TextStyle(
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
            ),
          ),

        ],
      ),);
  }
}
