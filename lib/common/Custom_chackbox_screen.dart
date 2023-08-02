import 'package:flutter/material.dart';

import '../common/styles/const.dart';


class Custom_chackbox extends StatefulWidget {
  final String buttontext;
  final Color? unchackborderclor;
  final Color? chackborderclor;
  final Color? chackboxchackcolor;
  final Color? chackboxunchackcolor;
  final   chackboxicon;
  final  double? boxheight;
  final  double? boxwidth;
  final  double? checkbox_row_width;
  final int? screentype;
  final Function action;
  final TextStyle? titel_textstyle;
  bool? buttoninout;
   Custom_chackbox({Key? key,
   required this.buttontext,
    this.unchackborderclor,
    this.chackborderclor,
    this.chackboxchackcolor,
    this.chackboxunchackcolor,
    this.chackboxicon,
    this.boxheight,
    this.boxwidth,
    this.checkbox_row_width,
    this.screentype,
    required this.action,
     this.titel_textstyle,
     this.buttoninout,

   });

  @override
  State<Custom_chackbox> createState() => _Custom_chackboxState();
}

class _Custom_chackboxState extends State<Custom_chackbox> {
  bool chaeckbutton = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chaeckbutton = widget.buttoninout??false;
    print('chaeckbutton');
    print(chaeckbutton);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: InkWell(
        onTap: () { widget.action();
        setState(() {
          chaeckbutton = !chaeckbutton;

        });
        },
        child: Container(
          height: 50,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(

                  height:widget.boxheight??25,
                  width: widget.boxwidth??deviceWidth(context,0.06),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color:chaeckbutton? widget.chackboxchackcolor??Colors.blue:widget.chackboxunchackcolor??Colors.white,
                      border: Border.all(color: chaeckbutton?widget.chackborderclor??Colors.white:widget.unchackborderclor??Colors.blue,width: 2)
                  ),
                  child:chaeckbutton?(widget.chackboxicon==null?const Center(child: Icon(Icons.done,size: 14,)):Center(child: Text(widget.chackboxicon.toString()))):Container(),
                ),
                sizedboxwidth(deviceWidth(context,0.02)),
                Container(
                  width: widget.checkbox_row_width==null?widget.screentype==1?deviceWidth(context,0.8):deviceWidth(context,0.45):widget.checkbox_row_width,
                  child: Text(widget.buttontext??"",
                    style:widget.titel_textstyle?? TextStyle(
                      fontSize: 16,
                      fontFamily: fontFamilyText,
                      color: colorRichblack,
                      fontWeight: fontWeight400,
                      overflow: TextOverflow.ellipsis
                    ),maxLines: 2,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
