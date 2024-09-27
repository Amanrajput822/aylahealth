// import 'dart:convert';
//
// import 'package:aylahealth/screens/subscription_screens/success_screen.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../common/commonwidgets/button.dart';
// import '../../common/new_bottombar_screen/New_Bottombar_Screen.dart';
// import '../../common/styles/Fluttertoast_internet.dart';
// import '../../common/styles/const.dart';
//
//
//
//
//
// class SubscriptionScreen extends StatefulWidget {
//   @override
//   _SubscriptionScreenState createState() => new _SubscriptionScreenState();
// }
//
// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   late dynamic _purchaseUpdatedSubscription;
//   late dynamic _purchaseErrorSubscription;
//   late dynamic _connectionSubscription;
//   final List<String> _productLists = Platform.isAndroid
//
//       // ?['aylahealth_1month','aylahealth_1year','aylahealth_3months']
//      ?['android.test.purchased','android.test.canceled']
//       : ['Ayla_Health_1month', 'Ayla_Health_3months','Ayla_Health_1year'];
//
//   List<IAPItem> _items = [];
//   List<PurchasedItem> _purchases = [];
//   IAPItem? selectSubscription = null;
//   int selectedIndex = -1;
//
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//
//     _loadSelectedSubscription();
//
//   }
//   Future<void> _loadSelectedSubscription() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? selectedProductId = prefs.getString('selectedProductId');
//     if (selectedProductId != null && _items.any((item) => item.productId == selectedProductId)) {
//       setState(() {
//         selectSubscription = _items.firstWhere((item) => item.productId == selectedProductId);
//         selectedIndex = _items.indexOf(selectSubscription!);
//       });
//     }
//   }
//
//   void _saveSelectedSubscription(IAPItem item) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedProductId', item.productId!);
//     setState(() {
//       selectSubscription = item;
//       selectedIndex = _items.indexOf(item);
//     });
//   }
//   @override
//   void dispose() {
//     if (_connectionSubscription != null) {
//       _connectionSubscription.cancel();
//       _connectionSubscription = null;
//     }
//     super.dispose();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     // prepare
//     var result = await FlutterInappPurchase.instance.initialize();
//     print('result: ${result}');
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     // refresh items for android
//     try {
//       String msg = await FlutterInappPurchase.instance.consumeAll();
//       print('consumeAllItems: $msg');
//     } catch (err) {
//       print('consumeAllItems error: $err');
//     }
//
//     _connectionSubscription =
//         FlutterInappPurchase.connectionUpdated.listen((connected) {
//           print('connected: $connected');
//         });
//
//     _purchaseUpdatedSubscription =
//         FlutterInappPurchase.purchaseUpdated.listen((productItem) {
//           print('purchase-updated: $productItem');
//
//         });
//
//     _purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//           print('purchase-error: $purchaseError');
//         });
//     this._getProduct();
//   }
//
//   void _requestPurchase(IAPItem item) {
//     FlutterInappPurchase.instance.requestPurchase(item.productId!);
//   }
//
//   Future _getProduct() async {
//     print('_productLists: ${_productLists}');
//     List<IAPItem> items =
//     await FlutterInappPurchase.instance.getProducts(_productLists);
//
//     print('items: $items');
//     for (var item in items) {
//       print('${item.toString()}');
//       this._items.add(item);
//     }
//
//     setState(() {
//       this._items = items;
//       this._purchases = [];
//     });
//   }
//
//
//
//   List<Widget> _renderInApps() {
//     List<Widget> widgets = this
//         ._items
//         .map((item) =>
//         Column(
//           children: [
//             InkWell(
//               onTap: (){
//                 setState(() {
//                   selectSubscription = item;
//                   selectedIndex = _items.indexOf(item);
//                   _saveSelectedSubscription(item);
//                 });
//
//               },
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: selectedIndex == _items.indexOf(item) ? HexColor('#A7E4F2'):  HexColor('#F6F8F9'),
//                       // color:  HexColor('#F6F8F9'),
//                       borderRadius: BorderRadius.circular(5)
//                   ),
//                   padding: EdgeInsets.all(10),
//                   width: deviceWidth(context),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(item.title.toString(),
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontFamily: fontFamilyText,
//                               color: colorRichblack,
//                               fontWeight: fontWeight700,
//                             ),
//                           ),
//                           Text('${item.localizedPrice.toString()}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontFamily: fontFamilyText,
//                               color: colorRichblack,
//                               fontWeight: fontWeight600,
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('${item.currency}${(item.price == null?0.0:int.parse(item.price!) / (item.title == 'Annual'?12:int.parse(item.subscriptionPeriodNumberIOS.toString()))).toStringAsFixed(2)}/month, billed ${item.title.toString()}.',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontFamily: fontFamilyText,
//                               color: colorRichblack,
//                               fontWeight: fontWeight400,
//                             ),
//                           ),
//                           item.description!.isEmpty?Container(): Container(
//                             decoration: BoxDecoration(
//                                 color: colorWhite,
//                                 borderRadius: BorderRadius.circular(5)
//                             ),
//                             width: 150,
//                             child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Center(
//                                 child: Text(item.description.toString(),
//                                   maxLines: 2,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: fontFamilyText,
//                                     color: colorRichblack,
//                                     fontWeight: fontWeight400,
//                                     overflow: TextOverflow.ellipsis
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             sizedboxheight(deviceheight(context,0.01)),
//
//           ],
//         )
//
//     )
//         .toList();
//     return widgets;
//   }
//   Widget joinBtn(context, item) {
//     return Container(
//       alignment: Alignment.center,
//       child: Button(
//         buttonName: 'Join now!',
//         textColor: colorWhite,
//         borderRadius: BorderRadius.circular(8.00),
//         btnWidth: deviceWidth(context),
//         btnColor:selectSubscription != null?colorEnabledButton:colorShadowBlue,
//         onPressed: () {
//           if(selectSubscription != null){
//             this._requestPurchase(item);
//           }else{
//             FlutterToast_message('Select subscription');
//           }
//           // bottomsheetmodel();
//
//           //  Get.to(() => Pre_Question_Screen());
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width - 20;
//     double buttonWidth = (screenWidth / 3) - 20;
//
//     return Scaffold(
//       backgroundColor: colorWhite,
//       body: Container(
//         width: deviceWidth(context),
//         height: deviceheight(context),
//         padding: EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//
//               sizedboxheight(deviceheight(context,0.1)),
//               Align(
//                 alignment: Alignment.center,
//                 child: Text('Subscription',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontFamily: 'Playfair Display',
//                     color: colorPrimaryColor,
//                     fontWeight: fontWeight500,
//                   ),
//                 ),
//               ),
//               sizedboxheight(deviceheight(context,0.05)),
//               Text('Choose your subscription level to unlock premium features.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontFamily: fontFamilyText,
//                   color: colorRichblack,
//                   fontWeight: fontWeight400,
//                 ),
//                 textAlign: TextAlign.start,
//               ).paddingOnly(left: 2,right: 2),
//               sizedboxheight(deviceheight(context,0.02)),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: this._renderInApps(),
//               ),
//               joinBtn(context, selectSubscription).paddingOnly(left: 2,right: 2),
//               sizedboxheight(deviceheight(context,0.02)),
//               Align(
//                 alignment: Alignment.center,
//                 child: InkWell(
//                   onTap: (){
//                     Get.offAll(() => New_Bottombar_Screen());
//                   },
//                   child: Text('Sign up later',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontFamily: fontFamilyText,
//                       color: colorBluePigment,
//                       fontWeight: fontWeight400,
//                     ),
//                   ),
//                 ),
//               ),
//               sizedboxheight(deviceheight(context,0.1)),
//
//               Align(
//                 alignment:Alignment.bottomCenter,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text('Terms of use',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontFamily: fontFamilyText,
//                         color: colorShadowBlue,
//                         fontWeight: fontWeight400,
//                       ),
//                     ),
//                     Text('Privacy & cookies',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontFamily: fontFamilyText,
//                         color: colorShadowBlue,
//                         fontWeight: fontWeight400,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               // Column(
//               //   mainAxisSize: MainAxisSize.min,
//               //   children: this._renderPurchases(),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Future bottomsheetmodel(){
//     return   showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       // color is applied to main screen when modal bottom screen is displayed
//       //background color for modal bottom screen
//       backgroundColor: HexColor('#EBEBEB'),
//       //elevates modal bottom screen
//       elevation: 10,
//       // gives rounded corner to modal bottom screen
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       builder: (BuildContext context) {
//         // UDE : SizedBox instead of Container for whitespaces
//         return Container(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Image.asset('assets/Pay.png',width: 70),
//                     InkWell(
//                         onTap: (){
//                           Navigator.pop(context);
//                         },
//                         child: SvgPicture.asset('assets/Close Button Light.svg')),
//
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Container(
//
//                   decoration: BoxDecoration(
//                       color: colorWhite,
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   padding: const EdgeInsets.all(15.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//
//                           Image.asset('assets/Card Icon.png',
//                             width: deviceWidth(context,0.1),),
//
//                           sizedboxwidth(deviceWidth(context,0.04)),
//                           Container(
//                             width: deviceWidth(context,0.6),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Apple Card',
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     fontFamily: 'SP Fonts',
//                                     color: colorBlack,
//                                     fontWeight: fontWeight400,
//                                   ),),
//                                 Text('•••• 1234',
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontFamily: 'SP Fonts',
//                                       color: HexColor('#3C3C43').withOpacity(0.6),
//                                       fontWeight: fontWeight400,
//                                       overflow: TextOverflow.ellipsis
//                                   ),
//                                   maxLines: 1,
//                                 ),
//                                 Text('27 Fredrick Butte Rd, Brothers ',
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontFamily: 'SP Fonts',
//                                       color: HexColor('#3C3C43').withOpacity(0.6),
//                                       fontWeight: fontWeight400,
//                                       overflow: TextOverflow.ellipsis
//                                   ),
//                                   maxLines: 1,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       Container(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset('assets/Vector.svg',
//                               width: deviceWidth(context,0.1),height: 20,),
//                           ],
//
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               Container(
//                 color: colorWhite,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Divider(
//                       height: 0.5,
//                       color: HexColor('#C6C6C8'),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: (){
//                               Get.to(() => Success_Screen());
//                             },
//                             child: Container(
//                               width: deviceWidth(context,0.7),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Pay PACSUN',style: TextStyle(
//                                     fontSize: 15,
//                                     fontFamily: 'SP Fonts',
//                                     color: HexColor('#3C3C43').withOpacity(0.6),
//                                     fontWeight: fontWeight400,
//                                   )),
//                                   Text('\$85.00',style: TextStyle(
//                                     fontSize: 30,
//                                     fontFamily: 'SP Fonts',
//                                     color: colorBlack,
//                                     fontWeight: fontWeight400,
//                                   )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset('assets/Vector.svg',
//                                     width: deviceWidth(context,0.1),height: 20,),
//                                 ],
//                               )
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(
//                       height: 0.5,
//                       color: HexColor('#C6C6C8'),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(15),
//                       child: Column(
//                         children: [
//                           SvgPicture.asset('assets/Glyph - Confirm with Button.svg',),
//
//                           Text('Confirm with Side Button',style: TextStyle(
//                             fontSize: 15,
//                             fontFamily: 'SP Fonts',
//                             color: colorBlack,
//                             fontWeight: fontWeight400,
//                           )),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
