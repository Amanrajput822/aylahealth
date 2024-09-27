import 'dart:async';
import 'dart:io';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/tabbar_screens/support_screen/message/chat/widgets/receiver_message.dart';
import 'package:aylahealth/screens/tabbar_screens/support_screen/message/chat/widgets/sender_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/SharedPrefHelper.dart';
import '../../../../../common/formtextfield/mytextfield.dart';
import '../../../../../common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import 'firebase_services.dart';
import 'model/MessageModel.dart';



class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with WidgetsBindingObserver{

  final FocusNode focusKey = FocusNode();
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];

  @override
 void initState()  {
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);

  //  Timer(const Duration( seconds:1), () { scrollDown(BottomNavBarProviderModel);});
    firebaseInstanceCreate();
    FirebaseFirestore.instance
        .collection("users")
        .doc(SharedPrefHelper.userId.toString())
        .collection("messages")
        .orderBy('created', descending: false)
        .snapshots()
        .listen((event) {
      print(event.docs.length);
      messages = event.docs.map<Message>((e) => Message.fromJson(e.data())).toList();
     // scrollDown(BottomNavBarProviderModel);
      event.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          BottomNavBarProviderModel.unreadMessagesFunction(0);
        }
      });
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    BottomNavBarProviderModel.chatMessagesFunction(true);
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(SharedPrefHelper.userId.toString()).update({
      "status": status,
    });
  }


  Future<void> firebaseInstanceCreate() async {
    final DocumentReference<Map<String, dynamic>> reference =
    FirebaseFirestore.instance.collection('users').doc(SharedPrefHelper.userId.toString());
    final bool documentExists = await reference.get().then((doc) => doc.exists);
    if (!documentExists) {
      await reference.set({});
      print('Document created successfully!');
    }else{
      print('Document already created');
    }
  }

  // void scrollDown(BottomNavBarProviderModel) {
  //
  //     _scrollController.animateTo(
  //
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.ease,
  //     );
  //     BottomNavBarProviderModel.unreadMessagesFunction(0);
  //
  // }



  String categorizeMessage(Message message) {
   DateTime  now = DateTime.now();
  // DateTime messageDate = DateTime.parse(message.created.toDate().toString());
   DateTime messageDate = DateTime(DateTime.parse(message.created.toDate().toString()).year,
       DateTime.parse(message.created.toDate().toString()).month,
       DateTime.parse(message.created.toDate().toString()).day);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);

    if (state == AppLifecycleState.resumed) {
      // online
      print("chat user is: Online");
      setStatus("Online");
      BottomNavBarProviderModel.chatMessagesFunction(true);
    } else {
      // offline
      print("chat user is: Offline");
      setStatus("Offline");
      BottomNavBarProviderModel.chatMessagesFunction(false);
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appbar(),
      backgroundColor: colorWhite,
      body: Container(
        height: Platform.isAndroid?MediaQuery.of(context).size.height*0.83:MediaQuery.of(context).size.height*0.76,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: Platform.isAndroid?MediaQuery.of(context).size.height*0.80:MediaQuery.of(context).size.height*0.73,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: Padding(
                padding:  EdgeInsets.only(top: deviceheight(context,0.05)),
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          FocusManager.instance.primaryFocus?.unfocus();

                        },
                        child: SingleChildScrollView(
                          reverse: true,
                        //  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                          child: ListView.separated(
                              controller: _scrollController,
                              itemCount: messages.length,
                             // reverse: true,
                             shrinkWrap: true,
                             // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                              separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                              itemBuilder: (context, position) {
                                Message message = messages[position];

                                DateTime? previousDate = DateTime.now();
                                if(position != 0){
                                  previousDate = messages[position-1].created.toDate();
                                }


                                return Container(
                                  child: Column(
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
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),

                    ///
                    Padding(
                      padding:   EdgeInsets.only(
                          left: 20, right: 20,  bottom: Platform.isAndroid ?20:15),
                      child: messageField(BottomNavBarProviderModel),
                    ),

                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              color: colorWhite,
              padding: EdgeInsets.only(left: 50,right: 50,),
              child: Text('Live Chat is manned between 9am - 5pm Mon-Fri (AEST). We\'ll aim to get back to you within 2 hours.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: fontFamilyText,
                  color: colorPrimaryColor,
                  fontWeight: fontWeight400,
                ),),
            ),
          ],
        ),
      ),
    );
  }
bool fieldFocus = false;
  /// message field widget ///
  Widget messageField(BottomNavBarProviderModel) {
    return Focus(
      autofocus: false,
      focusNode: focusKey,

      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return
            IntrinsicHeight(
              child: TextFormField(
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
                            await FirebaseData.instance.sendMessage(context,Message(
                                text: messageController.text.trim(),
                                created: FieldValue.serverTimestamp(),
                                receiverId: "11",
                                senderId: SharedPrefHelper.userId.toString()));
                            messageController.clear();
                          //  scrollDown(BottomNavBarProviderModel);
                          }
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
          ),
            );

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
        final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);

        Navigator.pop(context);
         setStatus("Offline");
         BottomNavBarProviderModel.chatMessagesFunction(false);
      },icon:  Icon(Icons.arrow_back_ios_new,color: colorRichblack,size: 20),),

      backgroundColor: colorWhite,
    );
  }
}
