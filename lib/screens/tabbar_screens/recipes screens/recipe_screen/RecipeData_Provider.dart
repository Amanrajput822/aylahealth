import 'package:aylahealth/models/recipelist/RecipeList_data_model.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/RecipeCategoryList_Model.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import 'package:aylahealth/models/recipelist/recipe_like_unlike_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';

class RecipeData_Provider with ChangeNotifier {

  TextEditingController txt_search = TextEditingController();

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;

  String? _user_id ;
  String? get user_id => _user_id;

  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  void selectedDay_data( newMessage) {
    _selectedDay = newMessage;
    notifyListeners();
  }

  /// recipe Get meals plan types list data api
  String? _select_mealplanID_recipe ;
  String? get select_mealplanID_recipe => _select_mealplanID_recipe ;
  void meal_plan_id_select_fuction_recipe( newMessage) {
    _select_mealplanID_recipe = newMessage;
    notifyListeners();
  }

  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;
  void focusedDay_data( newMessage) {
    _focusedDay = newMessage;
    notifyListeners();
  }

  String? _selectedDate;
  String? get selectedDate => _selectedDate;
  void selectedDate_string( newMessage) {
    _selectedDate = newMessage;
    notifyListeners();
  }

  bool _meals_screen = false;
  bool get meals_screen => _meals_screen;
  void select_screen_data( newMessage) {
    _meals_screen = newMessage;
    notifyListeners();
  }

  /// data reloading params ///
  int _page = 0 ;
  int get page => _page;

  bool _hasNextPage = true;
  bool get hasNextPage => _hasNextPage;

  bool _isFirstLoadRunning = false;
  bool get isFirstLoadRunning => _isFirstLoadRunning;


  bool _isLoadMoreRunning = false;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

   ScrollController? _controller;
   ScrollController? get controller => _controller;

  /// Recipe data params ///

  RecipeList_data_model post = RecipeList_data_model();
  bool loading = false;


  List<RecipeList_data_Response>? _recipe_data_List ;
  List<RecipeList_data_Response>? get recipe_data_List => _recipe_data_List;

  /// Recipe data params ///
  Recipe_Filtter_model filtterdata = Recipe_Filtter_model();
  RecipeCategoryList_Model recipeCategorydata = RecipeCategoryList_Model();

  /// Recipe data data call function 1 time ///
  getRecipeData1(context,search_test,favorite,cat_id,eat_id,List<FilterTag> tagIds_list) async {
    loading = true;
    post = await recipeList_ditels_api(search_test:search_test,favorite:favorite,cat_id: cat_id,eat_id: eat_id,tagIds_list:tagIds_list);

    filtterdata = await recipe_filtter_api();
    _filter_list_data = filtterdata.data;

    recipeCategorydata = await recipe_categoryList_api();
    _recipecategory_list_data = recipeCategorydata.data;

    _controller = ScrollController()..addListener(() {
      recipeList_ditels_api_relode_fuction(search_test:search_test,favorite:favorite,cat_id: cat_id,eat_id: eat_id,tagIds_list:tagIds_list);
    },);

    _recipe_data_List = post.data;
    loading = false;

    notifyListeners();
  }

  /// Recipe data data call function  ///
  getRecipeData(context,search_test,favorite,cat_id,eat_id,tagIds_list,) async {
     post = await recipeList_ditels_api(search_test:search_test,favorite:favorite,cat_id: cat_id,eat_id: eat_id,tagIds_list:tagIds_list);

    _controller = ScrollController()..addListener(() {
      recipeList_ditels_api_relode_fuction(search_test:search_test,favorite:favorite,cat_id: cat_id,eat_id: eat_id,tagIds_list:tagIds_list);
    },);

    _recipe_data_List = post.data;

    notifyListeners();
  }

  /// Recipe like api function  ///
  likeRecipeData1(context,recipe_id) async {
    recipe_like_api(recipe_id);
    notifyListeners();
  }
  /// Recipe like api function  ///
  unlikeRecipeData1(context,recipe_id,txt_search,fav_filter) async {
    recipe_unlike_api(context,recipe_id,txt_search,fav_filter);
    notifyListeners();
  }

         /// eatingPattern params ///

   var _selectedIndex_eatingPattern_index = null;
   get selectedIndex_eatingPattern_index => _selectedIndex_eatingPattern_index;

  void updateselectedeatingPattern_index( newMessage) {
    _selectedIndex_eatingPattern_index = newMessage;
    notifyListeners();
  }

   var _selectedeatingPattern_id = null;
    get selectedeatingPattern_id => _selectedeatingPattern_id;

  void updateeatingPattern_is( newMessage) {

    _selectedeatingPattern_id = newMessage;
    notifyListeners();
  }

