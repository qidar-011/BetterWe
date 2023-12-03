import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../store/NotificationStore/NotificationStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/system_utils.dart';
import '../../store/app_store.dart';
import 'app_theme.dart';
import 'extensions/common.dart';
import 'extensions/constants.dart';
import 'extensions/decorations.dart';
import 'extensions/shared_pref.dart';
import 'language/app_localizations.dart';
import 'language/base_language.dart';
import 'models/language_data_model.dart';
import 'network/rest_api.dart';
import 'screens/no_internet_screen.dart';
import 'screens/splash_screen.dart';
import 'store/UserStore/UserStore.dart';
import 'utils/app_common.dart';
import 'utils/app_config.dart';
import 'utils/app_constants.dart';

AppStore appStore = AppStore();
UserStore userStore = UserStore();
NotificationStore notificationStore = NotificationStore();

late SharedPreferences sharedPreferences;
final navigatorKey = GlobalKey<NavigatorState>();
late BaseLanguage languages;
List<LanguageDataModel> localeLanguageList = [];
LanguageDataModel? selectedLanguageDataModel;

Future<void> initialize({
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  localeLanguageList = aLocaleLanguageList ?? [];
  selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await initialize(aLocaleLanguageList: languageList());
  appStore.setLanguage(DEFAULT_LANGUAGE);

  await Firebase.initializeApp().then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  });

  setLogInValue();
  defaultAppButtonShapeBorder = RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius));
  setTheme();
  oneSignalData();
  runApp(MyApp());
}

Future<void> updatePlayerId() async {
  Map req = {
    "player_id": getStringAsync(PLAYER_ID),
  };
  await updateProfileApi(req).then((value) {
    //
  }).catchError((error) {
    //
  });
}

class MyApp extends StatefulWidget {
  static String tag = '/MyApp';

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isCurrentlyOnNoInternet = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push(NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast('Internet is connected.');
        }
        log('connected');
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
        title: APP_NAME,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        scrollBehavior: SBehavior(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode.validate(value: DEFAULT_LANGUAGE)),
        home: SplashScreen(),
      );
    });
  }
}
