import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common/Custom_chackbox_screen.dart';
import '../../../../common/commonwidgets/button.dart';
import '../../../../common/styles/const.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  bool selectdate_function = false;
  List<String> dairy_list = [ 'milk 100ml','yoghurt 2tbsp'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: colorWhite,
      appBar: _appbar(),
      body:selectdate_function? Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                //  height: 30,
                  decoration: BoxDecoration(
                    color: HexColor('#F6F8F9'),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.only(left: 18,right: 18,top: 6,bottom: 6),

                  child: Text("Wed 20 June - Thu 21 June",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamilyText,
                        color: colorShadowBlue,
                        fontWeight: fontWeight400,

                    ),
                  ),
                ),
              ),
              sizedboxheight(10.0),
              Text("Dairy & Alternatives",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight600,
                ),
              ),

              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:dairy_list.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index1)
                  {return  Container(
                    height: 40,
                    width: deviceWidth(context),
                    child: ShopingList_chackbox(
                      action:(){
                        setState(() {
                         // qustion_data_list![index].optionData![index1].isSelected = !qustion_data_list![index].optionData![index1].isSelected!;
                         //_itemChange(qustion_data_list![index].optionData![index1].opsId.toString(), qustion_data_list![index].optionData![index1].isSelected!);
//
                        });
                      },
                      screentype: 1,
                      // buttoninout: chaeckbutton,
                      buttontext:"${dairy_list[index1].toString().split(" ")[0]} ",
                      button_sub_text:dairy_list[index1].toString().split(" ")[1],
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
        ),
      ):Container(
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
                    },
                    child: Container(
                      height: 45,
                      width: deviceWidth(context,0.7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#F6F7FB')
                      ),
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/Search.svg',color: colorShadowBlue,),
                          Container(
                            width: deviceWidth(context,0.48),
                            child: Text(selectdaye??'DD/MM/YYYY',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: colorShadowBlue,
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
                    },
                    child: Container(
                      height: 45,
                      width: deviceWidth(context,0.7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor('#F6F7FB')
                      ),
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/Search.svg',color: colorShadowBlue,),
                          Container(
                            width: deviceWidth(context,0.48),
                            child: Text(selectdaye??'DD/MM/YYYY',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: colorShadowBlue,
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

            ],
          ),
        ),
      ),
    );
  }
  /// appbar ///////////////////

  AppBar _appbar(){
    return AppBar(
      elevation: 0,
      leading:IconButton(
        onPressed: (){

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
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: SvgPicture.asset('assets/image/menu_icon.svg',width: 18,height: 5,
            color: HexColor('#131A29'),),
        )
      ],
      backgroundColor: colorWhite,
    );
  }
  /// View List /////////////

  Widget view_list_Btn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'View list',
        textColor: colorWhite,

        btnfontsize: 20,
        btnfontweight: fontWeight400,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor:selectdaye==null?colorDisabledButton: colorEnabledButton,
        onPressed: () {
          setState(() {
            selectdate_function = true;
          });
        },
      ),
    );
  }
  /// add meals bottom sheet //////////////////////
DateTime? selectdate ;
  DateTime _focusedDay = DateTime.now();
  String? selectdaye  = null ;
  void showBottomAlertDialog(BuildContext context) {
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

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          padding: EdgeInsets.only(bottom: 10),
                          child: TableCalendar(
                            rowHeight: 35,
                            firstDay: DateTime(2022),
                            lastDay: DateTime(2050),
                            focusedDay:_focusedDay,


                            startingDayOfWeek: StartingDayOfWeek.monday,
                            selectedDayPredicate: (day) => isSameDay(selectdate, day),
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

                            // onFormatChanged: (format) {
                            //   setState(() {
                            //     _calendarFormat = format;
                            //   });
                            // },
                            onHeaderTapped: (_) {
                              setstate(() {
                                // calendar_listview = true;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              setstate(() {
                               // recipeModel.focusedDay_data(focusedDay);
                                _focusedDay = focusedDay;
                              });
                            },

                            onDaySelected: (selectedDay, focusedDay) {
                              print(selectedDay.toString());
                              print(focusedDay.toString());
                              setState(() {
                                selectdate = selectedDay;
                                _focusedDay = focusedDay;
                             //   recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(selectedDay));
                                selectdaye = DateFormat('EEEE d MMM').format(selectedDay);
                                Navigator.pop(context);


                                //  DateFormat.MMMMEEEEd(focusedDay).format(selectedDay);
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

}
