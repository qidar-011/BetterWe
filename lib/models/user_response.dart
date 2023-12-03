class UserResponse {
  Data? data;
  SubscriptionDetail? subscriptionDetail;

  UserResponse({this.data, this.subscriptionDetail});

  UserResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    subscriptionDetail = json['subscription_detail'] != null
        ? new SubscriptionDetail.fromJson(json['subscription_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.subscriptionDetail != null) {
      data['subscription_detail'] = this.subscriptionDetail!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? email;
  String? username;
  String? gender;
  String? status;
  String? userType;
  String? phoneNumber;
  String? playerId;
  String? profileImage;
  String? loginType;
  String? createdAt;
  String? updatedAt;
  UserProfile? userProfile;
  int? isSubscribe;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.displayName,
        this.email,
        this.username,
        this.gender,
        this.status,
        this.userType,
        this.phoneNumber,
        this.playerId,
        this.profileImage,
        this.loginType,
        this.createdAt,
        this.updatedAt,
        this.userProfile,
        this.isSubscribe});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    email = json['email'];
    username = json['username'];
    gender = json['gender'];
    status = json['status'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    playerId = json['player_id'];
    profileImage = json['profile_image'];
    loginType = json['login_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
    isSubscribe = json['is_subscribe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['username'] = this.username;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['player_id'] = this.playerId;
    data['profile_image'] = this.profileImage;
    data['login_type'] = this.loginType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.toJson();
    }
    data['is_subscribe'] = this.isSubscribe;
    return data;
  }
}

class UserProfile {
  int? id;
  String? age;
  String? weight;
  String? weightUnit;
  String? height;
  String? heightUnit;
  String? address;
  int? userId;
  String? createdAt;
  String? updatedAt;

  UserProfile(
      {this.id,
        this.age,
        this.weight,
        this.weightUnit,
        this.height,
        this.heightUnit,
        this.address,
        this.userId,
        this.createdAt,
        this.updatedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    age = json['age'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    height = json['height'];
    heightUnit = json['height_unit'];
    address = json['address'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['age'] = this.age;
    data['weight'] = this.weight;
    data['weight_unit'] = this.weightUnit;
    data['height'] = this.height;
    data['height_unit'] = this.heightUnit;
    data['address'] = this.address;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SubscriptionDetail {
  int? isSubscribe;
  SubscriptionPlan? subscriptionPlan;

  SubscriptionDetail({this.isSubscribe, this.subscriptionPlan});

  SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    isSubscribe = json['is_subscribe'];
    subscriptionPlan = json['subscription_plan'] != null
        ? new SubscriptionPlan.fromJson(json['subscription_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_subscribe'] = this.isSubscribe;
    if (this.subscriptionPlan != null) {
      data['subscription_plan'] = this.subscriptionPlan!.toJson();
    }
    return data;
  }
}

class SubscriptionPlan {
  int? id;
  int? userId;
  String? userName;
  int? packageId;
  String? packageName;
  int? totalAmount;
  String? paymentType;
  String? txnId;
  String? transactionDetail;
  String? paymentStatus;
  String? status;
  PackageData? packageData;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  String? createdAt;
  String? updatedAt;

  SubscriptionPlan(
      {this.id,
        this.userId,
        this.userName,
        this.packageId,
        this.packageName,
        this.totalAmount,
        this.paymentType,
        this.txnId,
        this.transactionDetail,
        this.paymentStatus,
        this.status,
        this.packageData,
        this.subscriptionStartDate,
        this.subscriptionEndDate,
        this.createdAt,
        this.updatedAt});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    packageId = json['package_id'];
    packageName = json['package_name'];
    totalAmount = json['total_amount'];
    paymentType = json['payment_type'];
    txnId = json['txn_id'];
    transactionDetail = json['transaction_detail'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    packageData = json['package_data'] != null
        ? new PackageData.fromJson(json['package_data'])
        : null;
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['package_id'] = this.packageId;
    data['package_name'] = this.packageName;
    data['total_amount'] = this.totalAmount;
    data['payment_type'] = this.paymentType;
    data['txn_id'] = this.txnId;
    data['transaction_detail'] = this.transactionDetail;
    data['payment_status'] = this.paymentStatus;
    data['status'] = this.status;
    if (this.packageData != null) {
      data['package_data'] = this.packageData!.toJson();
    }
    data['subscription_start_date'] = this.subscriptionStartDate;
    data['subscription_end_date'] = this.subscriptionEndDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PackageData {
  int? id;
  String? name;
  int? price;
  String? status;
  int? duration;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? durationUnit;

  PackageData(
      {this.id,
        this.name,
        this.price,
        this.status,
        this.duration,
        this.createdAt,
        this.updatedAt,
        this.description,
        this.durationUnit});

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    duration = json['duration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    durationUnit = json['duration_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['duration_unit'] = this.durationUnit;
    return data;
  }
}
