class AppConfigurationResponse {
  bool? enableCustomDashboard;
  bool? disableQuickView;
  bool? disableStory;
  String? dashboardType;
  SocialLink? socialLink;
  Admob? admob;

  AppConfigurationResponse({this.enableCustomDashboard, this.disableQuickView, this.disableStory, this.socialLink, this.dashboardType, this.admob});

  AppConfigurationResponse.fromJson(Map<String, dynamic> json) {
    enableCustomDashboard = json['enable_custom_dashboard'];
    disableQuickView = json['disable_quickview'];
    disableStory = json['disable_story'];
    dashboardType = json['dashboard_type'];
    socialLink = json['social_link'] != null ? new SocialLink.fromJson(json['social_link']) : null;
    admob = json['ads_configuration'] != null ? new Admob.fromJson(json['ads_configuration']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enable_custom_dashboard'] = this.enableCustomDashboard;
    data['disable_quickview'] = this.disableQuickView;
    data['disable_story'] = this.disableStory;
    data['dashboard_type'] = this.dashboardType;
    if (this.socialLink != null) {
      data['social_link'] = this.socialLink!.toJson();
    }
    if (this.admob != null) {
      data['ads_configuration'] = this.admob!.toJson();
    }
    return data;
  }
}

class SocialLink {
  String? whatsapp;
  String? facebook;
  String? twitter;
  String? instagram;
  String? contact;
  String? websiteUrl;
  String? privacyPolicy;
  String? copyrightText;
  String? termCondition;

  SocialLink({this.whatsapp, this.facebook, this.twitter, this.instagram, this.contact, this.websiteUrl, this.privacyPolicy, this.copyrightText, this.termCondition});

  SocialLink.fromJson(Map<String, dynamic> json) {
    whatsapp = json['whatsapp'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    contact = json['contact'];
    websiteUrl = json['website_url'];
    privacyPolicy = json['privacy_policy'];
    copyrightText = json['copyright_text'];
    termCondition = json['term_condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['whatsapp'] = this.whatsapp;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    data['contact'] = this.contact;
    data['website_url'] = this.websiteUrl;
    data['privacy_policy'] = this.privacyPolicy;
    data['copyright_text'] = this.copyrightText;
    data['term_condition'] = this.termCondition;
    return data;
  }
}

class Admob {
  String? bannerId;
  String? bannerIdIos;
  String? interstitialId;
  String? interstitialIdIos;
  String? adsType;

  Admob({this.bannerId, this.bannerIdIos, this.interstitialId, this.interstitialIdIos, this.adsType});

  Admob.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    bannerIdIos = json['banner_id_ios'];
    interstitialId = json['interstitial_id'];
    interstitialIdIos = json['interstitial_id_ios'];
    adsType = json['ads_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_id'] = this.bannerId;
    data['banner_id_ios'] = this.bannerIdIos;
    data['interstitial_id'] = this.interstitialId;
    data['interstitial_id_ios'] = this.interstitialIdIos;
    data['ads_type'] = this.adsType;
    return data;
  }
}
