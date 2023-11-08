class Get_Meals_Plane_multipl_months_model {
  int? status;
  List<Get_Meals_Plane_multipl_months_Response>? data;

  Get_Meals_Plane_multipl_months_model({this.status, this.data});

  Get_Meals_Plane_multipl_months_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Get_Meals_Plane_multipl_months_Response>[];
      json['data'].forEach((v) {
        data!.add( Get_Meals_Plane_multipl_months_Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Get_Meals_Plane_multipl_months_Response {
  var mlpId;
  var mlpYear;
  var mlpMonth;
  String? mlpCalenderData;

  Get_Meals_Plane_multipl_months_Response({this.mlpId, this.mlpYear, this.mlpMonth, this.mlpCalenderData});

  Get_Meals_Plane_multipl_months_Response.fromJson(Map<String, dynamic> json) {
    mlpId = json['mlp_id'];
    mlpYear = json['mlp_year'];
    mlpMonth = json['mlp_month'];
    mlpCalenderData = json['mlp_calender_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['mlp_id'] = this.mlpId;
    data['mlp_year'] = this.mlpYear;
    data['mlp_month'] = this.mlpMonth;
    data['mlp_calender_data'] = this.mlpCalenderData;
    return data;
  }
}