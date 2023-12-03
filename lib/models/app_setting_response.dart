class AppSettingResponse {
  int? id;
  String? siteName;
  String? siteEmail;
  String? siteDescription;
  String? siteCopyright;
  String? facebookUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? linkedinUrl;
  List<String>? languageOption;
  String? contactEmail;
  String? contactNumber;
  String? helpSupportUrl;
  String? createdAt;
  String? updatedAt;

  AppSettingResponse(
      {this.id,
        this.siteName,
        this.siteEmail,
        this.siteDescription,
        this.siteCopyright,
        this.facebookUrl,
        this.instagramUrl,
        this.twitterUrl,
        this.linkedinUrl,
        this.languageOption,
        this.contactEmail,
        this.contactNumber,
        this.helpSupportUrl,
        this.createdAt,
        this.updatedAt});

  AppSettingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['site_name'];
    siteEmail = json['site_email'];
    siteDescription = json['site_description'];
    siteCopyright = json['site_copyright'];
    facebookUrl = json['facebook_url'];
    instagramUrl = json['instagram_url'];
    twitterUrl = json['twitter_url'];
    linkedinUrl = json['linkedin_url'];
    languageOption = json['language_option'].cast<String>();
    contactEmail = json['contact_email'];
    contactNumber = json['contact_number'];
    helpSupportUrl = json['help_support_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_name'] = this.siteName;
    data['site_email'] = this.siteEmail;
    data['site_description'] = this.siteDescription;
    data['site_copyright'] = this.siteCopyright;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    data['twitter_url'] = this.twitterUrl;
    data['linkedin_url'] = this.linkedinUrl;
    data['language_option'] = this.languageOption;
    data['contact_email'] = this.contactEmail;
    data['contact_number'] = this.contactNumber;
    data['help_support_url'] = this.helpSupportUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
