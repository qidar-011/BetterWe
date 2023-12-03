import 'package:flutter/material.dart';
import '../extensions/system_utils.dart';
import '../language/app_localizations.dart';
import '../main.dart';
import '../models/language_data_model.dart';
import '../extensions/colors.dart';
import '../extensions/constants.dart';
import '../utils/app_colors.dart';
import 'package:mobx/mobx.dart';
import '../extensions/shared_pref.dart';
import '../utils/app_constants.dart';
import '../language/base_language.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  String selectedLanguageCode = '';

  @observable
  int signUpIndex = 0;

  @observable
  bool isSurvey = false;

  @observable
  String adsType = "";

  @observable
  String bannerId = "";

  @observable
  String bannerIdIos = "";

  @observable
  String interstitialId = "";

  @observable
  String interstitialIdIos = "";

  @action
  void setLoading(bool val) => isLoading = val;

  @action
  Future<void> setSurveyStatus() async {
    if (getBoolAsync(IS_FREE_TRIAL_START)) {
      isSurvey = true;
    } else {
      isSurvey = false;
    }
  }

  @action
  Future<void> setAdsType(String val) async {
    adsType = val;
  }

  @action
  Future<void> setBannerId(String val) async {
    bannerId = val;
  }

  @action
  Future<void> setBannerIdIos(String val) async {
    bannerIdIos = val;
  }

  @action
  Future<void> setInterstitialId(String val) async {
    interstitialId = val;
  }

  @action
  Future<void> setInterstitialIdIos(String val) async {
    interstitialIdIos = val;
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    // selectedLanguageCode = aCode;
    // language = getSelectedLanguageModel();
    // language = localeLanguageList.firstWhere((element) => element.languageCode == aCode);
    // await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);
    //
    // languages = await AppLocalizations().load(Locale(selectedLanguageCode));

    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: aCode);
    selectedLanguageCode = getSelectedLanguageModel(defaultLanguage: defaultValues.defaultLanguage)!.languageCode!;

    if (context != null) languages = BaseLanguage.of(context)!;
    languages = await AppLocalizations().load(Locale(selectedLanguageCode));
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = viewLineColor;
      defaultLoaderBgColorGlobal = Colors.black26;
      defaultLoaderAccentColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;
      setStatusBarColor(scaffoldColorDark,statusBarBrightness: Brightness.light,statusBarIconBrightness: Brightness.light);
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = Colors.white;
      defaultLoaderAccentColorGlobal = primaryColor;
      appButtonBackgroundColorGlobal = primaryColor;
      shadowColorGlobal = Colors.black12;
      setStatusBarColor(whiteColor,statusBarBrightness: Brightness.dark,statusBarIconBrightness: Brightness.dark);
    }
  }

}
