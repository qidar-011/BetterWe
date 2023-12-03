import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../screens/dashboard_screen.dart';
import '../../extensions/extension_util/duration_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../extensions/shared_pref.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/colors.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/app_images.dart';
import '../extensions/text_styles.dart';
import '../utils/app_constants.dart';
import 'sign_in_screen.dart';
import 'walk_through_screen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await 1.seconds.delay;
    if (!getBoolAsync(IS_FIRST_TIME)) {
      WalkThroughScreen().launch(context, isNewTask: true);
    } else {
      if (userStore.isLoggedIn) {
        DashboardScreen().launch(context, isNewTask: true);
      } else {
        SignInScreen().launch(context, isNewTask: true);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : whiteColor,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ic_splash_logo, width: 220, height: 140, fit: BoxFit.fill),
                16.height,
                Text(APP_NAME, style: boldTextStyle(size: 26, letterSpacing: 1)),
              ],
            ).center(),
          ],
        ).paddingBottom(10),
      ),
    );
  }
}
