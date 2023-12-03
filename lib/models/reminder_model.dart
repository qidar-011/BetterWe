class ReminderModel {
  int? id;
  String? duration;
  String? title;
  String? subTitle;
  String? week;
  int? status;

  ReminderModel(
      {this.id,
        this.duration,
        this.title,
        this.subTitle,
        this.week,
        this.status,
       });
  ReminderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = json['duration'];
    title = json['title'];
    subTitle = json['subTitle'];
    week = json['week'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['duration'] = this.duration;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['week'] = this.week;
    data['status'] = this.status;

    return data;
  }
}