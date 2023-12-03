import 'pagination_model.dart';

class DietResponse {
  Pagination? pagination;
  List<DietModel>? data;

  DietResponse({this.pagination, this.data});

  DietResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <DietModel>[];
      json['data'].forEach((v) {
        data!.add(new DietModel.fromJson(v));
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


class DietModel {
  int? id;
  String? title;
  String? calories;
  String? carbs;
  String? protein;
  String? fat;
  String? servings;
  String? totalTime;
  String? isFeatured;
  String? status;
  String? ingredients;
  String? description;
  String? dietImage;
  int? isPremium;
  int? categorydietId;
  String? categorydietTitle;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;

  DietModel(
      {this.id,
        this.title,
        this.calories,
        this.carbs,
        this.protein,
        this.fat,
        this.servings,
        this.totalTime,
        this.isFeatured,
        this.status,
        this.ingredients,
        this.description,
        this.dietImage,
        this.isPremium,
        this.categorydietId,
        this.categorydietTitle,
        this.createdAt,
        this.updatedAt,
        this.isFavourite});

  DietModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    calories = json['calories'];
    carbs = json['carbs'];
    protein = json['protein'];
    fat = json['fat'];
    servings = json['servings'];
    totalTime = json['total_time'];
    isFeatured = json['is_featured'];
    status = json['status'];
    ingredients = json['ingredients'];
    description = json['description'];
    dietImage = json['diet_image'];
    isPremium = json['is_premium'];
    categorydietId = json['categorydiet_id'];
    categorydietTitle = json['categorydiet_title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['calories'] = this.calories;
    data['carbs'] = this.carbs;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['servings'] = this.servings;
    data['total_time'] = this.totalTime;
    data['is_featured'] = this.isFeatured;
    data['status'] = this.status;
    data['ingredients'] = this.ingredients;
    data['description'] = this.description;
    data['diet_image'] = this.dietImage;
    data['is_premium'] = this.isPremium;
    data['categorydiet_id'] = this.categorydietId;
    data['categorydiet_title'] = this.categorydietTitle;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}
