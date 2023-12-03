class RegisterRequest {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;
  String? userType;
  String? phoneNumber;
  String? gender;
  UserProfile? userProfile;

  RegisterRequest(
      {this.firstName,
        this.lastName,
        this.username,
        this.email,
        this.password,
        this.userType,
        this.phoneNumber,
        this.gender,
        this.userProfile});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.toJson();
    }
    return data;
  }
}

class UserProfile {
  int? age;
  String? weight;
  String? weightUnit;
  String? height;
  String? heightUnit;
  String? address;

  UserProfile(
      {this.age,
        this.weight,
        this.weightUnit,
        this.height,
        this.heightUnit,
        this.address});

  UserProfile.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    height = json['height'];
    heightUnit = json['height_unit'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['weight'] = this.weight;
    data['weight_unit'] = this.weightUnit;
    data['height'] = this.height;
    data['height_unit'] = this.heightUnit;
    data['address'] = this.address;
    return data;
  }
}
