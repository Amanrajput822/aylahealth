import 'dart:convert';

import 'package:aylahealth/screens/subscription_screens/subscriptionProvider.dart';
import 'package:aylahealth/screens/subscription_screens/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/new_bottombar_screen/New_Bottombar_Screen.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/styles/const.dart';
import 'package:http/http.dart' as http;


class Subscription_screen extends StatefulWidget {
   String? screenName;

   Subscription_screen({Key? key, this.screenName}) : super(key: key);
  @override
  _Subscription_screenState createState() => new _Subscription_screenState();
}

class _Subscription_screenState extends State<Subscription_screen> {

   List<PurchasedItem> _purchases = [];
   PurchasedItem? purchaseData;
  @override
  void initState() {
    super.initState();

   // final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);

    print('initState function call');
    _initializePurchases();
   // subscriptionProvider.customerSubscriptionDetailsAPI(context);
  }


  Future<void> _initializePurchases() async {
    final SubscriptionProviderData = Provider.of<SubscriptionProvider>(context, listen: false);
     await FlutterInappPurchase.instance.initialize();
    // Fetch products
    try {
    List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(SubscriptionProviderData.productLists);
    setState(() {
      SubscriptionProviderData.productsFunction(items);
      //  _products = items;
    });


    FlutterInappPurchase.purchaseUpdated.listen((purchase) {
      if (purchase != null) {
        purchaseData = purchase;
        _handlePurchaseUpdates(purchase);
        print('initializePurchases function call');
        SubscriptionProviderData.loadingPlanPurchaseFunction(false);
      }
    });

    FlutterInappPurchase.purchaseError.listen((purchaseError) {
      // Handle purchase error
      FlutterToast_message('Purchase Error: ${purchaseError!.message}');
      SubscriptionProviderData.loadingPlanPurchaseFunction(false);
    });


    } catch (e) {
      // Handle errors during the subscription process
      _showErrorDialog(context,'Purchase Error', e.toString());
      SubscriptionProviderData.loadingPlanPurchaseFunction(false);
    }
  }


  // Future<void> _fetchPreviouslyPurchasedPlan() async {
  //   final SubscriptionProviderData = Provider.of<SubscriptionProvider>(context, listen: false);
  //
  //   // Replace with your API endpoint to fetch the user's previously purchased plan
  //   final response = await http.get(Uri.parse('https://your-backend-api.com/get-purchased-plan'));
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final productId = data['productId'];
  //
  //     for (int i = 0; i < SubscriptionProviderData.products.length; i++) {
  //       if (SubscriptionProviderData.products[i].productId == productId) {
  //         setState(() {
  //           SubscriptionProviderData.selectedIndexFunction(i);
  //           SubscriptionProviderData.selectSubscriptionFunction(SubscriptionProviderData.products[i]);
  //        //   selectSubscription = SubscriptionProviderData.products[i];
  //         });
  //         break;
  //       }
  //     }
  //   } else {
  //     FlutterToast_message('Failed to fetch previously purchased plan.');
  //   }
  // }

  void _handlePurchaseUpdates(PurchasedItem purchase) async{
    final SubscriptionProviderData = Provider.of<SubscriptionProvider>(context, listen: false);

      SubscriptionProviderData.purchases!.add(purchase);

    print("transactionDate:${purchase.transactionDate.toString()}");
    print("signatureAndroid:${purchase.signatureAndroid.toString()}");
    print("transactionDate:${purchase.productId.toString()}");
    print("autoRenewingAndroid:${purchase.autoRenewingAndroid.toString()}");
    print("dataAndroid:${purchase.dataAndroid.toString()}");
    print("isAcknowledgedAndroid:${purchase.isAcknowledgedAndroid.toString()}");
    print("originalTransactionDateIOS:${purchase.originalTransactionDateIOS.toString()}");
    print("originalTransactionIdentifierIOS:${purchase.originalTransactionIdentifierIOS.toString()}");
    print("purchaseStateAndroid:${purchase.purchaseStateAndroid.toString()}");
    print("purchaseToken:${purchase.purchaseToken.toString()}");
    print("transactionId:${purchase.transactionId.toString()}");
     print("transactionReceipt:${purchase.transactionReceipt.toString()}");
    print("transactionStateIOS:${purchase.transactionStateIOS.toString()}");

    bool isVerified = false;
    if (purchase.purchaseStateAndroid == PurchaseState.purchased ||
        purchase.transactionStateIOS == TransactionState.purchased) {

       isVerified = await _verifyPurchase(purchase);

      print("isVerified :${isVerified}");
      if (isVerified) {
      //  _sendPurchaseDetailsToAPI(purchase);
        SubscriptionProviderData.sendPurchaseDetailsToAPI(context,purchase,'subScreen');

       // paymentFailureDialog( context);
        // Navigate to success screen or update UI
         isVerified = false;
        print('Purchase verified and processed.');
      } else {
        FlutterToast_message('Purchase verification failed.');
        print('Purchase verification failed.');
        SubscriptionProviderData.paymentFailureDialog( context);
      }
      // Verify purchase and deliver the content
    }else if (purchase.purchaseStateAndroid == PurchaseState.pending ||
        purchase.transactionStateIOS == TransactionState.deferred) {
      FlutterToast_message('Purchase is pending or deferred.');
    } else {
      FlutterToast_message('Purchase failed or canceled.');
    }
  }

