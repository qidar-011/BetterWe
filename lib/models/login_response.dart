class LoginResponse {
  UserModel? data;

  LoginResponse({this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserModel {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? emailVerifiedAt;
  String? userType;
  String? status;
  String? loginType;
  String? gender;
  String? displayName;
  String? playerId;
  int? isSubscribe;
  String? createdAt;
  String? updatedAt;
  String? apiToken;
  String? profileImage;

  UserModel(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.emailVerifiedAt,
      this.userType,
      this.status,
      this.loginType,
      this.gender,
      this.displayName,
      this.playerId,
      this.isSubscribe,
      this.createdAt,
      this.updatedAt,
      this.apiToken,
      this.profileImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    emailVerifiedAt = json['email_verified_at'];
    userType = json['user_type'];
    status = json['status'];
    loginType = json['login_type'];
    gender = json['gender'];
    displayName = json['display_name'];
    playerId = json['player_id'];
    isSubscribe = json['is_subscribe'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apiToken = json['api_token'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['login_type'] = this.loginType;
    data['gender'] = this.gender;
    data['display_name'] = this.displayName;
    data['player_id'] = this.playerId;
    data['is_subscribe'] = this.isSubscribe;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['api_token'] = this.apiToken;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
