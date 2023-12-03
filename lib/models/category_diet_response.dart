import 'pagination_model.dart';

class CategoryDietResponse {
  Pagination? pagination;
  List<CategoryDietModel>? data;

  CategoryDietResponse({this.pagination, this.data});

  CategoryDietResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <CategoryDietModel>[];
      json['data'].forEach((v) {
        data!.add(new CategoryDietModel.fromJson(v));
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

class CategoryDietModel {
  int? id;
  String? title;
  String? status;
  String? categorydietImage;
  String? createdAt;
  String? updatedAt;
  // bool select = true;

  CategoryDietModel(
      {this.id,
      this.title,
      this.status,
      this.categorydietImage,
      this.createdAt,
      this.updatedAt,
      // this.select = true
      });

  CategoryDietModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    categorydietImage = json['categorydiet_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['categorydiet_image'] = this.categorydietImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    // data['select'] = this.select;
    return data;
  }
}
