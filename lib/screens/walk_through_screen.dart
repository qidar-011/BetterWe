import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../extensions/app_button.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../screens/sign_in_screen.dart';
import '../../utils/app_images.dart';
import '../extensions/common.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/walk_through_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_config.dart';
import '../utils/app_constants.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController mPageController = PageController();

  List<WalkThroughModel> mWalkList = [];
  int mCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    mWalkList.add(WalkThroughModel(image: ic_walk1, title: WALK1_TITLE));
    mWalkList.add(WalkThroughModel(image: ic_walk2, title: WALK2_TITLE));
    mWalkList.add(WalkThroughModel(image: ic_walk3, title: WALK3_TITLE));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    mPageController.dispose();
    super.dispose();
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
        body: Stack(
          children: [
            Positioned(
              top: context.statusBarHeight + 30,
              left: 20,
              right: 20,
              child: Image.asset(ic_walk_shape, height: context.height() * 0.43, width: context.width(), fit: BoxFit.fill),
            ),
            PageView(
              controller: mPageController,
              children: mWalkList.map((e) {
                return Column(
                  children: [
                    Image.asset(mWalkList[mCurrentIndex].image!, height: context.height() * 0.55, fit: BoxFit.fill),
                  ],
                ).paddingTop(context.statusBarHeight + 30);
              }).toList(),
              onPageChanged: (i) {
                mCurrentIndex = i;
                setState(() {});
              },
            ),
            Positioned(
              top: context.statusBarHeight,
              right: 4,
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    setValue(IS_FIRST_TIME, true);
                    SignInScreen().launch(context);
                  },
                  child: Text(languages.lblSkip, style: boldTextStyle(color: primaryColor))),
            ).visible(mCurrentIndex != 2),
            Positioned(
              right: 24,
              left: 24,
              bottom: 50,
              child: Column(
                children: [
                  Text(mWalkList[mCurrentIndex].title.toString(), style: boldTextStyle(size: 22), textAlign: TextAlign.center),
                  16.height,
                  dotIndicator(mWalkList, mCurrentIndex),
                  30.height,
                  AppButton(
                    text: mCurrentIndex == 2 ? languages.lblGetStarted : languages.lblNext,
                    width: context.width(),
                    color: primaryColor,
                    onTap: () {
                      if (mCurrentIndex.toInt() >= 2) {
                        setValue(IS_FIRST_TIME, true);
                        SignInScreen().launch(context);
                      } else {
                        mPageController.nextPage(duration: Duration(seconds: 1), curve: Curves.linearToEaseOut);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
