import 'pagination_model.dart';

class LevelResponse {
  Pagination? pagination;
  List<LevelModel>? data;

  LevelResponse({this.pagination, this.data});

  LevelResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <LevelModel>[];
      json['data'].forEach((v) {
        data!.add(new LevelModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LevelModel {
  int? id;
  String? title;
  int? rate;
  String? status;
  String? levelImage;
  String? createdAt;
  String? updatedAt;
  bool? select = false;

  LevelModel(
      {this.id,
      this.title,
      this.rate,
      this.status,
      this.levelImage,
      this.createdAt,
      this.updatedAt});

  LevelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    rate = json['rate'];
    status = json['status'];
    levelImage = json['level_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['rate'] = this.rate;
    data['status'] = this.status;
    data['level_image'] = this.levelImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }
}
