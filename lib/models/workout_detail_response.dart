class WorkoutDetailResponse {
  WorkoutDetailModel? data;
  List<Workoutday>? workoutday;

  WorkoutDetailResponse({this.data, this.workoutday});

  WorkoutDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new WorkoutDetailModel.fromJson(json['data']) : null;
    if (json['workoutday'] != null) {
      workoutday = <Workoutday>[];
      json['workoutday'].forEach((v) {
        workoutday!.add(new Workoutday.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.workoutday != null) {
      data['workoutday'] = this.workoutday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkoutDetailModel {
  int? id;
  String? title;
  String? status;
  int? isPremium;
  int? levelId;
  String? levelTitle;
  int? levelRate;
  String? workoutImage;
  int? workoutTypeId;
  String? workoutTypeTitle;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;
  String? description;
  bool? isSelected=false;

  WorkoutDetailModel(
      {this.id,
        this.title,
        this.status,
        this.isPremium,
        this.levelId,
        this.levelTitle,
        this.levelRate,
        this.workoutImage,
        this.workoutTypeId,
        this.workoutTypeTitle,
        this.createdAt,
        this.updatedAt,
        this.isFavourite,
        this.description});

  WorkoutDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isPremium = json['is_premium'];
    levelId = json['level_id'];
    levelTitle = json['level_title'];
    levelRate = json['level_rate'];
    workoutImage = json['workout_image'];
    workoutTypeId = json['workout_type_id'];
    workoutTypeTitle = json['workout_type_title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavourite = json['is_favourite'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['is_premium'] = this.isPremium;
    data['level_id'] = this.levelId;
    data['level_title'] = this.levelTitle;
    data['level_rate'] = this.levelRate;
    data['workout_image'] = this.workoutImage;
    data['workout_type_id'] = this.workoutTypeId;
    data['workout_type_title'] = this.workoutTypeTitle;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_favourite'] = this.isFavourite;
    data['description'] = this.description;
    return data;
  }
}

class Workoutday {
  int? id;
  int? workoutId;
  int? sequence;
  int? isRest;
  String? createdAt;
  String? updatedAt;

  Workoutday(
      {this.id,
        this.workoutId,
        this.sequence,
        this.isRest,
        this.createdAt,
        this.updatedAt});

  Workoutday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workoutId = json['workout_id'];
    sequence = json['sequence'];
    isRest = json['is_rest'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['workout_id'] = this.workoutId;
    data['sequence'] = this.sequence;
    data['is_rest'] = this.isRest;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}