class Get_Meals_Plane_model {
  int? status;
  Get_Meals_Plane_responsa? data;

  Get_Meals_Plane_model({this.status, this.data});

  Get_Meals_Plane_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Get_Meals_Plane_responsa.fromJson(json['data']) : null;
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

class Get_Meals_Plane_responsa {
  int? mlpId;
  int? mlpYear;
  int? mlpMonth;
  String? mlpCalenderData;

  Get_Meals_Plane_responsa({this.mlpId, this.mlpYear, this.mlpMonth, this.mlpCalenderData});

  Get_Meals_Plane_responsa.fromJson(Map<String, dynamic> json) {
    mlpId = json['mlp_id'];
    mlpYear = json['mlp_year'];
    mlpMonth = json['mlp_month'];
    mlpCalenderData = json['mlp_calender_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mlp_id'] = this.mlpId;
    data['mlp_year'] = this.mlpYear;
    data['mlp_month'] = this.mlpMonth;
    data['mlp_calender_data'] = this.mlpCalenderData;
    return data;
  }
}