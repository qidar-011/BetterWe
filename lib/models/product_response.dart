
import '../models/pagination_model.dart';

class ProductResponse {
  Pagination? pagination;
  List<ProductModel>? data;

  ProductResponse({this.pagination, this.data});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        data!.add(new ProductModel.fromJson(v));
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
class ProductModel {
  int? id;
  String? title;
  String? description;
  String? affiliateLink;
  int? price;
  int? productcategoryId;
  String? featured;
  String? status;
  String? productImage;
  String? createdAt;
  String? updatedAt;

  ProductModel(
      {this.id,
        this.title,
        this.description,
        this.affiliateLink,
        this.price,
        this.productcategoryId,
        this.featured,
        this.status,
        this.productImage,
        this.createdAt,
        this.updatedAt});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    affiliateLink = json['affiliate_link'];
    price = json['price'];
    productcategoryId = json['productcategory_id'];
    featured = json['featured'];
    status = json['status'];
    productImage = json['product_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['affiliate_link'] = this.affiliateLink;
    data['price'] = this.price;
    data['productcategory_id'] = this.productcategoryId;
    data['featured'] = this.featured;
    data['status'] = this.status;
    data['product_image'] = this.productImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
