class customerModuleViewStatusModal {
  int? status;
  customerModuleViewStatusResponse? data;

  customerModuleViewStatusModal({this.status, this.data});

  customerModuleViewStatusModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new customerModuleViewStatusResponse.fromJson(json['data']) : null;
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

class customerModuleViewStatusResponse {
  int? mdId;
  int? cmvsStatus;

  customerModuleViewStatusResponse({this.mdId, this.cmvsStatus});

  customerModuleViewStatusResponse.fromJson(Map<String, dynamic> json) {
    mdId = json['md_id'];
    cmvsStatus = json['cmvs_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md_id'] = this.mdId;
    data['cmvs_status'] = this.cmvsStatus;
    return data;
  }
}