import 'dart:convert';
import 'dart:io';

import 'package:aylahealth/screens/subscription_screens/sub_popup/subscription_plan_popup.dart';
import 'package:aylahealth/screens/subscription_screens/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/api_common_fuction.dart';
import '../../../common/check_screen.dart';
import '../../../common/direct_logout.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../models/home model/RecipeCollectionListModel.dart';
import '../../../models/meals plans/MealPlaneLestData_Model.dart';
import '../../../models/meals plans/Meal_Plan_Date_Data_model.dart';
import '../../../models/recipelist/RecipeList_data_model.dart';
import '../../../models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import '../../../models/recipelist/recipe_like_unlike_data_model.dart';
import '../../common/SharedPrefHelper.dart';
import '../../common/styles/const.dart';
import '../../models/subscription/addCustomerSubscriptionDetailsModel.dart';
import '../../models/subscription/checkSubscriptionApiModel.dart';
import '../../models/subscription/customerSubscriptionDetailsModel.dart';
import 'Subscription.dart';



class SubscriptionProvider extends ChangeNotifier {

  int? _success ;
  int? get success => _success;

  String? _user_id ;
  String? get user_id => _user_id;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;


  bool _loading = false;
  bool get loading => _loading;
  void loaderFunction(newMessage){
    _loading = newMessage;
    notifyListeners();
  }

  bool _loadingPlanPurchase = false;
  bool get loadingPlanPurchase => _loadingPlanPurchase;
  void loadingPlanPurchaseFunction(newMessage){
    _loadingPlanPurchase = newMessage;
    notifyListeners();
  }

  List<PremiumFeature> premiumListPoint = [
    PremiumFeature(
      image: "assets/done icon/Group 9781.png",
      title: "Access our revolutionary habit building modules.",
    ),
    PremiumFeature(
      image: "assets/done icon/Group 9782.png",
      title: "Get product, food and recipe ideas for your new habits.",
    ),
    PremiumFeature(
      image: "assets/done icon/Group 9783.png",
      title: "Plan your meals and snacks to stay organised.",
    ),
    PremiumFeature(
      image: "assets/done icon/Group 9784@2x.png",
      title: "Connect with a qualified nutritionist on live chat.",
    ),
    PremiumFeature(
      image: "assets/done icon/Group 9785.png",
      title: "Generate shopping lists and notes.",
    ),
  ];


  final List<String> productLists = Platform.isAndroid
      ?['aylahealth_1month','aylahealth_1year','aylahealth_3months']
      : ['Ayla_Health_1month', 'Ayla_Health_3months','Ayla_Health_1year'];


  List<IAPItem> _products = [];
  List<IAPItem> get products => _products;
  void productsFunction(newMessage){
    _products = newMessage;
    notifyListeners();
  }

  IAPItem? _selectSubscription = null;
  IAPItem? get selectSubscription => _selectSubscription;
  void selectSubscriptionFunction(newMessage){
    _selectSubscription = newMessage;
    notifyListeners();
  }

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;
  void selectedIndexFunction(newMessage){
    _selectedIndex = newMessage;
    notifyListeners();
  }

  List<PurchasedItem>? _purchases = [];
  List<PurchasedItem>? get purchases => _purchases;
  void purchasesFunction(newMessage){
    _purchases = newMessage;
    notifyListeners();
  }


  /// recipeList_ditels_api ///


  Future<addCustomerSubscriptionDetailsModel> sendPurchaseDetailsToAPI(context,PurchasedItem purchase,screenName ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    print(_tokanget.toString());
    check().then((intenet) async {
      // loaderFunction(true);

      if (intenet) {
      } else {
        FlutterToast_Internet();
      }
    });

    String dateTimeString = purchase.transactionDate.toString();
    DateTime dateTime = DateTime.parse(dateTimeString);

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(dateTime);

    print(formattedDate);

    Map toMapIos() {
      var map =  Map<String, dynamic>();
      map["sub_from"] = 2;
      map["receipt"] = purchase.transactionReceipt;

      return map;
    }
    Map toMapAndroid() {
      var map =  Map<String, dynamic>();
      map["sub_from"] = 1;
      if (purchase.transactionReceipt != null) {
        var receiptData = jsonDecode(purchase.transactionReceipt!);
        // Extract and add the required fields from receiptData
        map["orderId"] = receiptData["orderId"];
        map["productId"] = receiptData["productId"];
        map["purchaseTime"] = receiptData["purchaseTime"];
        map["purchaseState"] = receiptData["purchaseState"];
        map["purchaseToken"] = receiptData["purchaseToken"];
        map["packageName"] = receiptData["packageName"];
      }

      // map["plan_id"] = purchase.productId;
      // map["sub_transaction_id"] = purchase.transactionId;
      // map["sub_receipt"] = purchase.transactionReceipt;
      // map["sub_from"] = Platform.isAndroid?1:2;
      // map["sub_date"] = formattedDate;

      return map;
    }

    print(Platform.isAndroid?toMapAndroid().toString():toMapIos().toString());
    print(Endpoints.baseURL+Endpoints.subscribeApp.toString());

    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.subscribeApp),
        body: Platform.isAndroid?json.encode(toMapAndroid()):json.encode(toMapIos()),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );
    if(response.statusCode == 200 ){
      print(response.body.toString());
      print("response.body subscribeApp  ${response.body}");

      _success = (addCustomerSubscriptionDetailsModel.fromJson(json.decode(response.body)).status);
      _message = (addCustomerSubscriptionDetailsModel.fromJson(json.decode(response.body)).message);

      if (_success == 200) {
        Get.off(() => Success_Screen(screenName: screenName));
       // loaderFunction(false);
        FlutterToast_message(message);
        notifyListeners();
       // showPaymentSuccessDialog( context);
        checkSubscriptionAPI(context,'addAPI');
      } else {
       // loaderFunction(false);
        print('else==============');
        FlutterToast_message(message);
      }
    }else{
     // loaderFunction(false);
      notifyListeners();
      if(response.statusCode ==401){
        directLogOutPopup();
      }
      FlutterToast_message(json.decode(response.body)['message']);
    }

    return addCustomerSubscriptionDetailsModel.fromJson(json.decode(response.body));
  }