  String _save_eatingPattern_id = '0';
  String get save_eatingPattern_id => _save_eatingPattern_id;


  void save_select_eatingPattern_id( newMessage) {
    _save_eatingPattern_id = newMessage;
    notifyListeners();
  }

  var _save_eatingPattern_index = null;
   get save_eatingPattern_index => _save_eatingPattern_index;

  void save_select_eatingPattern_index( newMessage) {
    _save_eatingPattern_index = newMessage;
    notifyListeners();
  }

          /// more filter params ///

  List<FilterTag> _selected_filter = [];
  List<FilterTag> get selected_filter => _selected_filter;

  void selectedfilter( newMessage) {
    _selected_filter = newMessage;
    notifyListeners();
  }


  List<FilterTag> _save_filter = [];
  List<FilterTag> get save_filter => _save_filter;

  void savefilter( newMessage1) {
    _save_filter = newMessage1;
    notifyListeners();
  }

  String? _filter_count = '0';
  String? get filter_count => _filter_count;

  void selectedfiltercount(String? newMessage) {
    _filter_count = newMessage;
    notifyListeners();
  }

  /// category params ///

  String _select_cat_id = '0';
  String get select_cat_id => _select_cat_id;

  void selectedcategory_id( newMessage) {
    _select_cat_id = newMessage;
    notifyListeners();
  }
  /// fav_filter params ///

  String _fav_filter = '0';
  String get fav_filter => _fav_filter;

  void selectedfav_filter( newMessage) {
    _fav_filter = newMessage;
    notifyListeners();
  }

  /// Home param recipe collection

  String? _selectedCollectionID = '0';
  String? get selectedCollectionID => _selectedCollectionID;

  void selectedCollectionIDFunction( newMessage) {
    _selectedCollectionID = newMessage;
    notifyListeners();
  }

  String? _selectedCollectionIDName = '0';
  String? get selectedCollectionIDName => _selectedCollectionIDName;


  void selectedCollectionIDNameFunction( newMessage) {
    _selectedCollectionIDName = newMessage;
    notifyListeners();
  }

    /// recipeList_ditels_api ///

