class user_login_model {
  int? status;
  String? message;
  Data? data;

  user_login_model({this.status, this.message, this.data});

  user_login_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? custId;
  String? custFirstname;
  String? custLastname;
  String? custEmail;
  int? custType;
  int? custLoginBy;
  String? image;
  String? accessToken;
  String? tokenType;
  bool? custLoginStatus;

  Data(
      {this.custId,
        this.custFirstname,
        this.custLastname,
        this.custEmail,
        this.custType,
        this.custLoginBy,
        this.image,
        this.accessToken,
        this.tokenType,
        this.custLoginStatus,});

  Data.fromJson(Map<String, dynamic> json) {
    custId = json['cust_id'];
    custFirstname = json['cust_firstname'];
    custLastname = json['cust_lastname'];
    custEmail = json['cust_email'];
    custType = json['cust_type'];
    custLoginBy = json['cust_login_by'];
    image = json['image'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    custLoginStatus = json['cust_login_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cust_id'] = this.custId;
    data['cust_firstname'] = this.custFirstname;
    data['cust_lastname'] = this.custLastname;
    data['cust_email'] = this.custEmail;
    data['cust_type'] = this.custType;
    data['cust_login_by'] = this.custLoginBy;
    data['image'] = this.image;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['cust_login_status'] = this.custLoginStatus;
    return data;
  }
}