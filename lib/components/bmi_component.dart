import 'package:flutter/material.dart';
import 'package:mighty_fitness/extensions/extension_util/context_extensions.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import '../extensions/text_styles.dart';
import 'count_down_progress_indicator.dart';

class BMIComponent extends StatefulWidget {
  static String tag = '/BMIComponent';

  @override
  BMIComponentState createState() => BMIComponentState();
}

class BMIComponentState extends State<BMIComponent> with TickerProviderStateMixin {
  double? mKg;
  double? mCm;
  double? mBMI;

  late AnimationController controller;
  CountDownController mCountDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    convertLbsToKg();
    convertFeetToCm();

    double m = (mCm)! * 0.01;
    mBMI = mKg! / (m * m);

    super.initState();
  }

  //Convert lbs to kg
  void convertLbsToKg() {
    double a = double.parse(userStore.weight.validate()) * 2.2046;
    mKg = userStore.weightUnit == LBS ? a : double.parse(userStore.weight.validate());
  }

  // convert Feet to cm
  void convertFeetToCm() {
    mCm = userStore.heightUnit == FEET ? double.parse(userStore.height.validate()) * 30.48 : double.parse(userStore.height.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius(16), backgroundColor: context.cardColor) : boxDecorationRoundedWithShadow(16, backgroundColor: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: appStore.isDarkMode ? Colors.black : Colors.white),
                padding: EdgeInsets.all(6),
                child: Image.asset(ic_calories, width: 22, height: 22, color: primaryColor),
              ),
              Expanded(child: Text(languages.lblBmi,
                  style: boldTextStyle(size: 18, color: appStore.isDarkMode ? primaryColor : black),
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
            ],
          ),
          12.height,
          Stack(
            children: [
              Positioned(
                top: 32,
                left: 25,
                right: 25,
                child: Column(
                  children: [
                    Text(mBMI.toString().isEmptyOrNull ? "0" : mBMI!.toStringAsFixed(2).validate(), style: boldTextStyle(size: 22, height: 0)),
                    Text(languages.lblKcal, style: secondaryTextStyle()),
                  ],
                ).center(),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  value: mBMI.toString().isEmptyOrNull ? 0.0 : mBMI,
                ),
              ).center(),
            ],
          ),
          8.height,
        ],
      ),
    );
  }
}