/// customer Subscription Details API ///
  customerSubscriptionDetailsResponse? _customerSubscriptionDetailsData;
  customerSubscriptionDetailsResponse? get customerSubscriptionDetailsData => _customerSubscriptionDetailsData;

  Future<customerSubscriptionDetailsModel> customerSubscriptionDetailsAPI(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = user_id!.replaceAll('"', '');
    print(_tokanget.toString());
    check().then((intenet) async {
      loaderFunction(true);

      if (intenet) {
      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map =  Map<String, dynamic>();
      map["cust_id"] = _user_id;

      return map;
    }
    print(toMap().toString());
    print(Endpoints.baseURL+Endpoints.customerSubscriptionDetails.toString());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.customerSubscriptionDetails),
        body: json.encode(toMap()),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );
    print(response.body);

    if(response.statusCode == 200 ){
      print("response.body  ${response.body}");
      print("response.body  ${customerSubscriptionDetailsModel.fromJson(json.decode(response.body)).data}");
      if(customerSubscriptionDetailsModel.fromJson(json.decode(response.body)).data == null){
        loaderFunction(false);
      }

      _success = (customerSubscriptionDetailsModel.fromJson(json.decode(response.body)).status);
     // _message = (customerSubscriptionDetailsModel.fromJson(json.decode(response.body)).data);

      if (_success == 200) {
        _customerSubscriptionDetailsData = (customerSubscriptionDetailsModel.fromJson(json.decode(response.body)).data);

        // loadSelectedSubscription(context,customerSubscriptionDetailsData!.planId);

        purchasePlanFunction(context);
      //  loaderFunction(false);
       // FlutterToast_message('Purchase details sent successfully.');
        notifyListeners();

      } else {
        loaderFunction(false);
        print('else==============');
        FlutterToast_message('Failed to send purchase details.');
      }
    }else{
      loaderFunction(false);
      notifyListeners();
      if(response.statusCode ==401){
        directLogOutPopup();
      }
      FlutterToast_message(json.decode(response.body)['message']);
    }

    return customerSubscriptionDetailsModel.fromJson(json.decode(response.body));
  }


 /// check subscription api using for complete app

  int? _isActiveSubscription;
  int? get isActiveSubscription => _isActiveSubscription;

  int? _isExpiredSubscription;
  int? get isExpiredSubscription => _isExpiredSubscription;

  String? _expiresSubscriptionDate;
  String? get expiresSubscriptionDate => _expiresSubscriptionDate;

  int? _isCanceledSubscription;
  int? get isCanceledSubscription => _isCanceledSubscription;

  Future<checkSubscriptionApiModel> checkSubscriptionAPI(context,subCheckScreenName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');

    check().then((intenet) async {
      loaderFunction(true);

      if (intenet) {
      } else {
        FlutterToast_Internet();
      }
    });
    print(Endpoints.baseURL+Endpoints.checkSubscription.toString());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.checkSubscription),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    print(response.body);

    if(response.statusCode == 200 ){
      print("response.body  ${response.body}");

      _success = (checkSubscriptionApiModel.fromJson(json.decode(response.body)).status);

      if (_success == 200) {
        _isActiveSubscription  =(checkSubscriptionApiModel.fromJson(json.decode(response.body)).isActive);
        _isExpiredSubscription =(checkSubscriptionApiModel.fromJson(json.decode(response.body)).isExpired);
        _expiresSubscriptionDate =(checkSubscriptionApiModel.fromJson(json.decode(response.body)).expiresDate);
        _isCanceledSubscription =(checkSubscriptionApiModel.fromJson(json.decode(response.body)).isCanceled);
        if (['menageSubScreen', 'addAPI', 'LoginScreen'].contains(subCheckScreenName)) {
          if (_isActiveSubscription == 1) {
            customerSubscriptionDetailsAPI(context);
          } else if (_isActiveSubscription == 0) {
            if(['menageSubScreen'].contains(subCheckScreenName)){
              customerSubscriptionDetailsAPI(context);
            }
            loaderFunction(false);
          }
        }

        SharedPrefHelper.subscriptionStatus =  _isActiveSubscription == 1?true:false;
        SharedPrefHelper.subscriptionCancelStatus =  _isCanceledSubscription??0;
        notifyListeners();

      } else {
        loaderFunction(false);
        print('else==============');
        FlutterToast_message('Failed to send purchase details.');
      }
    }else{
      loaderFunction(false);
      notifyListeners();
      if(response.statusCode ==401){
        directLogOutPopup();
      }
      FlutterToast_message(json.decode(response.body)['message']);
    }

    return checkSubscriptionApiModel.fromJson(json.decode(response.body));
  }

  // ///*** save pre purchase plan data  ***///
  // void saveSelectedSubscription(context,IAPItem item,index) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('selectedProductId', item.productId!);
  //       _selectSubscription = item;
  //      _selectedIndex = index;
  //   notifyListeners();
  // }

  ///*** lode pre purchase plan data *** ///
  Future<void> loadSelectedSubscription(context,productId) async {

    if (productId != null) {
      int index = await products.indexWhere((product) => product.productId == productId);
      if (index != -1) {
          selectSubscriptionFunction(products[index]);
          selectedIndexFunction(index);
          loaderFunction(false);
      }
    }
    else{
      selectSubscriptionFunction(null);
      selectedIndexFunction(-1);

    }
  }


  void purchasePlanFunction(context)async{
    for (var productData in products){
      if(customerSubscriptionDetailsData != null){
        print("customerSubscriptionDetailsData!.planId${customerSubscriptionDetailsData!.subPlan}");
        print("product.productId${productData.productId}");
        print("product.productId${customerSubscriptionDetailsData!.subPlan == productData.productId}");
        if(customerSubscriptionDetailsData!.subPlan == productData.productId)
        {
          // SubscriptionProviderData.saveSelectedSubscription(context,product,index);
          await  loadSelectedSubscription(context,productData.productId);
        }
      }
      else{
        await loadSelectedSubscription(context,null);
      }
    }

  }

  // /// Payment Success Dialog ///
  // void showPaymentSuccessDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoAlertDialog(
  //         title: Text(
  //           "Subscription Successful!",
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontFamily: fontFamilyText, // Assuming you have this defined
  //             color: colorBlack, // Assuming you have this defined
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         content: Padding(
  //           padding: const EdgeInsets.only(top: 16.0),
  //           child: Text(
  //             "Thank you for upgrading! Your premium subscription is now active. You can now access the Habit-Building Modules, My Meals, and Live chat!",
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontFamily: fontFamilyText, // Assuming you have this defined
  //               color: colorRichblack, // Assuming you have this defined
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           CupertinoDialogAction(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               Navigator.pop(context);
  //               // Navigator.pushReplacement(
  //               //     context,
  //               //     MaterialPageRoute(builder: (context) => Success_Screen(screenName:'Setting')));
  //               // Navigate to premium content or perform any other action
  //               // Navigator.push(
  //               //   context,
  //               //   MaterialPageRoute(builder: (context) => PremiumContentScreen()),
  //               // );
  //             },
  //             child: Text(
  //               "Close",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontFamily: fontFamilyText, // Assuming you have this defined
  //                 color: colorBluePigment, // Assuming you have this defined
  //                 fontWeight: fontWeight900,
  //               ),
  //             ),
  //           ),
  //           //  Uncomment the following code if you want to add "Manage Subscription" action
  //           CupertinoDialogAction(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               //  Get.to(() => Success_Screen());
  //               // Navigate to the subscription management page
  //               // Navigator.push(
  //               //   context,
  //               //   MaterialPageRoute(builder: (context) => Success_Screen()));
  //               // );
  //             },
  //             child: Text(
  //               "Manage Subscription",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontFamily: fontFamilyText, // Assuming you have this defined
  //                 color: colorBluePigment, // Assuming you have this defined
  //                 fontWeight: fontWeight900,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  /// Payment Failure Dialog ///
  void paymentFailureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Payment Failed",
            style: TextStyle(
              fontSize: 20,
              fontFamily: fontFamilyText,
              color: colorBlack,
              fontWeight: fontWeight700,
            ),
          ),
          content: Text(
            "We could not process your payment to upgrade to the premium subscription. Please check your payment details and try again.",
            style: TextStyle(
              fontSize: 14,
              fontFamily: fontFamilyText,
              color: colorRichblack,
              fontWeight: fontWeight400,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                // Implement retry payment logic
                Navigator.pop(context);
              },
              child: Text(
                "Retry Payment",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText,
                  color: colorBluePigment,
                  fontWeight: fontWeight900,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                // Implement contact support logic
                Navigator.pop(context);
              },
              child: Text(
                "Contact Support",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText,
                  color: colorBluePigment,
                  fontWeight: fontWeight900,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText,
                  color: colorBluePigment,
                  fontWeight: fontWeight900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PremiumFeature {
  final String image;
  final String title;

  PremiumFeature({required this.image, required this.title});
}
