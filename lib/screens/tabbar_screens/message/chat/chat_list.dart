import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/tabbar_screens/message/chat/widgets/receiver_message.dart';
import 'package:aylahealth/screens/tabbar_screens/message/chat/widgets/sender_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/SharedPrefHelper.dart';
import '../../../../common/formtextfield/mytextfield.dart';
import 'firebase_services.dart';
import 'model/MessageModel.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Message> messages = [];

  @override
  void initState() {
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

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      backgroundColor: const Color(0xff1F2628),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorWhite,
        child: Column(
          children: [

            Expanded(
              child: ListView.separated(
                  controller: _scrollController,
                  itemCount: messages.length,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, position) {
                    Message message = messages[position];
                    return message.senderId ==
                            SharedPrefHelper.userId.toString()
                        ? SenderMessage(message: message,)
                        : ReceiverMessage(message: message);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 80),
              child: Container(
                child: messagefield(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 20, right: 20, top: 20, bottom: 80),
            //   child: Container(
            //     child: Row(
            //       children: [
            //         Flexible(
            //           child: TextFormField(
            //       controller: messageController,
            //       maxLines: 1,
            //       obscureText: false,
            //
            //       decoration: InputDecoration(
            //         hintText: 'Send a message....',
            //
            //       ),
            //     )
            //
            //
            //           // TextFormField_Common(
            //           //     textEditingController: messageController,
            //           //     textColor: Color(0xffAB8D60),
            //           //     hintText: 'type message....',
            //           //     textInputType: TextInputType.emailAddress,
            //           //     maxLines: 1,
            //           //     obscureText: false),
            //         ),
            //
            //         InkWell(
            //             onTap: () async {
            //               if (messageController.text.trim().isNotEmpty) {
            //                 await FirebaseData.instance.userUpdateTime();
            //                 await FirebaseData.instance.sendMessage(Message(
            //                     text: messageController.text,
            //                     created: FieldValue.serverTimestamp(),
            //                     receiverId: "1",
            //                     senderId: SharedPrefHelper.userId.toString()));
            //                 messageController.clear();
            //                 _scrollController.animateTo(
            //                     _scrollController.position.maxScrollExtent,
            //                     duration: const Duration(milliseconds: 500),
            //                     curve: Curves.easeOut);
            //               } else {}
            //             },
            //             child:Icon(Icons.send)),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  Widget messagefield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // key: Key("email1"),
             floatingLabelBehavior: FloatingLabelBehavior.never,

            hintText: 'Send a message....',

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            suffixIcon: TextButton(
                onPressed: () async {

                    if (messageController.text.trim().isNotEmpty) {
                      await FirebaseData.instance.userUpdateTime();
                      await FirebaseData.instance.sendMessage(Message(
                          text: messageController.text,
                          created: FieldValue.serverTimestamp(),
                          receiverId: "74",
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

            controller: messageController,
            autofillHints: [AutofillHints.email],
            textInputAction: TextInputAction.send,

            keyBoardType: TextInputType.emailAddress,
            validatorFieldValue: 'email',

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


      backgroundColor: colorWhite,
    );
  }
}
