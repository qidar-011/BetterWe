class FitnessBaseResponse {
  String? message;

  FitnessBaseResponse({this.message});

  FitnessBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
class FitnessErrorBaseResponse {
  String? message;
  String? error;

  FitnessErrorBaseResponse({this.message,this.error});

  FitnessErrorBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}