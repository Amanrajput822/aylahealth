import 'dart:async';
import 'dart:io';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/tabbar_screens/support_screen/message/chat/widgets/receiver_message.dart';
import 'package:aylahealth/screens/tabbar_screens/support_screen/message/chat/widgets/sender_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../../../../common/SharedPrefHelper.dart';
import '../../../../../common/formtextfield/mytextfield.dart';
import 'firebase_services.dart';
import 'model/MessageModel.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  final focusKey=FocusNode();
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];

  @override
  void initState() {
    Timer(const Duration( seconds:1), () { _scrollDown();});
    FirebaseFirestore.instance
        .collection("users")
        .doc(SharedPrefHelper.userId.toString())
        .collection("messages")

        .orderBy('created', descending: false)
        .snapshots()
        .listen((event) {
      print(event.docs.length);
      messages = event.docs.map<Message>((e) => Message.fromJson(e.data())).toList();
      if (mounted) setState(() {});
    });
    super.initState();

  }

  void _scrollDown() {
    setState(() {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut);
    });

  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  String categorizeMessage(Message message) {
   DateTime  now = DateTime.now();
  // DateTime messageDate = DateTime.parse(message.created.toDate().toString());
   DateTime messageDate = DateTime(DateTime.parse(message.created.toDate().toString()).year, DateTime.parse(message.created.toDate().toString()).month, DateTime.parse(message.created.toDate().toString()).day);
   int difference = messageDate.difference(now).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == -1) {
      return "Yesterday";
    } else if (difference == 1) {
      return "Tomorrow";
    } else {
      return DateFormat('MMM d').format(DateTime.parse(message.created.toDate().toString()));
    }
  }

  bool isDateChanged(DateTime previousDate, DateTime currentDate) {
    return previousDate.day != currentDate.day ||
        previousDate.month != currentDate.month ||
        previousDate.year != currentDate.year;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: _appbar(),
      backgroundColor: colorWhite,
      body: Container(
        height: Platform.isAndroid?MediaQuery.of(context).size.height*0.83:MediaQuery.of(context).size.height*0.76,
        width: MediaQuery.of(context).size.width,
        color: colorWhite,
        child: Column(
          children: [

            Expanded(
              child: ListView.separated(
                  reverse: false,
                  controller: _scrollController,
                  itemCount: messages.length,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                    itemBuilder: (context, position) {
                    Message message = messages[position];

                    DateTime? previousDate = DateTime.now();
                    if(position != 0){
                      previousDate = messages[position-1].created.toDate();
                    }


                    return Column(
                      children: [

                        isDateChanged(previousDate!, message.created.toDate())? Container(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                            color: HexColor('#F6F8F9'),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(categorizeMessage(message),
                          style: TextStyle(color:colorShadowBlue,
                                 fontWeight: FontWeight.w400,
                                 fontSize:13.0, fontFamily: fontFamilyText),
                                 maxLines: 1,
                                 textAlign: TextAlign.end),
                        ):Container(),
                        isDateChanged(previousDate, message.created.toDate())?sizedboxheight(8.0):sizedboxheight(0.0),
                        message.senderId ==
                            SharedPrefHelper.userId.toString()
                            ? SenderMessage(message: message,)
                            : ReceiverMessage(message: message)
                      ],
                    );
                  }),
            ),
            Padding(
              padding:   EdgeInsets.only(
                  left: 20, right: 20,  bottom: Platform.isAndroid ?20:15),
              child: Container(
                child: messageField(),
              ),
            ),

          ],
        ),
      ),
    );
  }
bool fieldFocus = false;
  /// message field widget ///
  Widget messageField() {
    return Focus(
      autofocus: false,
      // onFocusChange: (value){
      //   setState(() {
      //     fieldFocus = value;
      //   });
      // },

      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return
            TextFormField(
              controller: messageController,
            style: TextStyle(
                color:  colorRichblack,
                fontFamily: 'Messina Sans',
                fontWeight: FontWeight.w400,
                fontSize:  16),
              maxLines: null,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Send a message....',
              hintStyle: TextStyle(
                color: colorTextFieldHintText,
                fontSize: 16,
                fontFamily: 'Messina Sans',
                fontWeight: FontWeight.w400,
              ),

              suffixIcon: TextButton(
                    onPressed: () async {
                        if (messageController.text.trim().isNotEmpty) {
                          await FirebaseData.instance.userUpdateTime();
                          await FirebaseData.instance.sendMessage(Message(
                              text: messageController.text,
                              created: FieldValue.serverTimestamp(),
                              receiverId: "1",
                              senderId: SharedPrefHelper.userId.toString()));
                          messageController.clear();
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut);
                        } else {}
                    },
                    child:SvgPicture.asset(
                      'assets/image/send.svg',

                    )),
              filled: true,
              fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
              contentPadding: const EdgeInsets.all(10.0),

              border:  OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(6),
                borderSide: BorderSide(
                    color: colorDisabledTextField, width: 0.6),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(6),
                borderSide: BorderSide(
                    color: colorDisabledTextField, width: 0.6),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(6),
                borderSide: BorderSide(
                    color:  colorDisabledTextField, width: 0.6),
              ),
            ),
          );
          //   AllInputDesign(
          //   // key: Key("email1"),
          //   floatingLabelBehavior: FloatingLabelBehavior.never,
          //   focusNode: focusKey,
          //   hintText: 'Send a message....',
          //   maxLines: null,
          //   keyboardType: TextInputType.multiline,
          //   fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
          //   suffixIcon: TextButton(
          //       onPressed: () async {
          //           if (messageController.text.trim().isNotEmpty) {
          //             await FirebaseData.instance.userUpdateTime();
          //             await FirebaseData.instance.sendMessage(Message(
          //                 text: messageController.text,
          //                 created: FieldValue.serverTimestamp(),
          //                 receiverId: "1",
          //                 senderId: SharedPrefHelper.userId.toString()));
          //             messageController.clear();
          //             _scrollController.animateTo(
          //                 _scrollController.position.maxScrollExtent,
          //                 duration: const Duration(milliseconds: 500),
          //                 curve: Curves.easeOut);
          //           } else {}
          //       },
          //       child:SvgPicture.asset(
          //         'assets/image/send.svg',
          //
          //       )),
          //
          //   controller: messageController,
          //  // textInputAction: TextInputAction.multiline,
          //  // keyBoardType: TextInputType.text,
          //   validatorFieldValue: 'email',
          //
          // );
        },
      ),
    );
  }
  /// appbar ///////////////////

  AppBar _appbar(){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text('Live Chat',
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Playfair Display',
            color: colorPrimaryColor,
            fontWeight: fontWeight500,
            overflow: TextOverflow.ellipsis
        ),),
      leading: IconButton(onPressed: (){
         Navigator.pop(context);
      },icon:  Icon(Icons.arrow_back_ios_new,color: colorRichblack,size: 20),),

      backgroundColor: colorWhite,
    );
  }
}
