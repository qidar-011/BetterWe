import 'pagination_model.dart';

class BodyPartResponse {
  Pagination? pagination;
  List<BodyPartModel>? data;

  BodyPartResponse({this.pagination, this.data});

  BodyPartResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <BodyPartModel>[];
      json['data'].forEach((v) {
        data!.add(new BodyPartModel.fromJson(v));
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

class BodyPartModel {
  int? id;
  String? title;
  String? status;
  String? description;
  String? bodypartImage;
  String? createdAt;
  String? updatedAt;
  bool? select;

  BodyPartModel(
      {this.id,
        this.title,
        this.status,
        this.description,
        this.bodypartImage,
        this.createdAt,
        this.updatedAt,
        this.select = false,
      });

  BodyPartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    bodypartImage = json['bodypart_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['description'] = this.description;
    data['bodypart_image'] = this.bodypartImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['select'] = this.select;
    return data;
  }
}
