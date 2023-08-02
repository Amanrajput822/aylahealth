class Meal_Plan_Date_Data_model {
  int? status;
  Meal_Plan_Date_Data_Response? data;

  Meal_Plan_Date_Data_model({this.status, this.data});

  Meal_Plan_Date_Data_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Meal_Plan_Date_Data_Response.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Meal_Plan_Date_Data_Response {
  String? mlpYear;
  String? mlpMonth;
  String? date;
  List<MealData_list>? mealData;

  Meal_Plan_Date_Data_Response({this.mlpYear, this.mlpMonth, this.date, this.mealData});

  Meal_Plan_Date_Data_Response.fromJson(Map<String, dynamic> json) {
    mlpYear = json['mlp_year'];
    mlpMonth = json['mlp_month'];
    date = json['date'];
    if (json['mealData'] != null) {
      mealData = <MealData_list>[];
      json['mealData'].forEach((v) {
        mealData!.add(new MealData_list.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mlp_year'] = this.mlpYear;
    data['mlp_month'] = this.mlpMonth;
    data['date'] = this.date;
    if (this.mealData != null) {
      data['mealData'] = this.mealData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealData_list {
  String? recId;
  String? mtId;
  String? recTitle;
  String? image;
  int? favStatus;
  String? note;
  String? logged;

  MealData_list(
      {this.recId,
        this.mtId,
        this.recTitle,
        this.image,
        this.favStatus,
        this.note,
        this.logged});

  MealData_list.fromJson(Map<String, dynamic> json) {
    recId = json['rec_id'];
    mtId = json['mt_id'];
    recTitle = json['rec_title'];
    image = json['image'];
    favStatus = json['fav_status'];
    note = json['note'];
    logged = json['logged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rec_id'] = this.recId;
    data['mt_id'] = this.mtId;
    data['rec_title'] = this.recTitle;
    data['image'] = this.image;
    data['fav_status'] = this.favStatus;
    data['note'] = this.note;
    data['logged'] = this.logged;
    return data;
  }
}