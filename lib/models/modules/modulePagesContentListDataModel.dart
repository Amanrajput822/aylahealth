class modulePagesContentListDataModel {
  int? status;
  List<modulePagesContentListDataResponse>? data;

  modulePagesContentListDataModel({this.status, this.data});

  modulePagesContentListDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <modulePagesContentListDataResponse>[];
      json['data'].forEach((v) {
        data!.add(new modulePagesContentListDataResponse.fromJson(v));
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

class modulePagesContentListDataResponse {
  int? mpId;
  int? mpIndex;
  String? mpTitle;
  ModulePageContent? modulePageContent;
  List<DetailsData>? detailsData;
  List<ImagesData>? imagesData;
  List<TagedRecipe>? tagedRecipe;

  modulePagesContentListDataResponse(
      {this.mpId,
        this.mpIndex,
        this.mpTitle,
        this.modulePageContent,
        this.detailsData,
        this.imagesData,
        this.tagedRecipe});

  modulePagesContentListDataResponse.fromJson(Map<String, dynamic> json) {
    mpId = json['mp_id'];
    mpIndex = json['mp_index'];
    mpTitle = json['mp_title'];
    modulePageContent = json['modulePageContent'] != null
        ? new ModulePageContent.fromJson(json['modulePageContent'])
        : null;
    if (json['detailsData'] != null) {
      detailsData = <DetailsData>[];
      json['detailsData'].forEach((v) {
        detailsData!.add(new DetailsData.fromJson(v));
      });
    }
    if (json['imagesData'] != null) {
      imagesData = <ImagesData>[];
      json['imagesData'].forEach((v) {
        imagesData!.add(new ImagesData.fromJson(v));
      });
    }
    if (json['tagedRecipe'] != null) {
      tagedRecipe = <TagedRecipe>[];
      json['tagedRecipe'].forEach((v) {
        tagedRecipe!.add(new TagedRecipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mp_id'] = this.mpId;
    data['mp_index'] = this.mpIndex;
    data['mp_title'] = this.mpTitle;
    if (this.modulePageContent != null) {
      data['modulePageContent'] = this.modulePageContent!.toJson();
    }
    if (this.detailsData != null) {
      data['detailsData'] = this.detailsData!.map((v) => v.toJson()).toList();
    }
    if (this.imagesData != null) {
      data['imagesData'] = this.imagesData!.map((v) => v.toJson()).toList();
    }
    if (this.tagedRecipe != null) {
      data['tagedRecipe'] = this.tagedRecipe!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModulePageContent {
  int? mpcId;
  String? mpcTitle;
  String? mpcDetailHtml;
  int? mpcMediaType;
  String? mpcMedia;

  ModulePageContent(
      {this.mpcId,
        this.mpcTitle,
        this.mpcDetailHtml,
        this.mpcMediaType,
        this.mpcMedia});

  ModulePageContent.fromJson(Map<String, dynamic> json) {
    mpcId = json['mpc_id'];
    mpcTitle = json['mpc_title'];
    mpcDetailHtml = json['mpc_detail_html'];
    mpcMediaType = json['mpc_media_type'];
    mpcMedia = json['mpc_media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mpc_id'] = this.mpcId;
    data['mpc_title'] = this.mpcTitle;
    data['mpc_detail_html'] = this.mpcDetailHtml;
    data['mpc_media_type'] = this.mpcMediaType;
    data['mpc_media'] = this.mpcMedia;
    return data;
  }
}

class DetailsData {
  int? mpdId;
  String? mpdTitle;
  String? mpdText;

  DetailsData({this.mpdId, this.mpdTitle, this.mpdText});

  DetailsData.fromJson(Map<String, dynamic> json) {
    mpdId = json['mpd_id'];
    mpdTitle = json['mpd_title'];
    mpdText = json['mpd_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mpd_id'] = this.mpdId;
    data['mpd_title'] = this.mpdTitle;
    data['mpd_text'] = this.mpdText;
    return data;
  }
}

class ImagesData {
  int? mpiId;
  String? mpiName;

  ImagesData({this.mpiId, this.mpiName});

  ImagesData.fromJson(Map<String, dynamic> json) {
    mpiId = json['mpi_id'];
    mpiName = json['mpi_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mpi_id'] = this.mpiId;
    data['mpi_name'] = this.mpiName;
    return data;
  }
}
class TagedRecipe {
  int? mprId;
  int? recId;
  String? recTitle;
  String? image;
  int? recServes;
  int? favStatus;

  TagedRecipe(
      {this.mprId,
        this.recId,
        this.recTitle,
        this.image,
        this.recServes,
        this.favStatus});

  TagedRecipe.fromJson(Map<String, dynamic> json) {
    mprId = json['mpr_id'];
    recId = json['rec_id'];
    recTitle = json['rec_title'];
    image = json['image'];
    recServes = json['rec_serves'];
    favStatus = json['fav_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mpr_id'] = this.mprId;
    data['rec_id'] = this.recId;
    data['rec_title'] = this.recTitle;
    data['image'] = this.image;
    data['rec_serves'] = this.recServes;
    data['fav_status'] = this.favStatus;
    return data;
  }
}