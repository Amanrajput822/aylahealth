class customerSubscriptionDetailsModel {
  int? status;
  customerSubscriptionDetailsResponse? data;

  customerSubscriptionDetailsModel({this.status, this.data});

  customerSubscriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new customerSubscriptionDetailsResponse.fromJson(json['data']) : null;
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

class customerSubscriptionDetailsResponse {
  int? subId;
  int? custSubCancelled;
  String? subPlan;
  String? subStartdate;
  String? subExpiredate;

  customerSubscriptionDetailsResponse(
      {this.subId,
        this.custSubCancelled,
        this.subPlan,
        this.subStartdate,
        this.subExpiredate});

  customerSubscriptionDetailsResponse.fromJson(Map<String, dynamic> json) {
    subId = json['sub_id'];
    custSubCancelled = json['cust_sub_cancelled'];
    subPlan = json['sub_plan'];
    subStartdate = json['sub_startdate'];
    subExpiredate = json['sub_expiredate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_id'] = this.subId;
    data['cust_sub_cancelled'] = this.custSubCancelled;
    data['sub_plan'] = this.subPlan;
    data['sub_startdate'] = this.subStartdate;
    data['sub_expiredate'] = this.subExpiredate;
    return data;
  }
}