  Future<bool> _verifyPurchase(PurchasedItem purchase) async {
    if (purchase.purchaseStateAndroid == PurchaseState.purchased ||
        purchase.transactionStateIOS == TransactionState.purchased) {
      return true;
    } else if (purchase.purchaseStateAndroid == PurchaseState.pending ||
        purchase.transactionStateIOS == TransactionState.deferred) {
      FlutterToast_message('Purchase is pending or deferred.');
      return false;
    } else {
      FlutterToast_message('Purchase failed or canceled.');
      return false;
    }
  }


  bool isValidNumber(String s) {
    return RegExp(r'^\d+$').hasMatch(s);
  }

  double getPrice(product) {
    return double.parse(product ?? '0');
  }

  int getSubscriptionPeriodNumber(product) {
    if (product.subscriptionPeriodNumberIOS != null) {
      return int.parse(product.subscriptionPeriodNumberIOS.toString());
    } else if (product.subscriptionPeriodAndroid != null) {
      String periodString = product.subscriptionPeriodAndroid.toString();
      if (periodString.startsWith('P') && periodString.endsWith('M')) {
        String numberString = periodString.substring(1, periodString.length - 1);
        return int.parse(numberString);
      } else {
        return 1; // or some other default value
      }
    } else {
      return 1; // or some other default value
    }
  }
  /// url launch function
   void _launchURL(String url) async {
     final Uri _url = await Uri.parse(url);
     if (!await launchUrl(_url)) {
       throw Exception('Could not launch $_url');
     }
   }

