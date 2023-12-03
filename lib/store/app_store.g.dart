// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  late final _$isDarkModeAtom =
      Atom(name: 'AppStoreBase.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'AppStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$selectedLanguageCodeAtom =
      Atom(name: 'AppStoreBase.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$signUpIndexAtom =
      Atom(name: 'AppStoreBase.signUpIndex', context: context);

  @override
  int get signUpIndex {
    _$signUpIndexAtom.reportRead();
    return super.signUpIndex;
  }

  @override
  set signUpIndex(int value) {
    _$signUpIndexAtom.reportWrite(value, super.signUpIndex, () {
      super.signUpIndex = value;
    });
  }

  late final _$isSurveyAtom =
      Atom(name: 'AppStoreBase.isSurvey', context: context);

  @override
  bool get isSurvey {
    _$isSurveyAtom.reportRead();
    return super.isSurvey;
  }

  @override
  set isSurvey(bool value) {
    _$isSurveyAtom.reportWrite(value, super.isSurvey, () {
      super.isSurvey = value;
    });
  }

  late final _$adsTypeAtom =
      Atom(name: 'AppStoreBase.adsType', context: context);

  @override
  String get adsType {
    _$adsTypeAtom.reportRead();
    return super.adsType;
  }

  @override
  set adsType(String value) {
    _$adsTypeAtom.reportWrite(value, super.adsType, () {
      super.adsType = value;
    });
  }

  late final _$bannerIdAtom =
      Atom(name: 'AppStoreBase.bannerId', context: context);

  @override
  String get bannerId {
    _$bannerIdAtom.reportRead();
    return super.bannerId;
  }

  @override
  set bannerId(String value) {
    _$bannerIdAtom.reportWrite(value, super.bannerId, () {
      super.bannerId = value;
    });
  }

  late final _$bannerIdIosAtom =
      Atom(name: 'AppStoreBase.bannerIdIos', context: context);

  @override
  String get bannerIdIos {
    _$bannerIdIosAtom.reportRead();
    return super.bannerIdIos;
  }

  @override
  set bannerIdIos(String value) {
    _$bannerIdIosAtom.reportWrite(value, super.bannerIdIos, () {
      super.bannerIdIos = value;
    });
  }

  late final _$interstitialIdAtom =
      Atom(name: 'AppStoreBase.interstitialId', context: context);

  @override
  String get interstitialId {
    _$interstitialIdAtom.reportRead();
    return super.interstitialId;
  }

  @override
  set interstitialId(String value) {
    _$interstitialIdAtom.reportWrite(value, super.interstitialId, () {
      super.interstitialId = value;
    });
  }

  late final _$interstitialIdIosAtom =
      Atom(name: 'AppStoreBase.interstitialIdIos', context: context);

  @override
  String get interstitialIdIos {
    _$interstitialIdIosAtom.reportRead();
    return super.interstitialIdIos;
  }

  @override
  set interstitialIdIos(String value) {
    _$interstitialIdIosAtom.reportWrite(value, super.interstitialIdIos, () {
      super.interstitialIdIos = value;
    });
  }

  late final _$setSurveyStatusAsyncAction =
      AsyncAction('AppStoreBase.setSurveyStatus', context: context);

  @override
  Future<void> setSurveyStatus() {
    return _$setSurveyStatusAsyncAction.run(() => super.setSurveyStatus());
  }

  late final _$setAdsTypeAsyncAction =
      AsyncAction('AppStoreBase.setAdsType', context: context);

  @override
  Future<void> setAdsType(String val) {
    return _$setAdsTypeAsyncAction.run(() => super.setAdsType(val));
  }

  late final _$setBannerIdAsyncAction =
      AsyncAction('AppStoreBase.setBannerId', context: context);

  @override
  Future<void> setBannerId(String val) {
    return _$setBannerIdAsyncAction.run(() => super.setBannerId(val));
  }

  late final _$setBannerIdIosAsyncAction =
      AsyncAction('AppStoreBase.setBannerIdIos', context: context);

  @override
  Future<void> setBannerIdIos(String val) {
    return _$setBannerIdIosAsyncAction.run(() => super.setBannerIdIos(val));
  }

  late final _$setInterstitialIdAsyncAction =
      AsyncAction('AppStoreBase.setInterstitialId', context: context);

  @override
  Future<void> setInterstitialId(String val) {
    return _$setInterstitialIdAsyncAction
        .run(() => super.setInterstitialId(val));
  }

  late final _$setInterstitialIdIosAsyncAction =
      AsyncAction('AppStoreBase.setInterstitialIdIos', context: context);

  @override
  Future<void> setInterstitialIdIos(String val) {
    return _$setInterstitialIdIosAsyncAction
        .run(() => super.setInterstitialIdIos(val));
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('AppStoreBase.setLanguage', context: context);

  @override
  Future<void> setLanguage(String aCode, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(aCode, context: context));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('AppStoreBase.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  late final _$AppStoreBaseActionController =
      ActionController(name: 'AppStoreBase', context: context);

  @override
  void setLoading(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
selectedLanguageCode: ${selectedLanguageCode},
signUpIndex: ${signUpIndex},
isSurvey: ${isSurvey},
adsType: ${adsType},
bannerId: ${bannerId},
bannerIdIos: ${bannerIdIos},
interstitialId: ${interstitialId},
interstitialIdIos: ${interstitialIdIos}
    ''';
  }
}
