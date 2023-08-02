class user_details_model {
  int? status;
  user_details_esponse? data;

  user_details_model({ this.status, this.data});

  user_details_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new user_details_esponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
  factory user_details_model.fromMap(Map<String, dynamic> json) =>
      user_details_model(
          status : json['status'],
          data : json['data'] != null ? new user_details_esponse.fromJson(json['data']) : null,
      );
}


class user_details_esponse {
  int? custId;
  String? custFirstname;
  String? custLastname;
  String? custEmail;
  String? custPhone;
  String? custAddress;
  String? custSuburb;
  String? custState;
  String? custPostcode;
  int? custType;
  String? custDOB;
  int? custGender;
  String? genName;

  user_details_esponse(
      {this.custId,
        this.custFirstname,
        this.custLastname,
        this.custEmail,
        this.custPhone,
        this.custAddress,
        this.custSuburb,
        this.custState,
        this.custPostcode,
        this.custType,
        this.custDOB,
        this.custGender,
        this.genName});

  user_details_esponse.fromJson(Map<String, dynamic> json) {
    custId = json['cust_id'];
    custFirstname = json['cust_firstname'];
    custLastname = json['cust_lastname'];
    custEmail = json['cust_email'];
    custPhone = json['cust_phone'];
    custAddress = json['cust_address'];
    custSuburb = json['cust_suburb'];
    custState = json['cust_state'];
    custPostcode = json['cust_postcode'];
    custType = json['cust_type'];
    custDOB = json['cust_DOB'];
    custGender = json['cust_gender'];
    genName = json['gen_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cust_id'] = this.custId;
    data['cust_firstname'] = this.custFirstname;
    data['cust_lastname'] = this.custLastname;
    data['cust_email'] = this.custEmail;
    data['cust_phone'] = this.custPhone;
    data['cust_address'] = this.custAddress;
    data['cust_suburb'] = this.custSuburb;
    data['cust_state'] = this.custState;
    data['cust_postcode'] = this.custPostcode;
    data['cust_type'] = this.custType;
    data['cust_DOB'] = this.custDOB;
    data['cust_gender'] = this.custGender;
    data['gen_name'] = this.genName;
    return data;
  }
  factory user_details_esponse.fromMap(Map<String, dynamic> json) =>
      user_details_esponse(
          custId : json['cust_id'],
          custFirstname : json['cust_firstname'],
          custLastname : json['cust_lastname'],
          custEmail : json['cust_email'],
          custPhone : json['cust_phone'],
          custAddress : json['cust_address'],
          custSuburb : json['cust_suburb'],
          custState : json['cust_state'],
          custPostcode : json['cust_postcode'],
          custType : json['cust_type'],
          custDOB : json['cust_DOB'],
          custGender : json['cust_gender'],
          genName : json['gen_name'],
      );
}