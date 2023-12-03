import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import '../extensions/extension_util/int_extensions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:photo_view/photo_view.dart';

// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../components/adMob_component.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/setting_item_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/language_data_model.dart';
import '../models/reminder_model.dart';
import '../models/user_response.dart';
import '../network/rest_api.dart';
import 'app_config.dart';
import 'app_constants.dart';

void setTheme() {
  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);

  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', subTitle: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/Flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', subTitle: 'हिंदी', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/Flag/ic_in.png'),
    LanguageDataModel(id: 3, name: 'Arabic', subTitle: 'عربي', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/Flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', subTitle: 'français', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/Flag/ic_fr.png'),
    LanguageDataModel(id: 5, name: 'Portuguese', subTitle: 'português', languageCode: 'pt', fullLanguageCode: 'pt-PT', flag: 'assets/Flag/ic_pt.png'),
    LanguageDataModel(id: 6, name: 'Turkish', subTitle: 'Türk', languageCode: 'tr', fullLanguageCode: 'tr-TR', flag: 'assets/Flag/ic_tr.png'),
    LanguageDataModel(id: 7, name: 'Afrikaans', subTitle: 'Afrikaans', languageCode: 'af', fullLanguageCode: 'af-AF', flag: 'assets/Flag/ic_af.png'),
    LanguageDataModel(id: 8, name: 'Vietnamese', subTitle: 'Tiếng Việt', languageCode: 'vi', fullLanguageCode: 'vi-VI', flag: 'assets/Flag/ic_vi.png'),
  ];
}

class DiagonalPathClipperTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height - 50)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

Widget outlineIconButton(BuildContext context, {required String text, String? icon, Function()? onTap, Color? textColor}) {
  return OutlinedButton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ImageIcon(AssetImage(icon), color: appStore.isDarkMode ? Colors.white : primaryColor, size: 24),
        if (icon != null) SizedBox(width: 8),
        Text(text, style: primaryTextStyle(color: textColor ?? null, size: 14)),
      ],
    ),
    onPressed: onTap ?? () {},
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: textColor ?? (appStore.isDarkMode ? Colors.white38 : primaryColor), style: BorderStyle.solid),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

