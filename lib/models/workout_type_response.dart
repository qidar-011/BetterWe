import '../models/pagination_model.dart';

class WorkoutTypeResponse {
  Pagination? pagination;
  List<WorkoutTypeModel>? data;

  WorkoutTypeResponse({this.pagination, this.data});

  WorkoutTypeResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <WorkoutTypeModel>[];
      json['data'].forEach((v) {
        data!.add(new WorkoutTypeModel.fromJson(v));
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

class WorkoutTypeModel {
  int? id;
  String? title;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? select = false;

  WorkoutTypeModel({this.id, this.title, this.status, this.createdAt, this.updatedAt});

  WorkoutTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
