class customerShoppingListModel {
  int? status;
  List<customerShoppingListResponse>? data;
  String? slStartdate;
  String? slEnddate;

  customerShoppingListModel({this.status, this.data, this.slStartdate, this.slEnddate});

  customerShoppingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <customerShoppingListResponse>[];
      json['data'].forEach((v) {
        data!.add( customerShoppingListResponse.fromJson(v));
      });
    }
    slStartdate = json['sl_startdate'];
    slEnddate = json['sl_enddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['sl_startdate'] = this.slStartdate;
    data['sl_enddate'] = this.slEnddate;
    return data;
  }
}

class customerShoppingListResponse {
  int? scId;
  String? scName;
  List<IngData>? ingData;

  customerShoppingListResponse({this.scId, this.scName, this.ingData});

  customerShoppingListResponse.fromJson(Map<String, dynamic> json) {
    scId = json['sc_id'];
    scName = json['sc_name'];
    if (json['ingData'] != null) {
      ingData = <IngData>[];
      json['ingData'].forEach((v) {
        ingData!.add(new IngData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sc_id'] = this.scId;
    data['sc_name'] = this.scName;
    if (this.ingData != null) {
      data['ingData'] = this.ingData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IngData {
  String? ingName;
  String? slQuantity;
  String? ingUnit;
  int? slItemStatus;

  IngData({this.ingName, this.slQuantity, this.ingUnit, this.slItemStatus});

  IngData.fromJson(Map<String, dynamic> json) {
    ingName = json['ing_name'];
    slQuantity = json['sl_quantity'];
    ingUnit = json['ing_unit'];
    slItemStatus = json['sl_item_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ing_name'] = this.ingName;
    data['sl_quantity'] = this.slQuantity;
    data['ing_unit'] = this.ingUnit;
    data['sl_item_status'] = this.slItemStatus;
    return data;
  }
}