Widget cachedImage(String? url, {double? height, Color? color, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      progressIndicatorBuilder: (context, url, progress) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(ic_placeholder, height: height, width: width, fit: BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset(ic_placeholder, height: height, width: width, fit: BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

toast(String? value, {ToastGravity? gravity, length = Toast.LENGTH_SHORT, Color? bgColor, Color? textColor}) {
  Fluttertoast.showToast(
    msg: value.validate(),
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}

setLogInValue() {
  print(getBoolAsync(IS_LOGIN));
  userStore.setLogin(getBoolAsync(IS_LOGIN));
  if (userStore.isLoggedIn) {
    userStore.setToken(getStringAsync(TOKEN));
    userStore.setUserID(getIntAsync(USER_ID));
    userStore.setUserEmail(getStringAsync(EMAIL));
    userStore.setFirstName(getStringAsync(FIRSTNAME));
    userStore.setLastName(getStringAsync(LASTNAME));
    userStore.setUserPassword(getStringAsync(PASSWORD));
    userStore.setUserImage(getStringAsync(USER_PROFILE_IMG));
    userStore.setPhoneNo(getStringAsync(PHONE_NUMBER));
    userStore.setDisplayName(getStringAsync(DISPLAY_NAME));
    userStore.setGender(getStringAsync(GENDER));
    userStore.setAge(getStringAsync(AGE));
    userStore.setHeight(getStringAsync(HEIGHT));
    userStore.setHeightUnit(getStringAsync(HEIGHT_UNIT));
    userStore.setWeight(getStringAsync(WEIGHT));
    userStore.setWeightUnit(getStringAsync(WEIGHT_UNIT));

    if (!getStringAsync(SUBSCRIPTION_DETAIL).isEmptyOrNull) {
      SubscriptionDetail? subscriptionDetail = SubscriptionDetail.fromJson(jsonDecode(getStringAsync(SUBSCRIPTION_DETAIL)));
      userStore.setSubscribe(getIntAsync(IS_SUBSCRIBE));
      userStore.setSubscriptionDetail(subscriptionDetail);
      print(userStore.subscriptionDetail!.toJson().toString());
    }

    String notificationData = getStringAsync(NOTIFICATION_DETAIL);
    if (notificationData.isNotEmpty) {
      Iterable mList = jsonDecode(getStringAsync(NOTIFICATION_DETAIL));
      notificationStore.mRemindList = mList.map((model) => ReminderModel.fromJson(model)).toList();
    }
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String parseDocumentDate(DateTime dateTime, [bool includeTime = false]) {
  if (includeTime) {
    return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
  } else {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
}

progressDateStringWidget(String date) {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime dateTime = DateTime.parse(date);
  var dateValue = dateFormat.format(dateTime);
  return dateValue;
}

Future<void> launchUrls(String url, {bool forceWebView = false}) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

void openPhotoViewer(BuildContext context, ImageProvider imageProvider) {
  Scaffold(
    body: Stack(
      children: <Widget>[
        PhotoView(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: 1.0,
        ),
        Positioned(top: 35, left: 16, child: BackButton(color: Colors.white)),
      ],
    ),
  ).launch(context);
}

Widget mBlackEffect(double? width, double? height, {double? radiusValue = 16}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: radius(radiusValue),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.2),
          Colors.black.withOpacity(0.2),
          Colors.black.withOpacity(0.4),
          Colors.black.withOpacity(0.4),
        ],
      ),
    ),
    alignment: Alignment.bottomLeft,
  );
}

Widget mOption(String img, String title, Function? onCall) {
  return SettingItemWidget(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    title: title,
    leading: Image.asset(img, width: 20, height: 20, color: textPrimaryColorGlobal),
    trailing: appStore.selectedLanguageCode == 'ar' ? Icon(Icons.chevron_left, color: grayColor) : Icon(Icons.chevron_right, color: grayColor),
    onTap: () async {
      onCall!.call();
    },
  );
}

Future<void> getSettingData() async {
  await getAppSettingApi().then((value) {
    setValue(SITE_NAME, value.siteName.validate());
    setValue(SITE_DESCRIPTION, value.siteDescription.validate());
    setValue(SITE_COPYRIGHT, value.siteCopyright.validate());
    setValue(FACEBOOK_URL, value.facebookUrl.validate());
    setValue(INSTAGRAM_URL, value.instagramUrl.validate());
    setValue(TWITTER_URL, value.twitterUrl.validate());
    setValue(LINKED_URL, value.linkedinUrl.validate());
    setValue(CONTACT_EMAIL, value.contactEmail.validate());
    setValue(CONTACT_NUMBER, value.contactNumber.validate());
    setValue(HELP_SUPPORT, value.helpSupportUrl.validate());
    setValue(PRIVACY_POLICY, value.helpSupportUrl.validate());
    setValue(TERMS_SERVICE, value.helpSupportUrl.validate());
  });
}

Future<void> getUSerDetail(BuildContext context, int? id) async {
  await getUserDataApi(id: id.validate()).then((value) async {
    userStore.setFirstName(value.data!.firstName.validate());
    userStore.setUserEmail(value.data!.email.validate());
    userStore.setLastName(value.data!.lastName.validate());
    userStore.setGender(value.data!.gender.validate());
    userStore.setUserID(value.data!.id.validate());
    userStore.setPhoneNo(value.data!.phoneNumber.validate());
    userStore.setUsername(value.data!.username.validate());
    userStore.setDisplayName(value.data!.displayName.validate());
    userStore.setUserImage(value.data!.profileImage.validate());
    userStore.setAge(value.data!.userProfile!.age.validate());
    userStore.setHeight(value.data!.userProfile!.height.validate());
    userStore.setWeight(value.data!.userProfile!.weight.validate());
    userStore.setWeightUnit(value.data!.userProfile!.weightUnit.validate());
    userStore.setHeightUnit(value.data!.userProfile!.heightUnit.validate());
    userStore.setSubscribe(value.subscriptionDetail!.isSubscribe.validate());
    userStore.setSubscriptionDetail(value.subscriptionDetail!);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
  });
}

void showInterstitialAds() {
  if (userStore.isSubscribe == 0) {
    adShow();
  }
}

void loadInterstitialAds() {
  if (userStore.isSubscribe == 0) {
    createInterstitialAd();
  }
}

void oneSignalData() {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.consentRequired(false);

  OneSignal.initialize(mOneSignalID);


  OneSignal.User.pushSubscription.addObserver((state) async {
    print(OneSignal.User.pushSubscription.optedIn);
    print(OneSignal.User.pushSubscription.id);
    print(OneSignal.User.pushSubscription.token);
    await setValue(PLAYER_ID, OneSignal.User.pushSubscription.id);
  });
  if (userStore.isLoggedIn) {
    updatePlayerId();
  }
}

Widget mSuffixTextFieldIconWidget(String? img) {
  return Image.asset(img.validate(), height: 20, width: 20, color: Colors.grey).paddingAll(14);
}
