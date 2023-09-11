import 'package:aylahealth/screens/tabbar_screens/my_meals/shopping_list_screen/shoping_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common/Custom_chackbox_screen.dart';
import '../../../../common/commonwidgets/button.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../common/styles/const.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {


  /// initState ///
  @override
  void initState() {
    super.initState();
    final  shoppingListModel = Provider.of<ShoppingListProvider>(context, listen: false);

    shoppingListModel.customerShoppingList_api(context);
    shoppingListModel.selectStartDayString_function( null);
    shoppingListModel.selectEndDayString_function( null);
    shoppingListModel.viewListFunction(false);
    shoppingListModel.selectStartDate_function(DateTime.now());
    shoppingListModel.selectEndDate_function(DateTime.now());
    shoppingListModel.focusedStartDay_function(DateTime.now());
    shoppingListModel.focusedEndDay_function(DateTime.now());
  }


  @override
  Widget build(BuildContext context) {
    final shoppingListModel = Provider.of<ShoppingListProvider>(context);
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: _appbar(),
      body:shoppingListModel.loading
          ? Container(
        child: const Center(child: CircularProgressIndicator()),
      ):
      shoppingListModel.viewList_function? Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shoppingListModel.loading?Container() :Align(
                alignment: Alignment.center,
                child: Container(
                //  height: 30,
                  decoration: BoxDecoration(
                    color: HexColor('#F6F8F9'),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.only(left: 18,right: 18,top: 6,bottom: 6),

                  child: Text( "${DateFormat("EE d MMMM").format(DateTime.parse(shoppingListModel.sl_startdate??"${DateTime.now()}"))}""  -  ""${DateFormat("EE d MMMM").format(DateTime.parse(shoppingListModel.sl_enddate??"${DateTime.now()}"))}",
                  //Text("Wed 20 June - Thu 21 June",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamilyText,
                        color: colorShadowBlue,
                        fontWeight: fontWeight400,

                    ),
                  ),
                ),
              ),

              shoppingListModel.customerShoppingList_data!.isEmpty?SizedBox(
                height: deviceheight(context,0.6),
                child: const Center(
                  child: Text('No Shopping List Data'),
                ),
              ):ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:shoppingListModel.customerShoppingList_data!.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(shoppingListModel.customerShoppingList_data![index].scName??"",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: colorRichblack,
                              fontWeight: fontWeight600,
                            ),
                          ),
                          sizedboxheight(5.0),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:shoppingListModel.customerShoppingList_data![index].ingData!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index1)
                              {return  Container(
                                height: 35,
                                width: deviceWidth(context),
                                child: ShopingList_chackbox(
                                  action:(){
                                    setState(() {
                                      if(shoppingListModel.customerShoppingList_data![index].ingData![index1].slItemStatus==0){
                                        shoppingListModel.updateShoppingItemStatus_api(context, shoppingListModel.customerShoppingList_data![index].ingData![index1].slId, 1 );
                                        shoppingListModel.customerShoppingList_data![index].ingData![index1].slItemStatus=1;
                                      }else{
                                        shoppingListModel.updateShoppingItemStatus_api(context, shoppingListModel.customerShoppingList_data![index].ingData![index1].slId, 0 );
                                        shoppingListModel.customerShoppingList_data![index].ingData![index1].slItemStatus=0;
                                      }
                                      // qustion_data_list![index].optionData![index1].isSelected = !qustion_data_list![index].optionData![index1].isSelected!;
                                      //_itemChange(qustion_data_list![index].optionData![index1].opsId.toString(), qustion_data_list![index].optionData![index1].isSelected!);


                                    });
                                  },
                                  screentype: 1,
                                   buttoninout: shoppingListModel.customerShoppingList_data![index].ingData![index1].slItemStatus==0?false:true,
                                  buttontext:shoppingListModel.customerShoppingList_data![index].ingData![index1].ingName??"",
                                  button_sub_text:" ${shoppingListModel.customerShoppingList_data![index].ingData![index1].slQuantity??""}" "${shoppingListModel.customerShoppingList_data![index].ingData![index1].ingUnit??""}",
                                  unchackborderclor: HexColor('#CCCCCC'),
                                  chackborderclor: colorBluePigment,
                                  chackboxunchackcolor: colorWhite,
                                  chackboxchackcolor: colorWhite,
                                  titel_textstyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: fontFamilyText,
                                    color: colorRichblack,
                                    fontWeight: fontWeight400,
                                  ),
                                ),
                              );})
                        ],
                      ),
                    );}),

              sizedboxheight(50.0),
            ],
          ),
        ),
      ):
      Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        decoration: BoxDecoration(
          boxShadow:  const [
          BoxShadow(color: Colors.black12,

          blurRadius:25.0,blurStyle: BlurStyle.outer,
         ),
        ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: colorWhite
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select dates',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight600,
                    overflow: TextOverflow.ellipsis
                ),),
              sizedboxheight(20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start:',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: colorRichblack,
                        fontWeight: fontWeight400,
                        overflow: TextOverflow.ellipsis
                    ),),
                  InkWell(
                    onTap: (){
                      showBottomAlertDialog(context);
                      shoppingListModel.selectDayType_function('Start');
                    },
                    child: Container(
                      height: 45,
                      width: deviceWidth(context,0.7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#F6F7FB')
                      ),
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/Search.svg',color: shoppingListModel.startDayString==null? colorShadowBlue:colorRichblack,),
                          Container(
                            width: deviceWidth(context,0.48),
                            child: Text(shoppingListModel.startDayString??'DD/MM/YYYY',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: shoppingListModel.startDayString==null? colorShadowBlue:colorRichblack,
                                  fontWeight: fontWeight400,
                                  overflow: TextOverflow.ellipsis
                              ),),
                          ),
                          SvgPicture.asset('assets/image/chevron-down.svg',color: colorShadowBlue,),

                        ],
                      ),
                    ),
                  ),

                ],
              ),
              sizedboxheight(15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('End:',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: colorRichblack,
                        fontWeight: fontWeight400,
                        overflow: TextOverflow.ellipsis
                    ),),
                  InkWell(
                    onTap: (){
                      showBottomAlertDialog(context);
                      shoppingListModel.selectDayType_function('End');
                    },
                    child: Container(
                      height: 45,
                      width: deviceWidth(context,0.7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor('#F6F7FB')
                      ),
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/Search.svg',color: shoppingListModel.endtDayString==null? colorShadowBlue:colorRichblack,),
                          Container(
                            width: deviceWidth(context,0.48),
                            child: Text(shoppingListModel.endtDayString??'DD/MM/YYYY',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: shoppingListModel.endtDayString==null? colorShadowBlue:colorRichblack,
                                  fontWeight: fontWeight400,
                                  overflow: TextOverflow.ellipsis
                              ),),
                          ),
                          SvgPicture.asset('assets/image/chevron-down.svg',color: colorShadowBlue,),

                        ],
                      ),
                    ),
                  ),

                ],
              ),
              sizedboxheight(30.0),
              view_list_Btn(context),
              // Card(
              //   elevation: 5,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: Container(
              //    // margin: const EdgeInsets.all(20.0),
              //    // padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             IconButton(
              //                 onPressed: (){
              //
              //                   shoppingListModel.pageController!.previousPage(
              //                     duration: const Duration(milliseconds: 300),
              //                     curve: Curves.easeOut,
              //                   );
              //                   shoppingListModel.focusedDay_function(shoppingListModel.focusedDay.subtract(const Duration(days: 30)));
              //
              //
              //                   setState((){});
              //
              //                 },
              //                 icon: Icon(Icons.chevron_left,color: colorRichblack,)),
              //
              //             TextButton(
              //                 onPressed: (){
              //                   yearpicker();
              //                 },
              //                 child: Row(
              //                   children: [
              //                     Text(DateFormat('yMMM').format(shoppingListModel.focusedDay).toString(),style: TextStyle(
              //                       color: colorRichblack,
              //                       fontSize: 14,
              //                       fontWeight: fontWeight600,
              //                       fontFamily: fontFamilyText,
              //                     )),
              //                     Icon(Icons.keyboard_arrow_down,color: colorRichblack,size: 18),
              //                   ],
              //                 )),
              //             IconButton(
              //                 onPressed: (){
              //                   shoppingListModel.pageController!.nextPage(
              //                     duration: const Duration(milliseconds: 300),
              //                     curve: Curves.easeOut,
              //                   );
              //                   shoppingListModel.focusedDay_function(shoppingListModel.focusedDay.add(const Duration(days: 30)));
              //                   setState((){});
              //
              //                 },
              //                 icon: Icon(Icons.chevron_right,color: colorRichblack,)),
              //           ],
              //         ),
              //         Container(
              //           margin: const EdgeInsets.symmetric(horizontal: 20.0),
              //           padding: const EdgeInsets.only(bottom: 10),
              //           child: TableCalendar(
              //             rowHeight: 35,
              //             firstDay: DateTime(2022),
              //             lastDay: DateTime(2050),
              //             focusedDay:shoppingListModel.focusedDay,
              //             startingDayOfWeek: StartingDayOfWeek.monday,
              //             selectedDayPredicate: (day) => isSameDay(shoppingListModel.selectdate, day),
              //             calendarFormat: CalendarFormat.month,
              //             calendarStyle: CalendarStyle(
              //               outsideDaysVisible: false,
              //               weekendTextStyle: TextStyle(color: HexColor('#3B4250') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
              //               defaultTextStyle:TextStyle(color: HexColor('#3B4250') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
              //               disabledTextStyle:TextStyle(color: HexColor('#9E9E9E') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
              //               selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
              //               todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
              //
              //               selectedDecoration: BoxDecoration(shape: BoxShape.rectangle, color: colorBluePigment, borderRadius: BorderRadius.circular(5),),
              //               defaultDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5),),
              //               weekendDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              //               disabledDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              //               todayDecoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(5)),
              //
              //             ),
              //
              //             headerVisible: false,
              //
              //             onCalendarCreated: (controller) => shoppingListModel.calendarController_function(controller) ,
              //             daysOfWeekStyle: DaysOfWeekStyle(
              //               weekdayStyle: TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
              //               weekendStyle:TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
              //             ),
              //
              //             // onFormatChanged: (format) {
              //             //   setState(() {
              //             //     _calendarFormat = format;
              //             //   });
              //             // },
              //
              //             onPageChanged: (focusedDay) {
              //               setState(() {
              //                 // recipeModel.focusedDay_data(focusedDay);
              //                 shoppingListModel.focusedDay_function(focusedDay);
              //
              //               });
              //             },
              //
              //             onDaySelected: (selectedDay, focusedDay) {
              //               shoppingListModel.selectDate_function(selectedDay);
              //               shoppingListModel.focusedDay_function(focusedDay);
              //               //   recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(selectedDay));
              //               shoppingListModel.selectDayString_function(DateFormat('EEEE d MMM').format(selectedDay));
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ).paddingOnly(top: 30)
            ],
          ),
        ),
      ),
    );
  }
  /// appbar ///////////////////


  PopupMenuItem _buildPopupMenuItem(
      String title,Function action) {
    return PopupMenuItem(
      onTap: () => action() ,
      child:  Text(title),
    );
  }

  AppBar _appbar(){
    return AppBar(
      elevation: 0,
      leading:IconButton(
        onPressed: (){
         Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/backbutton.svg',width: 18,height: 18,
          color: HexColor('#131A29'),),
      ),
      centerTitle: true,
      title: Text('Shopping List',
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Playfair Display',
            color: colorPrimaryColor,
            fontWeight: fontWeight500,
            overflow: TextOverflow.ellipsis
        ),),

      actions: [

        PopupMenuButton(
          padding: const EdgeInsets.only(right: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          icon: SvgPicture.asset('assets/image/menu_icon.svg',width: 18,height: 5,
          color: HexColor('#131A29'),),

          itemBuilder: (ctx) => [

            _buildPopupMenuItem('Regenerate',(){
              final  shoppingListModel = Provider.of<ShoppingListProvider>(context, listen: false);
              shoppingListModel.viewListFunction( false);
              shoppingListModel.selectStartDayString_function( null);
              shoppingListModel.selectEndDayString_function( null);
              shoppingListModel.viewListFunction(false);
              shoppingListModel.selectStartDate_function(DateTime.now());
              shoppingListModel.selectEndDate_function(DateTime.now());
              shoppingListModel.focusedStartDay_function(DateTime.now());
              shoppingListModel.focusedEndDay_function(DateTime.now());
            }),

            _buildPopupMenuItem('Reset',(){}),

            _buildPopupMenuItem('Exit',(){}),
          ],
        )
      ],
      backgroundColor: colorWhite,
    );
  }
  /// View List /////////////

  Widget view_list_Btn(context) {
    final  shoppingListModel = Provider.of<ShoppingListProvider>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'View list',
        textColor: colorWhite,

        btnfontsize: 20,
        btnfontweight: fontWeight400,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor:shoppingListModel.startDayString==null||shoppingListModel.endtDayString==null?colorDisabledButton: colorEnabledButton,
        onPressed: () {
          setState(() {
            if(shoppingListModel.startDayString!=null&&shoppingListModel.endtDayString!=null){
            print(DateFormat('yyyy/MM/dd').format(shoppingListModel.selectEnddate!));

            int daysBetween(DateTime from, DateTime to) {
              from = DateTime(from.year, from.month, from.day);
              to = DateTime(to.year, to.month, to.day);
              return (to.difference(from).inHours / 24).round();
            }
            final data = daysBetween(shoppingListModel.selectStartdate!, shoppingListModel.selectEnddate!);
            if(data<8){
              shoppingListModel.viewListFunction(true);
              shoppingListModel.createShoppingList_api(context,DateFormat('yyyy-MM-dd').format(shoppingListModel.selectStartdate!), DateFormat('yyyy-MM-dd').format(shoppingListModel.selectEnddate!) );
            }else{
             // FlutterToast_message('Maximum Select 7 Days.');
              warning_popup();
            }
            }
          });
        },
      ),
    );
  }
  /// add meals bottom sheet //////////////////////

  void showBottomAlertDialog(BuildContext context) {
    final  shoppingListModel = Provider.of<ShoppingListProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
                return Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: (){
                                  print(shoppingListModel.focusedStartDay);
                                  shoppingListModel.pageController!.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );

                                  if(shoppingListModel.dayTypeString =="Start"){
                                    shoppingListModel.focusedStartDay_function(shoppingListModel.focusedStartDay.subtract(const Duration(days: 30)));
                                  }
                                  else if(shoppingListModel.dayTypeString =="End"){
                                    shoppingListModel.focusedEndDay_function(shoppingListModel.focusedEndDay.subtract(const Duration(days: 30)));
                                  }

                                  setState((){});

                                },
                                icon: Icon(Icons.chevron_left,color: colorRichblack,)),

                            TextButton(
                                onPressed: (){
                                  yearpicker();
                                },
                                child: Row(
                                  children: [
                                    Text(DateFormat('yMMM').format(shoppingListModel.dayTypeString =="Start"?shoppingListModel.focusedStartDay:shoppingListModel.focusedEndDay).toString(),style: TextStyle(
                                      color: colorRichblack,
                                      fontSize: 14,
                                      fontWeight: fontWeight600,
                                      fontFamily: fontFamilyText,
                                    )),
                                    Icon(Icons.keyboard_arrow_down,color: colorRichblack,size: 18),
                                  ],
                                )),
                            IconButton(
                                onPressed: (){
                                  print(shoppingListModel.dayTypeString =="Start"?shoppingListModel.focusedStartDay:shoppingListModel.focusedEndDay);
                                  shoppingListModel.pageController!.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                  if(shoppingListModel.dayTypeString =="Start"){
                                    shoppingListModel.focusedStartDay_function(shoppingListModel.focusedStartDay.add(const Duration(days: 30)));
                                  }
                                  else if(shoppingListModel.dayTypeString =="End"){
                                    shoppingListModel.focusedEndDay_function(shoppingListModel.focusedEndDay.add(const Duration(days: 30)));
                                  }

                                  setState((){});

                                },
                                icon: Icon(Icons.chevron_right,color: colorRichblack,)),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TableCalendar(
                            rowHeight: 35,
                            firstDay: DateTime(2022),
                            lastDay: DateTime(2050),
                            focusedDay:shoppingListModel.dayTypeString =="Start"?shoppingListModel.focusedStartDay:shoppingListModel.focusedEndDay,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            selectedDayPredicate: (day) => isSameDay(shoppingListModel.dayTypeString =="Start"?shoppingListModel.selectStartdate:shoppingListModel.selectEnddate, day),
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

                            headerVisible: false,

                            onCalendarCreated: (controller) => shoppingListModel.calendarController_function(controller) ,
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                              weekendStyle:TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                            ),

                            // onFormatChanged: (format) {
                            //   setState(() {
                            //     _calendarFormat = format;
                            //   });
                            // },

                            onPageChanged: (focusedDay) {
                              setstate(() {
                               // recipeModel.focusedDay_data(focusedDay);
                                if(shoppingListModel.dayTypeString =="Start"){
                                    shoppingListModel.focusedStartDay_function(focusedDay);
                                }
                                else if(shoppingListModel.dayTypeString =="End"){
                                    shoppingListModel.focusedEndDay_function(focusedDay);
                                }

                              });
                            },

                            onDaySelected: (selectedDay, focusedDay) {
                              if(shoppingListModel.dayTypeString =="Start"){
                                setState(() {
                                  shoppingListModel.selectStartDate_function(selectedDay);
                                  shoppingListModel.focusedStartDay_function(focusedDay);
                                  //   recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(selectedDay));
                                  shoppingListModel.selectStartDayString_function(DateFormat('EEEE d MMM').format(selectedDay));
                                  Navigator.pop(context);

                                  //  DateFormat.MMMMEEEEd(focusedDay).format(selectedDay);
                                });
                              }
                              else if(shoppingListModel.dayTypeString =="End"){
                                  setState(() {
                                    shoppingListModel.selectEndDate_function(selectedDay);
                                    shoppingListModel.focusedEndDay_function(focusedDay);
                                    //   recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(selectedDay));
                                    shoppingListModel.selectEndDayString_function(DateFormat('EEEE d MMM').format(selectedDay));
                                    Navigator.pop(context);

                                    //  DateFormat.MMMMEEEEd(focusedDay).format(selectedDay);
                                  });
                                }


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

  Future yearpicker(){
    final  shoppingListModel = Provider.of<ShoppingListProvider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          title: Text('Select Year',style:  TextStyle(
            color: colorBluePigment,
            fontSize: 20,
            fontWeight: fontWeight400,
            fontFamily: fontFamilyText,
          )),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Container( // Need to use container to add size constraint.
                  width: 300,
                  height:300,

                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: colorBluePigment, // header background color
                        onPrimary: colorWhite, // header text color
                        onSurface: colorRichblack, // body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red, // button text color
                        ),
                      ),
                    ),
                    child: YearPicker(
                      currentDate:  DateTime(DateTime.now().year,1),
                      firstDate: DateTime(2023,1),
                      lastDate: DateTime(2200,1),
                      initialDate: DateTime(DateTime.now().year,1),

                      selectedDate:shoppingListModel.dayTypeString =="Start"? shoppingListModel.selectStartdate!:shoppingListModel.selectEnddate!,
                      onChanged: (DateTime dateTime) {


                        Navigator.pop(context);

                      },
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }
  Future warning_popup(){
    return   showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(

            content: const Text('The end date cannot be more than 7 days from the start date.'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                  FocusManager.instance.primaryFocus?.unfocus();
                },

                child:  Text('Ok',style: TextStyle(color: colorBluePigment ),),
              ),
              // The "Yes" button

              // The "No" butt

            ],
          );
        }
    );
  }
}
