import 'package:flutter/material.dart';
import '../models/language_data_model.dart';
import 'base_language.dart';
import 'language_af.dart';
import 'language_ar.dart';
import 'language_en.dart';
import 'language_fr.dart';
import 'language_hi.dart';
import 'language_pt.dart';
import 'language_tr.dart';
import 'language_vi.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'af':
        return LanguageAf();
      case 'vi':
        return LanguageVi();
      case 'fr':
        return LanguageFr();
      case 'hi':
        return LanguageHi();
      case 'tr':
        return LanguageTr();
      case 'pt':
        return LanguagePt();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