  Future<RecipeList_data_model> recipeList_ditels_api({String? search_test,String? favorite,String?cat_id,String? eat_id,List<FilterTag>? tagIds_list}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });
    _page = 0;
   List<String>? tagIds=[];
   for(int i=0;i<tagIds_list!.length;i++)
     {
       tagIds.add(tagIds_list[i].tagId.toString());
     }
    Map toMap() {
      var map =  Map<String, dynamic>();

      map["index"] = page.toString();
      map["limit"] = 20;
      map["search"] = search_test??"";
      map["fav_status"] = favorite??'0';
      map["cat_id"] = cat_id??'0';
      map["eat_id"] = eat_id??'0';
      map["tagIds"] = tagIds;
      map["coll_id"] = selectedCollectionID??"0";
      // map["rec_isfeatured"] = "1";
      // map["sortby"] = '';
      // map["orderby"] = '';
      return map;
    }

    print(toMap().toString());
    print(Endpoints.baseURL+Endpoints.recipeList.toString());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.recipeList),
        body: json.encode(toMap()),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );

   if(response.statusCode == 200){
     _success = (RecipeList_data_model.fromJson(json.decode(response.body)).status);

     if (_success == 200) {
       // Navigator.pop(context);
       _hasNextPage = true;
       _recipe_data_List = (RecipeList_data_model.fromJson(json.decode(response.body)).data);
       notifyListeners();
       // Get.to(() => Pre_Question_Screen());
     } else {
       // Navigator.pop(context);
       print('else==============');
       _recipe_data_List = [];
       notifyListeners();
       FlutterToast_message('No Data');
     }
   }
   else{

     FlutterToast_message(json.decode(response.body)['message']);
   }

    return RecipeList_data_model.fromJson(json.decode(response.body));
  }


        ///   recipeList_ditels_api_relode_fuction /////////////

  Future<RecipeList_data_model> recipeList_ditels_api_relode_fuction({String? search_test,String? favorite,String?cat_id,String? eat_id,List<FilterTag>? tagIds_list}) async {
   print("recipeList_ditels_api_relode_fuction");
    var response;
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller!.position.extentAfter < 300) {
      print("recipeList_ditels_api_relode_fuction11");
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom

      _page += 20; // Increase _page by 1

        List<String>? tagIds=[];
        for(int i=0;i<tagIds_list!.length;i++)
        {
          tagIds.add(tagIds_list[i].tagId.toString());
        }
      Map toMap() {
        var map =  Map<String, dynamic>();

        map["index"] = page.toString();
        map["limit"] = 20;
        map["search"] = search_test??"";
        map["fav_status"] = favorite??'0';
        map["cat_id"] = cat_id??'0';
        map["eat_id"] = eat_id??'0';
        map["tagIds"] = tagIds;
        map["coll_id"] = selectedCollectionID??"0";
        // map["sortby"] = '';
        // map["orderby"] = '';
        return map;
      }
      print('toMap()@@@@@@@@@@@@@@@@');
      print(toMap());
      print(Endpoints.baseURL+Endpoints.recipeList);

      try {
        response = await http.post(
            Uri.parse(Endpoints.baseURL+Endpoints.recipeList),
            body: json.encode(toMap()),
            headers: {
              'Authorization': 'Bearer $_tokanget',
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            }
        );

        final List<RecipeList_data_Response>? fetchedPosts = (RecipeList_data_model.fromJson(json.decode(response.body)).data);

        if (fetchedPosts!.isNotEmpty) {
             _recipe_data_List!.addAll(fetchedPosts);
             notifyListeners();
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
            _hasNextPage = false;

        }
      } catch (err) {
        if (kDebugMode) {
          _recipe_data_List = [];
          notifyListeners();
          print('Something went wrong!');
        }
      }
        _isLoadMoreRunning = false;
    }
    return RecipeList_data_model.fromJson(json.decode(response.body));
  }

         /// recipe_like_api //////////////////

  Future<recipe_like_unlike_data_model> recipe_like_api(recipe_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["rec_id"] = recipe_id.toString();
      map["cust_id"] = _user_id.toString();

      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.markRecipeFavorite),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .status);
      _message = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .message);
      print("success 123 ==${_success}");
      if (_success == 200) {
        // Navigator.pop(context);
        FlutterToast_message(_message);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      }
      else {
        print('else==============');
        FlutterToast_message(_message);
      }
    }
    else{
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return recipe_like_unlike_data_model.fromJson(json.decode(response.body));
  }

  /// recipe_unlike_api ///////////////////

  Future<recipe_like_unlike_data_model> recipe_unlike_api(context,recipe_id,txt_search,fav_filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["rec_id"] = recipe_id.toString();
      map["cust_id"] = _user_id.toString();
      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.unmarkRecipeFromFavorite),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .status);
      _message = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .message);
      print("success 123 ==${_success}");
      if (_success == 200) {

        FlutterToast_message(_message);
        if(fav_filter=='1'){
          getRecipeData(context,txt_search.toString(),fav_filter,select_cat_id,save_eatingPattern_id,selected_filter);

          //getRecipeData(context,search_test,favorite,cat_id,eat_id,tagIds_list)
        }
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      }
      else{
        FlutterToast_message(_message);
      }
    }
    else {
      FlutterToast_message(json.decode(response.body)['message']);

    }
    return recipe_like_unlike_data_model.fromJson(json.decode(response.body));
  }

  /// recipe_filtter_api ///////////////////

  Recipe_Filtter_Response? _filter_list_data;
  Recipe_Filtter_Response? get filter_list_data => _filter_list_data;

  Future<Recipe_Filtter_model> recipe_filtter_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.get(
        Uri.parse(Endpoints.baseURL + Endpoints.allRecipeFiltersList),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    print("success allRecipeFiltersList${response.body}");
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (Recipe_Filtter_model.fromJson(json.decode(response.body)).status);

      print("success 123 ==${_success}");
      if (_success == 200) {
        _filter_list_data = (Recipe_Filtter_model.fromJson(json.decode(response.body)).data);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      }else {
        _filter_list_data = null;

        print('else==============');
        FlutterToast_message(_message);
        notifyListeners();
      }
    }
    else{
      _filter_list_data = null;
      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return Recipe_Filtter_model.fromJson(json.decode(response.body));
  }

  /// recipe_categoryList_api ///////////////////
  List<RecipeCategoryList_Response>? _recipecategory_list_data;
  List<RecipeCategoryList_Response>? get recipecategory_list_data => _recipecategory_list_data;


  Future<RecipeCategoryList_Model> recipe_categoryList_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.get(
        Uri.parse(Endpoints.baseURL + Endpoints.recipeCategoryList),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    print("success recipeCategoryList${response.body}");
    if (response.statusCode == 200) {
      _success = (RecipeCategoryList_Model.fromJson(json.decode(response.body)).status);

      if (_success == 200) {
        _recipecategory_list_data = (RecipeCategoryList_Model.fromJson(json.decode(response.body)).data);
        // Get.to(() => Pre_Question_Screen());
      }
      else {
        _recipecategory_list_data = [];
        print('else==============');
        FlutterToast_message(_message);
        notifyListeners();
      }
    }
    else{
      _recipecategory_list_data = [];
      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return RecipeCategoryList_Model.fromJson(json.decode(response.body));
  }

}