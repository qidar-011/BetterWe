import 'dart:convert';

import 'package:mobx/mobx.dart';
import '../../extensions/shared_pref.dart';
import '../../models/user_response.dart';
import '../../utils/app_constants.dart';

part 'UserStore.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  int userId = 0;

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String fName = '';

  @observable
  String lName = '';

  @observable
  String profileImage = '';

  @observable
  String token = '';

  @observable
  String username = '';

  @observable
  String displayName = '';

  @observable
  String phoneNo = '';

  @observable
  String gender = '';

  @observable
  String age = '';

  @observable
  String height = '';

  @observable
  String weight = '';

  @observable
  String weightUnit = '';

  @observable
  String heightUnit = 'feet';

  @observable
  int isSubscribe = 0;

  @observable
  SubscriptionDetail? subscriptionDetail;

  @observable
  String termsCondition = '';

  @observable
  String currencySymbol = '';

  @observable
  String currencyCode = '';

  @observable
  String currencyPosition = '';

  @observable
  String oneSignalAppID = '';

  @observable
  String onesignalRestApiKey = '';

  @observable
  String admobBannerId = '';

  @observable
  String admobInterstitialId = '';

  @observable
  String admobBannerIdIos = '';

  @observable
  String admobInterstitialIdIos = '';

  @observable
  String chatGptApiKey = '';

  @observable
  String privacyPolicy = "";

  @action
  Future<void> setTermsCondition(String val, {bool isInitialization = false}) async {
    termsCondition = val;
    if (!isInitialization) await setValue(TermsCondition, val);
  }

  @action
  Future<void> setCurrencyCodeID(String val, {bool isInitialization = false}) async {
    currencySymbol = val;
    if (!isInitialization) await setValue(CurrencySymbol, val);
  }

  @action
  Future<void> setCurrencyCode(String val, {bool isInitialization = false}) async {
    currencyCode = val;
    if (!isInitialization) await setValue(CurrencyCode, val);
  }

  @action
  Future<void> setCurrencyPositionID(String val, {bool isInitialization = false}) async {
    currencyPosition = val;
    if (!isInitialization) await setValue(CurrencyPosition, val);
  }

  @action
  Future<void> setOneSignalAppID(String val, {bool isInitialization = false}) async {
    oneSignalAppID = val;
    if (!isInitialization) await setValue(OneSignalAppID, val);
  }

  @action
  Future<void> setOnesignalRestApiKey(String val, {bool isInitialization = false}) async {
    onesignalRestApiKey = val;
    if (!isInitialization) await setValue(OnesignalRestApiKey, val);
  }

  @action
  Future<void> setAdmobBannerId(String val, {bool isInitialization = false}) async {
    admobBannerId = val;
    if (!isInitialization) await setValue(AdmobBannerId, val);
  }

  @action
  Future<void> setAdmobInterstitialId(String val, {bool isInitialization = false}) async {
    admobInterstitialId = val;
    if (!isInitialization) await setValue(AdmobInterstitialId, val);
  }

  @action
  Future<void> setAdmobBannerIdIos(String val, {bool isInitialization = false}) async {
    admobBannerIdIos = val;
    if (!isInitialization) await setValue(AdmobBannerIdIos, val);
  }

  @action
  Future<void> setAdmobInterstitialIdIos(String val, {bool isInitialization = false}) async {
    admobInterstitialIdIos = val;
    if (!isInitialization) await setValue(AdmobInterstitialIdIos, val);
  }

  @action
  Future<void> setChatGptApiKey(String val, {bool isInitialization = false}) async {
    chatGptApiKey = val;
    if (!isInitialization) await setValue(ChatGptApiKey, val);
  }

  @action
  Future<void> setPrivacyPolicy(String val, {bool isInitialization = false}) async {
    privacyPolicy = val;
    if (!isInitialization) await setValue(PrivacyPolicy, val);
  }

  @action
  Future<void> setSubscriptionDetail(SubscriptionDetail val, {bool isInitialization = false}) async {
    subscriptionDetail = val;
    if (!isInitialization) await setValue(SUBSCRIPTION_DETAIL, jsonEncode(val));
  }

  @action
  Future<void> setSubscribe(int val, {bool isInitialization = false}) async {
    isSubscribe = val;
    if (!isInitialization) await setValue(IS_SUBSCRIBE, val);
  }

  @action
  Future<void> setHeightUnit(String val, {bool isInitialization = false}) async {
    heightUnit = val;
    if (!isInitialization) await setValue(HEIGHT_UNIT, val);
  }

  @action
  Future<void> setWeightUnit(String val, {bool isInitialization = false}) async {
    weightUnit = val;
    if (!isInitialization) await setValue(WEIGHT_UNIT, val);
  }

  @action
  Future<void> setWeight(String val, {bool isInitialization = false}) async {
    weight = val;
    if (!isInitialization) await setValue(HEIGHT, val);
  }

  @action
  Future<void> setHeight(String val, {bool isInitialization = false}) async {
    height = val;
    if (!isInitialization) await setValue(WEIGHT, val);
  }

  @action
  Future<void> setAge(String val, {bool isInitialization = false}) async {
    age = val;
    if (!isInitialization) await setValue(AGE, val);
  }

  @action
  Future<void> setGender(String val, {bool isInitialization = false}) async {
    gender = val;
    if (!isInitialization) await setValue(GENDER, val);
  }

  @action
  Future<void> setPhoneNo(String val, {bool isInitialization = false}) async {
    phoneNo = val;
    if (!isInitialization) await setValue(PHONE_NUMBER, val);
  }

  @action
  Future<void> setDisplayName(String val, {bool isInitialization = false}) async {
    displayName = val;
    if (!isInitialization) await setValue(DISPLAY_NAME, val);
  }

  @action
  Future<void> setUsername(String val, {bool isInitialization = false}) async {
    username = val;
    if (!isInitialization) await setValue(USERNAME, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitialization = false}) async {
    token = val;
    if (!isInitialization) await setValue(TOKEN, val);
  }

  @action
  Future<void> setUserImage(String val, {bool isInitialization = false}) async {
    profileImage = val;
    if (!isInitialization) await setValue(USER_PROFILE_IMG, val);
  }

  @action
  Future<void> setUserID(int val, {bool isInitialization = false}) async {
    userId = val;
    if (!isInitialization) await setValue(USER_ID, val);
  }

  @action
  Future<void> setLogin(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGIN, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitialization = false}) async {
    fName = val;
    if (!isInitialization) await setValue(FIRSTNAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitialization = false}) async {
    lName = val;
    if (!isInitialization) await setValue(LASTNAME, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitialization = false}) async {
    email = val;
    if (!isInitialization) await setValue(EMAIL, val);
  }

  @action
  Future<void> setUserPassword(String val, {bool isInitialization = false}) async {
    password = val;
    if (!isInitialization) await setValue(PASSWORD, val);
  }

  @action
  Future<void> clearUserData() async {
    fName = '';
    lName = '';
    profileImage = '';
    token = '';
    username = '';
    displayName = '';
    phoneNo = '';
    gender = '';
    age = '';
    height = '';
    weight = '';
    weightUnit = '';
    heightUnit = '';
  }
}
