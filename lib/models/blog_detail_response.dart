import '../models/blog_response.dart';

class BlogDetailResponse {
  BlogModel? data;

  BlogDetailResponse({this.data});

  BlogDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new BlogModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}