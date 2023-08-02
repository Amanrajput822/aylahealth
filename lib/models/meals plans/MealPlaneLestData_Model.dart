class MealPlaneLestData_Model {
  int? status;
  List<MealPlaneLestData_Response>? data;

  MealPlaneLestData_Model({this.status, this.data});

  MealPlaneLestData_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MealPlaneLestData_Response>[];
      json['data'].forEach((v) {
        data!.add(new MealPlaneLestData_Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealPlaneLestData_Response {
  int? mtId;
  String? mtName;

  MealPlaneLestData_Response({this.mtId, this.mtName});

  MealPlaneLestData_Response.fromJson(Map<String, dynamic> json) {
    mtId = json['mt_id'];
    mtName = json['mt_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mt_id'] = this.mtId;
    data['mt_name'] = this.mtName;
    return data;
  }
}