class moduleLibraryDataModel {
  int? status;
  List<moduleLibraryDataResponse>? data;

  moduleLibraryDataModel({this.status, this.data});

  moduleLibraryDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <moduleLibraryDataResponse>[];
      json['data'].forEach((v) {
        data!.add(new moduleLibraryDataResponse.fromJson(v));
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

class moduleLibraryDataResponse {
  int? mcId;
  String? mcName;
  int? mcIndex;
  List<SubCategory>? subCategory;
  bool? iconColor = false;

  moduleLibraryDataResponse({this.mcId, this.mcName,this.mcIndex, this.subCategory});

  moduleLibraryDataResponse.fromJson(Map<String, dynamic> json) {
    mcId = json['mc_id'];
    mcName = json['mc_name'];
    mcName = json['mc_name'];
    if (json['subCategory'] != null) {
      subCategory = <SubCategory>[];
      json['subCategory'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mc_id'] = this.mcId;
    data['mc_name'] = this.mcName;
    data['mc_name'] = this.mcName;
    if (this.subCategory != null) {
      data['subCategory'] = this.subCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? mscId;
  String? mscName;
  List<ModuleData>? moduleData;

  SubCategory({this.mscId, this.mscName, this.moduleData});

  SubCategory.fromJson(Map<String, dynamic> json) {
    mscId = json['msc_id'];
    mscName = json['msc_name'];
    if (json['moduleData'] != null) {
      moduleData = <ModuleData>[];
      json['moduleData'].forEach((v) {
        moduleData!.add(new ModuleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msc_id'] = this.mscId;
    data['msc_name'] = this.mscName;
    if (this.moduleData != null) {
      data['moduleData'] = this.moduleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModuleData {
  int? mdId;
  String? mdTitle;
  String? mdSummary;
  String? image;
  int? cmvsStatus;

  ModuleData(
      {this.mdId, this.mdTitle, this.mdSummary, this.image, this.cmvsStatus});

  ModuleData.fromJson(Map<String, dynamic> json) {
    mdId = json['md_id'];
    mdTitle = json['md_title'];
    mdSummary = json['md_summary'];
    image = json['image'];
    cmvsStatus = json['cmvs_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md_id'] = this.mdId;
    data['md_title'] = this.mdTitle;
    data['md_summary'] = this.mdSummary;
    data['image'] = this.image;
    data['cmvs_status'] = this.cmvsStatus;
    return data;
  }
}