  @override
  void dispose() {
    super.dispose();
    FlutterInappPurchase.instance.finalize();

  }
  // bool value = true;
  // bool loader  = true;
  @override
  Widget build(BuildContext context) {
    final SubscriptionProviderData = Provider.of<SubscriptionProvider>(context);

    return Scaffold(
      backgroundColor: colorWhite,

      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

               sizedboxheight(deviceheight(context,0.05)),
              // widget.screenName== "Setting"? IconButton(onPressed: (){
              //
              // }, icon: Icon(Icons.arrow_back_ios_new,color: colorRichblack,)):Container(),
              Align(
                alignment: Alignment.center,
                child: Text('Go Premium',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Playfair Display',
                    color: colorPrimaryColor,
                    fontWeight: fontWeight500,
                  ),
                ),
              ),
              sizedboxheight(20.0),
              Text('As a premium user you’ll be able to:',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight400,
                ),
                textAlign: TextAlign.start,
              ).paddingOnly(left: 2,right: 2),
             // sizedboxheight(deviceheight(context,0.01)),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: SubscriptionProviderData.premiumListPoint.length,
                  itemBuilder: (BuildContext context,int index)
                  {
                    return Container(
                      padding: EdgeInsets.only(bottom: 7),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(SubscriptionProviderData.premiumListPoint[index].image),
                          Container(
                            width: deviceWidth(context,0.85),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3,left: 2,right: 2),
                              child: Text(SubscriptionProviderData.premiumListPoint[index].title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontFamilyText,
                                  color: colorTextFieldHintText,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.start,
                              ).paddingOnly(left: 2,right: 2),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

              sizedboxheight(10.0),
              Text('Choose your subscription frequency to get started:',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight400,
                ),
                textAlign: TextAlign.start,
              ).paddingOnly(left: 2,right: 2),
              sizedboxheight(10.0),
              Container(

                child:SubscriptionProviderData.loading?Center(child: CircularProgressIndicator()): ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: SubscriptionProviderData.products.length,
                  itemBuilder: (context, index) {
                    final product = SubscriptionProviderData.products[index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                             // selectSubscription = product;
                              SubscriptionProviderData.selectSubscriptionFunction(product);
                             // selectedIndex = index;
                              SubscriptionProviderData.selectedIndexFunction(index);
                             // _saveSelectedSubscription(product,index);
                            //  SubscriptionProviderData.saveSelectedSubscription(context,product,index);
                            });

                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: SubscriptionProviderData.selectedIndex == index ? HexColor('#A7E4F2'):  HexColor('#F6F8F9'),
                                  // color:  HexColor('#F6F8F9'),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.all(10),
                              width: deviceWidth(context),
                              child: Column(
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(product.title!.split("(")[0].toString(),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: fontFamilyText,
                                          color: colorRichblack,
                                          fontWeight: fontWeight700,
                                        ),
                                      ),
                                      Text('${product.localizedPrice.toString()}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: fontFamilyText,
                                          color: colorRichblack,
                                          fontWeight: fontWeight600,
                                        ),
                                      ),

                                    ],
                                  ),
                                  sizedboxheight(5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${product.currency}${(getPrice(product.price) / (product.title!.split("(")[0].toString().trim() == 'Annual'?12:getSubscriptionPeriodNumber(product))).toStringAsFixed(2)}/month, billed ${product.title!.split("(")[0].toString()}.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fontFamilyText,
                                          color: colorRichblack,
                                          fontWeight: fontWeight400,
                                        ),
                                      ),
                                      product.description!.isEmpty?Container(
                                        height: 25,
                                      ): Container(
                                        decoration: BoxDecoration(
                                            color:SubscriptionProviderData.selectedIndex == index ?colorWhite: HexColor('#443DF6'),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text("${product.description.toString()}!",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: fontFamilyText,
                                                  color:SubscriptionProviderData.selectedIndex == index ?colorBlackRichBlack: colorWhite,
                                                  fontWeight: fontWeight400,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        sizedboxheight(6.0),

                      ],
                    );

                  },
                ),
              ),
              sizedboxheight(8.0),
          SubscriptionProviderData.loadingPlanPurchase?Center(
            child: CircularProgressIndicator(), // Show loading spinner
          ): joinBtn(context, SubscriptionProviderData.selectSubscription).paddingOnly(left: 2,right: 2),


              sizedboxheight(15.0),
               Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    Get.offAll(() => New_Bottombar_Screen());
                  },
                  child: Text('Continue as a free user',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: fontFamilyText,
                      color: colorBluePigment,
                      fontWeight: fontWeight400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              sizedboxheight(10.0),

              Align(
                alignment:Alignment.bottomCenter,
                child:RichText(
                  textAlign: TextAlign.center,

                  text:  TextSpan(
                    text: 'By clicking ‘Join now’, you agree to the ',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyText,
                      color: colorShadowBlue,
                      fontWeight: fontWeight400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Terms & Conditions',
                          style:  TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamilyText,
                            color: colorRichblack,
                            fontWeight: fontWeight400,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {

                              _launchURL('https://aylahealth.com.au/terms-conditions/');
                              //Code to launch your URL
                            }
                      ),
                      TextSpan(
                          text: ' and ',
                          style:  TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamilyText,
                            color: colorShadowBlue,
                            fontWeight: fontWeight400,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {


                              //Code to launch your URL
                            }
                      ),
                      TextSpan(
                          text: 'Privacy Policy.',
                          style:  TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamilyText,
                            color: colorRichblack,
                            decoration: TextDecoration.underline,
                            fontWeight: fontWeight400,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {

                              _launchURL('https://aylahealth.com.au/privacy-policy/');
                              //Code to launch your URL
                            }
                      ),
                    ],
                  ),
                ),
              ),
              sizedboxheight(30.0),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: this._renderPurchases(),
              // ),
            ],
          ),
        ),
      ),
    );

  }
  Widget joinBtn(context, item) {
    final SubscriptionProviderData = Provider.of<SubscriptionProvider>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Join now!',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor:SubscriptionProviderData.selectSubscription != null?colorEnabledButton:colorShadowBlue,
        onPressed: () async {

            if(SubscriptionProviderData.selectSubscription != null){
              SubscriptionProviderData.loadingPlanPurchaseFunction(true);
             // FlutterInappPurchase.instance.requestSubscription(item.productId!);
             // FlutterInappPurchase.instance.requestPurchase(item.productId!);
              try {
                //_initializePurchases(SubscriptionProviderData.selectSubscription!.productId!);
               // await FlutterInappPurchase.instance.requestSubscription(SubscriptionProviderData.selectSubscription!.productId!);
               // await  FlutterInappPurchase.instance.requestPurchase(item.productId!);
               // await  FlutterInappPurchase.instance.requestPurchase(SubscriptionProviderData.selectSubscription!.productId!);
                await FlutterInappPurchase.instance.requestSubscription(SubscriptionProviderData.selectSubscription!.productId!);
              } catch (e) {
                SubscriptionProviderData.loadingPlanPurchaseFunction(false);
                FlutterToast_message('Subscription failed: $e');
              }
            }else{
              FlutterToast_message('Select subscription');
            }


          // bottomsheetmodel();

          //  Get.to(() => Pre_Question_Screen());
        },
      ),
    );
  }



  /// Error Dialog //
  void _showErrorDialog(BuildContext context,String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: fontFamilyText, // Assuming you have this defined
              color: colorBlack, // Assuming you have this defined
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontFamily: fontFamilyText, // Assuming you have this defined
                color: colorRichblack, // Assuming you have this defined
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText, // Assuming you have this defined
                  color: colorBluePigment, // Assuming you have this defined
                  fontWeight: fontWeight900,
                ),
              ),
            ),
            //  Uncomment the following code if you want to add "Manage Subscription" action
          ],
        );
      },
    );
  }
}
