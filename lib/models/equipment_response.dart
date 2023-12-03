import '../../models/pagination_model.dart';

class EquipmentResponse {
  Pagination? pagination;
  List<EquipmentModel>? data;

  EquipmentResponse({this.pagination, this.data});

  EquipmentResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <EquipmentModel>[];
      json['data'].forEach((v) {
        data!.add(new EquipmentModel.fromJson(v));
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

class EquipmentModel {
  int? id;
  String? title;
  String? status;
  String? description;
  String? equipmentImage;
  String? createdAt;
  String? updatedAt;
  bool? isSelected=false;

  EquipmentModel({this.id, this.title, this.status, this.description, this.equipmentImage, this.createdAt, this.updatedAt});

  EquipmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    equipmentImage = json['equipment_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['description'] = this.description;
    data['equipment_image'] = this.equipmentImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
