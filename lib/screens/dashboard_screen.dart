import 'dart:ui';
import 'package:flutter/material.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../screens/chatting_screen.dart';
import '../screens/product_screen.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../screens/diet_screen.dart';
import '../components/double_back_to_close_app.dart';
import '../components/permission.dart';
import '../extensions/constants.dart';
import '../extensions/shared_pref.dart';
import '../extensions/LiveStream.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/bottom_bar_item_model.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int mCurrentIndex = 0;
  int mCounter = 0;

  final tab = [
    //HomeScreen(),
    DietScreen(),
   // ProductScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  List<BottomBarItemModel> bottomItemList = [
    BottomBarItemModel(iconData: ic_home_outline, selectedIconData: ic_home_fill, labelText: languages.lblHome),
    //BottomBarItemModel(iconData: ic_diet_outline, selectedIconData: ic_diet_fill, labelText: languages.lblDiet),
    //BottomBarItemModel(iconData: ic_store_outline, selectedIconData: ic_store_fill, labelText: languages.lblShop),
    BottomBarItemModel(iconData: ic_report_outline, selectedIconData: ic_report_fill, labelText: languages.lblReport),
    BottomBarItemModel(iconData: ic_user, selectedIconData: ic_user_fill_icon, labelText: languages.lblProfile),
  ];

  @override
  void initState() {
    super.initState();
    init();

    LiveStream().on("LANGUAGE", (s) {
      setState(() {});
    });
  }

  init() async {
    //
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
    getSettingList();
    Permissions.activityPermissionsGranted();
  }

  Future<void> getSettingList() async {
    await getSettingApi().then((value) {
      userStore.setCurrencyCodeID(value.currencySetting!.symbol.validate());
      userStore.setCurrencyPositionID(value.currencySetting!.position.validate());
      userStore.setCurrencyCode(value.currencySetting!.code.validate());
      for (int i = 0; i < value.data!.length; i++) {
        switch (value.data![i].key) {
          case "terms_condition":
            {
              userStore.setTermsCondition(value.data![i].value.validate());
            }
          case "privacy_policy":
            {
              userStore.setPrivacyPolicy(value.data![i].value.validate());
            }
          case "ONESIGNAL_APP_ID":
            {
              userStore.setOneSignalAppID(value.data![i].value.validate());
            }
          case "ONESIGNAL_REST_API_KEY":
            {
              userStore.setOnesignalRestApiKey(value.data![i].value.validate());
            }
          case "ADMOB_BannerId":
            {
              userStore.setAdmobBannerId(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialId":
            {
              userStore.setAdmobInterstitialId(value.data![i].value.validate());
            }
          case "ADMOB_BannerIdIos":
            {
              userStore.setAdmobBannerIdIos(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialIdIos":
            {
              userStore.setAdmobInterstitialIdIos(value.data![i].value.validate());
            }
          case "CHATGPT_API_KEY":
            {
              userStore.setChatGptApiKey(value.data![i].value.validate());
            }
        }
      }
      getSettingData();
    });
  }

  @override
  void didChangeDependencies() {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          elevation: 4,
          backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryOpacity,
          content: Text(languages.lblTapBackAgainToLeave, style: primaryTextStyle()),
        ),
        child: AnimatedContainer(
          color: context.cardColor,
          duration: const Duration(seconds: 1),
          child: IndexedStack(index: mCurrentIndex, children: tab),
        ),
      ),
      //todo: uncomment this code for chatbot
      // floatingActionButton: mCurrentIndex == 0
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           ChattingScreen().launch(context);
      //         },
      //         backgroundColor: primaryColor,
      //         child: Image.asset(ic_bot, color: Colors.white, width: 26, height: 26),
      //       )
      //     : SizedBox(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        enableFeedback: false,
        selectedLabelStyle: secondaryTextStyle(),
        unselectedLabelStyle: secondaryTextStyle(),
        backgroundColor: context.cardColor,
        currentIndex: mCurrentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: primaryColor,
        onTap: (index) {
          mCurrentIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Image.asset(ic_home_outline, color: Colors.grey, height: 24), activeIcon: Image.asset(ic_home_fill, color: primaryColor, height: 24), label: languages.lblHome),
      //    BottomNavigationBarItem(icon: Image.asset(ic_diet_outline, color: Colors.grey, height: 24), activeIcon: Image.asset(ic_diet_fill, color: primaryColor, height: 24), label: languages.lblDiet),
         // BottomNavigationBarItem(icon: Image.asset(ic_store_outline, color: Colors.grey, height: 24), activeIcon: Image.asset(ic_store_fill, color: primaryColor, height: 24), label: languages.lblShop),
          BottomNavigationBarItem(icon: Image.asset(ic_report_outline, color: Colors.grey, height: 24), activeIcon: Image.asset(ic_report_fill, color: primaryColor, height: 24), label: languages.lblReport),
          BottomNavigationBarItem(icon: Image.asset(ic_user, color: Colors.grey, height: 24), activeIcon: Image.asset(ic_user_fill_icon, color: primaryColor, height: 24), label: languages.lblProfile),
        ],
      ),
    );
  }
}
