class customerNotificationSettingModel {
  int? status;
  List<customerNotificationSettingresponce>? data;

  customerNotificationSettingModel({this.status, this.data});

  customerNotificationSettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <customerNotificationSettingresponce>[];
      json['data'].forEach((v) {
        data!.add(new customerNotificationSettingresponce.fromJson(v));
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

class customerNotificationSettingresponce {
  int? cnsId;
  bool? cnsRecipeStatus;
  bool? cnsModuleStatus;

  customerNotificationSettingresponce({this.cnsId, this.cnsRecipeStatus, this.cnsModuleStatus});

  customerNotificationSettingresponce.fromJson(Map<String, dynamic> json) {
    cnsId = json['cns_id'];
    cnsRecipeStatus = json['cns_recipe_status'];
    cnsModuleStatus = json['cns_module_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cns_id'] = this.cnsId;
    data['cns_recipe_status'] = this.cnsRecipeStatus;
    data['cns_module_status'] = this.cnsModuleStatus;
    return data;
  }
}