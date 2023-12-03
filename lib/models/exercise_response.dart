import '../models/pagination_model.dart';

class ExerciseResponse {
  Pagination? pagination;
  List<ExerciseModel>? data;

  ExerciseResponse({this.pagination, this.data});

  ExerciseResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ExerciseModel>[];
      json['data'].forEach((v) {
        data!.add(new ExerciseModel.fromJson(v));
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


class ExerciseModel {
  int? id;
  String? title;
  String? status;
  int? isPremium;
  String? exerciseImage;
  String? videoType;
  String? videoUrl;
  List<BodypartName>? bodypartName;
  String? duration;
  List<Sets>? sets;
  int? equipmentId;
  String? equipmentTitle;
  int? levelId;
  String? levelTitle;
  String? instruction;
  String? tips;
  String? createdAt;
  String? updatedAt;
  String? type;
  String? based;

  ExerciseModel(
      {this.id,
        this.title,
        this.status,
        this.isPremium,
        this.exerciseImage,
        this.videoType,
        this.videoUrl,
        this.bodypartName,
        this.duration,
        this.sets,
        this.equipmentId,
        this.equipmentTitle,
        this.levelId,
        this.levelTitle,
        this.instruction,
        this.tips,
        this.createdAt,
        this.type,
        this.based,
        this.updatedAt});

  ExerciseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isPremium = json['is_premium'];
    exerciseImage = json['exercise_image'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];
    if (json['bodypart_name'] != null) {
      bodypartName = <BodypartName>[];
      json['bodypart_name'].forEach((v) {
        bodypartName!.add(new BodypartName.fromJson(v));
      });
    }
    duration = json['duration'];
    if (json['sets'] != null) {
      sets = <Sets>[];
      json['sets'].forEach((v) {
        sets!.add(new Sets.fromJson(v));
      });
    }
    equipmentId = json['equipment_id'];
    equipmentTitle = json['equipment_title'];
    levelId = json['level_id'];
    levelTitle = json['level_title'];
    instruction = json['instruction'];
    tips = json['tips'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    based = json['based'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['is_premium'] = this.isPremium;
    data['exercise_image'] = this.exerciseImage;
    data['video_type'] = this.videoType;
    data['video_url'] = this.videoUrl;
    if (this.bodypartName != null) {
      data['bodypart_name'] =
          this.bodypartName!.map((v) => v.toJson()).toList();
    }
    data['duration'] = this.duration;
    if (this.sets != null) {
      data['sets'] = this.sets!.map((v) => v.toJson()).toList();
    }
    data['equipment_id'] = this.equipmentId;
    data['equipment_title'] = this.equipmentTitle;
    data['level_id'] = this.levelId;
    data['level_title'] = this.levelTitle;
    data['instruction'] = this.instruction;
    data['tips'] = this.tips;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    data['based'] = this.based;
    return data;
  }
}

class BodypartName {
  int? id;
  String? title;
  String? bodypartImage;

  BodypartName({this.id, this.title, this.bodypartImage});

  BodypartName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bodypartImage = json['bodypart_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['bodypart_image'] = this.bodypartImage;
    return data;
  }
}

class Sets {
  String? reps;
  String? rest;
  String? time;
  String? weight;

  Sets({this.reps, this.rest, this.time, this.weight});

  Sets.fromJson(Map<String, dynamic> json) {
    reps = json['reps'];
    rest = json['rest'];
    time = json['time'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reps'] = this.reps;
    data['rest'] = this.rest;
    data['time'] = this.time;
    data['weight'] = this.weight;
    return data;
  }
}