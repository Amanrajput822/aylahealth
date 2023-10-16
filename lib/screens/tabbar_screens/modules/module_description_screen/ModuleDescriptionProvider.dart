import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../models/recipelist/Recipe_details_data_model.dart';


class ModulesDescriptionScreenProvider with ChangeNotifier {
  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokenGet ;
  String? get tokenGet => _tokenGet;


  final bool _loading = false;
  bool get loading => _loading;

  String? _buttonType = 'Start Module';
  String? get buttonType => _buttonType;

  void buttonTypeFunction(newMessage){
    _buttonType = newMessage;
    notifyListeners();
  }



//
// Future<Recipe_details_data_model?> recipe_ditels_api(context, rec_id) async {
//   Recipe_details_data_model? result;
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     _tokenGet = prefs.getString('login_user_token');
//     _tokenGet = tokenGet!.replaceAll('"', '');
//     _user_id = prefs.getString('login_user_id');
//     _user_id = user_id!.replaceAll('"', '');
//
//     print(tokenGet.toString());
//     check().then((intenet) async {
//       if (intenet != null && intenet) {
//
//       } else {
//         FlutterToast_Internet();
//       }
//     });
//     Map toMap() {
//       var map = Map<String, dynamic>();
//       map["rec_id"] = rec_id.toString();
//       map["cust_id"] = user_id.toString();
//       map["checkNutritionSetting"] = '1';
//       return map;
//     }
//     print(toMap());
//     print(beasurl + recipeDetails);
//     var response = await http.post(
//         Uri.parse(beasurl + recipeDetails),
//         body: toMap(),
//         headers: {
//           'Authorization': 'Bearer $tokenGet',
//           'Accept': 'application/json'
//         }
//     );
//     print(response.body.toString());
//     _success = (Recipe_details_data_model
//         .fromJson(json.decode(response.body))
//         .status);
//     print("json.decode(response.body)${json.decode(response.body)}");
//     if (success == 200) {
//       final item = json.decode(response.body);
//       result = (Recipe_details_data_model.fromJson(item));
//       _recipe_ditels_data = (Recipe_details_data_model
//           .fromJson(item)
//           .data);
//       notifyListeners();
//       // Get.to(() => Pre_Question_Screen());
//     } else {
//       // Navigator.pop(context);
//       print('else==============');
//       FlutterToast_message('No Data');
//
//     }
//   } catch (e) {
//     error = e.toString();
//   }
//   return result;
// }
//


}