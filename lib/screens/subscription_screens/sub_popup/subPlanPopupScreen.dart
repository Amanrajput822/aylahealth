import 'dart:io';

import 'package:aylahealth/screens/subscription_screens/subscriptionProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/styles/const.dart';


class subPlanPopupScreen extends StatefulWidget {
  const subPlanPopupScreen({Key? key}) : super(key: key);

  @override
  State<subPlanPopupScreen> createState() => _subPlanPopupScreenState();
}

class _subPlanPopupScreenState extends State<subPlanPopupScreen> {
  @override
  void initState() {
    super.initState();
    _initializePurchases();
  }


  Future<void> _initializePurchases() async {
    final SubscriptionProviderData = Provider.of<SubscriptionProvider>(context, listen: false);
    await FlutterInappPurchase.instance.initialize();
    // Fetch products
    try {
      List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(SubscriptionProviderData.productLists);

      SubscriptionProviderData.productsFunction(items);

      FlutterInappPurchase.purchaseUpdated.listen((purchase) {
        if (purchase != null) {

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
    // print("transactionReceipt:${purchase.transactionReceipt.toString()}");
    print("transactionStateIOS:${purchase.transactionStateIOS.toString()}");

    bool isVerified = false;
    if (purchase.purchaseStateAndroid == PurchaseState.purchased ||
        purchase.transactionStateIOS == TransactionState.purchased) {

      isVerified = await _verifyPurchase(purchase);

      print("isVerified :${isVerified}");
      if (isVerified) {
        //  _sendPurchaseDetailsToAPI(purchase);
        SubscriptionProviderData.sendPurchaseDetailsToAPI(context,purchase,'popupScreen');

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
  @override
  Widget build(BuildContext context) {
    final SubscriptionProviderData = Provider.of<SubscriptionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorWhite// Circular container
        ),
        height: deviceheight(context),
        width: deviceWidth(context),
        padding: EdgeInsets.only(left: 15,right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedboxheight(10.0),
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
              sizedboxheight(10.0),
              Text('This is a premium feature. To access you’ll need to upgrade to one of our subscription plans.',

                style: TextStyle(
                  fontSize: 13,
                  fontFamily: fontFamilyText,
                  color: colorTextFieldHintText,
                  fontWeight: fontWeight400,
                ),
                textAlign: TextAlign.center,
              ),
              sizedboxheight(10.0),
              Text('As a premium user you’ll be able to:',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight400,
                ),
                textAlign: TextAlign.start,
              ).paddingOnly(left: 2,right: 2),
              sizedboxheight(10.0),
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
                            width: deviceWidth(context,0.79),
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
                              ),
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

                child:SubscriptionProviderData.loading?
                Center(child: CircularProgressIndicator()):
                ListView.builder(
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
                                      Row(
                                        children: [
                                          Text('${product.localizedPrice.toString()}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: fontFamilyText,
                                              color: colorRichblack,
                                              fontWeight: fontWeight600,
                                            ),
                                          ),
                                          // SubscriptionProviderData.customerSubscriptionDetailsData!.planId ==product.productId?
                                          // Icon(Icons.star,size: 12,color: colorBluePigment,):Container()
                                        ],
                                      ),

                                    ],
                                  ),
                                  sizedboxheight(5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: deviceWidth(context)-200,
                                        child: Text('${product.currency}${(getPrice(product.price) / (product.title!.split("(")[0].toString().trim() == 'Annual'?12:getSubscriptionPeriodNumber(product))).toStringAsFixed(2)}/month, billed ${product.title!.split("(")[0].toString()}.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: fontFamilyText,
                                            color: colorRichblack,
                                            fontWeight: fontWeight400,
                                          ),
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
              sizedboxheight(50.0),

            ],
          ),
        ),
      )

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
        btnColor:SubscriptionProviderData.customerSubscriptionDetailsData == null?(SubscriptionProviderData.selectSubscription != null?colorEnabledButton:colorShadowBlue):colorShadowBlue,
        onPressed: () async {
          print("customerSubscriptionDetailsData: ${SubscriptionProviderData.customerSubscriptionDetailsData != null}");
          if(SubscriptionProviderData.customerSubscriptionDetailsData == null){
            if(SubscriptionProviderData.selectSubscription != null){
              SubscriptionProviderData.loadingPlanPurchaseFunction(true);
              // FlutterInappPurchase.instance.requestSubscription(item.productId!);
              // FlutterInappPurchase.instance.requestPurchase(item.productId!);
              try {
                //_initializePurchases(SubscriptionProviderData.selectSubscription!.productId!);
                // await FlutterInappPurchase.instance.requestSubscription(SubscriptionProviderData.selectSubscription!.productId!);
                await  FlutterInappPurchase.instance.requestSubscription(item.productId!);
              } catch (e) {
                FlutterToast_message('Subscription failed: $e');
                SubscriptionProviderData.loadingPlanPurchaseFunction(false);

              }
            }else{
              FlutterToast_message('Select subscription');
            }
          }else{
            FlutterToast_message('User plan already purchased.');
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
