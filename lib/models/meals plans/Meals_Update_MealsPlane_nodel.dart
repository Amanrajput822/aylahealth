class Meals_Update_MealsPlane_model {
  int? status;
  String? message;

  Meals_Update_MealsPlane_model({this.status, this.message});

  Meals_Update_MealsPlane_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}