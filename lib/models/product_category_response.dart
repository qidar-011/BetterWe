import '../models/pagination_model.dart';

class ProductCategoryResponse {
  Pagination? pagination;
  List<ProductCategoryModel>? data;

  ProductCategoryResponse({this.pagination, this.data});

  ProductCategoryResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ProductCategoryModel>[];
      json['data'].forEach((v) {
        data!.add(new ProductCategoryModel.fromJson(v));
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

class ProductCategoryModel {
  int? id;
  String? title;
  String? productcategoryImage;
  String? createdAt;
  String? updatedAt;

  ProductCategoryModel(
      {this.id,
      this.title,
      this.productcategoryImage,
      this.createdAt,
      this.updatedAt});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    productcategoryImage = json['productcategory_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['productcategory_image'] = this.productcategoryImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
