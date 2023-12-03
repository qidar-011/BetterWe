class SocialLoginResponse {
  bool? status;
  bool? isUserExist;
  String? message;
  Data? data;

  SocialLoginResponse({this.status, this.message, this.data,this.isUserExist});

  SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isUserExist = json['is_user_exist'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['is_user_exist'] = this.isUserExist;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? userType;
  String? status;
  String? loginType;
  String? gender;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? apiToken;
  String? profileImage;

  Data(
      {this.id,
        this.username,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.userType,
        this.status,
        this.loginType,
        this.gender,
        this.displayName,
        this.createdAt,
        this.updatedAt,
        this.apiToken,
        this.profileImage,
        });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
    status = json['status'];
    loginType = json['login_type'];
    gender = json['gender'];
    displayName = json['display_name'];
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
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['login_type'] = this.loginType;
    data['gender'] = this.gender;
    data['display_name'] = this.displayName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['api_token'] = this.apiToken;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
