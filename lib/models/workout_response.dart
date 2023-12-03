import 'pagination_model.dart';
import 'workout_detail_response.dart';

class WorkoutResponse {
  Pagination? pagination;
  List<WorkoutDetailModel>? data;

  WorkoutResponse({this.pagination, this.data});

  WorkoutResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <WorkoutDetailModel>[];
      json['data'].forEach((v) {
        data!.add(new WorkoutDetailModel.fromJson(v));
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
