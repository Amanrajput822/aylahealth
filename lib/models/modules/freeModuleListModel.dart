class freeModuleListModel {
  int? status;
  List<freeModuleListResponse>? data;

  freeModuleListModel({this.status, this.data});

  freeModuleListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <freeModuleListResponse>[];
      json['data'].forEach((v) {
        data!.add(new freeModuleListResponse.fromJson(v));
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

class freeModuleListResponse {
  int? mdId;
  int? cmvsStatus;
  String? mdTitle;
  String? image;

  freeModuleListResponse({this.mdId, this.cmvsStatus, this.mdTitle, this.image});

  freeModuleListResponse.fromJson(Map<String, dynamic> json) {
    mdId = json['md_id'];
    cmvsStatus = json['cmvs_status'];
    mdTitle = json['md_title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md_id'] = this.mdId;
    data['cmvs_status'] = this.cmvsStatus;
    data['md_title'] = this.mdTitle;
    data['image'] = this.image;
    return data;
  }
}