
class Month_all_Date_json_model {
  int? date;
  String? comment;
  List<MealData>? mealData;

  Month_all_Date_json_model({this.date, this.comment, this.mealData});

  Month_all_Date_json_model.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    comment = json['comment'];
    if (json['mealData'] != null) {
      mealData = <MealData>[];
      json['mealData'].forEach((v) {
        mealData!.add(MealData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['comment'] = this.comment;
    if (this.mealData != null) {
      data['mealData'] = this.mealData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealData {
  String? recId;
  String? catId;
  String? note;
  String? logged;

  MealData({this.recId, this.catId, this.note, this.logged});

  MealData.fromJson(Map<String, dynamic> json) {
    recId = json['rec_id'];
    catId = json['cat_id'];
    note = json['note'];
    logged = json['logged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rec_id'] = this.recId;
    data['cat_id'] = this.catId;
    data['note'] = this.note;
    data['logged'] = this.logged;
    return data;
  }
}