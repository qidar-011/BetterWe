class NotificationResponse {
  List<NotificationData>? notificationData;
  int? allUnreadCount;

  NotificationResponse({this.notificationData, this.allUnreadCount});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    if (json['notification_data'] != null) {
      notificationData = <NotificationData>[];
      json['notification_data'].forEach((v) {
        notificationData!.add(new NotificationData.fromJson(v));
      });
    }
    allUnreadCount = json['all_unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationData != null) {
      data['notification_data'] =
          this.notificationData!.map((v) => v.toJson()).toList();
    }
    data['all_unread_count'] = this.allUnreadCount;
    return data;
  }
}

class NotificationData {
  String? id;
  String? readAt;
  String? createdAt;
  NotificationModel? data;
  String? image;
  bool select = false;

  NotificationData(
      {this.id, this.readAt, this.createdAt, this.data, this.image});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    data = json['data'] != null ? new NotificationModel.fromJson(json['data']) : null;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['image'] = this.image;
    return data;
  }
}

class NotificationModel {
  int? id;
  int? pushNotificationId;
  String? type;
  String? subject;
  String? message;
  String? image;

  NotificationModel(
      {this.id,
        this.pushNotificationId,
        this.type,
        this.subject,
        this.message,
        this.image});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pushNotificationId = json['push_notification_id'];
    type = json['type'];
    subject = json['subject'];
    message = json['message'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['push_notification_id'] = this.pushNotificationId;
    data['type'] = this.type;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['image'] = this.image;
    return data;
  }
}
