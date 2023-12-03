import '../models/pagination_model.dart';

class DayExerciseResponse {
  Pagination? pagination;
  List<DayExerciseModel>? data;

  DayExerciseResponse({this.pagination, this.data});

  DayExerciseResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <DayExerciseModel>[];
      json['data'].forEach((v) {
        data!.add(new DayExerciseModel.fromJson(v));
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

class DayExerciseModel {
  int? id;
  int? workoutId;
  int? workoutDayId;
  int? exerciseId;
  String? exerciseImage;
  String? exerciseTitle;
  int? exerciseIsPremium;
  Exercise? exercise;
  int? sequence;
  String? createdAt;
  String? updatedAt;

  DayExerciseModel(
      {this.id,
        this.workoutId,
        this.workoutDayId,
        this.exerciseId,
        this.exerciseImage,
        this.exerciseTitle,
        this.exerciseIsPremium,
        this.exercise,
        this.sequence,
        this.createdAt,
        this.updatedAt});

  DayExerciseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workoutId = json['workout_id'];
    workoutDayId = json['workout_day_id'];
    exerciseId = json['exercise_id'];
    exerciseImage = json['exercise_image'];
    exerciseTitle = json['exercise_title'];
    exerciseIsPremium = json['exercise_is_premium'];
    exercise = json['exercise'] != null
        ? new Exercise.fromJson(json['exercise'])
        : null;
    sequence = json['sequence'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['workout_id'] = this.workoutId;
    data['workout_day_id'] = this.workoutDayId;
    data['exercise_id'] = this.exerciseId;
    data['exercise_image'] = this.exerciseImage;
    data['exercise_title'] = this.exerciseTitle;
    data['exercise_is_premium'] = this.exerciseIsPremium;
    if (this.exercise != null) {
      data['exercise'] = this.exercise!.toJson();
    }
    data['sequence'] = this.sequence;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Exercise {
  int? id;
  String? title;
  String? status;
  int? isPremium;
  String? exerciseImage;
  String? instruction;
  List<BodypartName>? bodypartName;
  int? levelId;
  String? levelTitle;
  String? duration;
  List<Sets>? sets;
  String? based;
  String? type;
  String? createdAt;
  String? updatedAt;

  Exercise(
      {this.id,
        this.title,
        this.status,
        this.isPremium,
        this.exerciseImage,
        this.instruction,
        this.bodypartName,
        this.levelId,
        this.levelTitle,
        this.duration,
        this.sets,
        this.based,
        this.type,
        this.createdAt,
        this.updatedAt});

  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isPremium = json['is_premium'];
    exerciseImage = json['exercise_image'];
    instruction = json['instruction'];
    if (json['bodypart_name'] != null) {
      bodypartName = <BodypartName>[];
      json['bodypart_name'].forEach((v) {
        bodypartName!.add(new BodypartName.fromJson(v));
      });
    }
    levelId = json['level_id'];
    levelTitle = json['level_title'];
    duration = json['duration'];
    if (json['sets'] != null) {
      sets = <Sets>[];
      json['sets'].forEach((v) {
        sets!.add(new Sets.fromJson(v));
      });
    }
    based = json['based'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['is_premium'] = this.isPremium;
    data['exercise_image'] = this.exerciseImage;
    data['instruction'] = this.instruction;
    if (this.bodypartName != null) {
      data['bodypart_name'] =
          this.bodypartName!.map((v) => v.toJson()).toList();
    }
    data['level_id'] = this.levelId;
    data['level_title'] = this.levelTitle;
    data['duration'] = this.duration;
    if (this.sets != null) {
      data['sets'] = this.sets!.map((v) => v.toJson()).toList();
    }
    data['based'] = this.based;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
