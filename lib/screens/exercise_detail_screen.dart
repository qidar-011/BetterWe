import 'dart:ui';
import 'package:flutter/material.dart';
import '../extensions/horizontal_list.dart';
import '../main.dart';
import '../screens/tips_screen.dart';
import '../utils/app_colors.dart';
import '../../extensions/app_button.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../models/exercise_detail_response.dart';
import '../network/rest_api.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/app_images.dart';
import '../utils/app_constants.dart';
import 'chewie_screen.dart';
import 'exercise_duration_screen.dart';
import 'exercise_duration_screen1.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int? mExerciseId;
  final String? mExerciseName;

  ExerciseDetailScreen({this.mExerciseId, this.mExerciseName});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  ExerciseDetailResponse? mExerciseModel;
  ScrollController mScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (showAdOnExerciseDetail) loadInterstitialAds();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget logSetWidget(String text, String subText) {
    return RichText(
      text: TextSpan(
        text: text,
        style: boldTextStyle(size: 20),
        children: [
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(subText, style: secondaryTextStyle()),
            ),
          )
        ],
      ),
    );
  }

  Widget getHeading(String title) {
    return Row(children: [
      Image.asset(ic_level, height: 18, width: 18),
      10.width,
      Text(title, style: primaryTextStyle()),
    ]).paddingSymmetric(horizontal: 16);
  }

  Widget dividerHorizontalLine({bool? isSmall = false}) {
    return Container(
      height: isSmall == true ? 40 : 65,
      width: 4,
      color: context.scaffoldBackgroundColor,
    );
  }

  Widget mSetText(String value, {String? value2}) {
    return value2.isEmptyOrNull
        ? Text(value, style: boldTextStyle()).center()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: boldTextStyle()),
              2.height,
              Text("- " + value2.validate() + languages.lblKg, style: primaryTextStyle(size: 14)),
            ],
          ).expand();
  }

  Widget mSets1() {
    if (mExerciseModel!.data!.sets!.length == 1) {
      return mSetText(mExerciseModel!.data!.based == "reps" ? mExerciseModel!.data!.sets!.first.reps.toString() + "x" : mExerciseModel!.data!.sets!.first.time.toString() + "s",
          value2: mExerciseModel!.data!.sets!.first.weight.toString());
    } else if (mExerciseModel!.data!.sets!.length == 2) {
      return Row(children: [
        mSetText(mExerciseModel!.data!.based == "reps" ? mExerciseModel!.data!.sets!.first.reps.toString() + "x" : mExerciseModel!.data!.sets!.first.time.toString() + "s",
            value2: mExerciseModel!.data!.sets!.first.weight.toString()),
        dividerHorizontalLine(),
        mSetText(mExerciseModel!.data!.based == "reps" ? mExerciseModel!.data!.sets![1].reps.toString() + "x" : mExerciseModel!.data!.sets![1].time.toString() + "s",
            value2: mExerciseModel!.data!.sets![1].weight.toString()),
      ]);
    } else if (mExerciseModel!.data!.sets!.length == 3) {
      return Row(children: [
        mSetText(mExerciseModel!.data!.based == "reps" ? mExerciseModel!.data!.sets![0].reps.toString() + "x" : mExerciseModel!.data!.sets![0].time.toString() + "s",
            value2: mExerciseModel!.data!.sets![0].weight.toString()),
        dividerHorizontalLine(),
        mSetText(mExerciseModel!.data!.based == "reps" ? mExerciseModel!.data!.sets![1].reps.toString() + "x" : mExerciseModel!.data!.sets![1].time.toString() + "s",
            value2: mExerciseModel!.data!.sets![1].weight.toString()),
        dividerHorizontalLine(),
        mSetText(mExerciseModel!.data!.based == "reps" ? mExerciseModel!.data!.sets![2].reps.toString() + "x" : mExerciseModel!.data!.sets![2].time.toString() + "s",
            value2: mExerciseModel!.data!.sets![2].weight.toString()),
      ]);
    } else {
      return HorizontalList(
        itemCount: mExerciseModel!.data!.sets!.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              16.width,
              mSetText(mExerciseModel!.data!.based == "reps" ? mExerciseModel!.data!.sets![index].reps.toString() + "x" : mExerciseModel!.data!.sets![index].time.toString() + "s",
                  value2: mExerciseModel!.data!.sets![index].weight.toString()),
              16.width,
              dividerHorizontalLine(),
              16.width,
            ],
          );
        },
      );
    }
  }

  Widget mSets2() {
    if (mExerciseModel!.data!.sets!.length == 1) {
      return mSetText(mExerciseModel!.data!.sets!.first.rest.toString() + "s");
    } else if (mExerciseModel!.data!.sets!.length == 2) {
      return Row(children: [
        mSetText(mExerciseModel!.data!.sets![0].rest.toString() + "s").expand(),
        dividerHorizontalLine(isSmall: true),
        mSetText(mExerciseModel!.data!.sets![1].rest.toString() + "s").expand(),
      ]);
    } else if (mExerciseModel!.data!.sets!.length == 3) {
      return Row(children: [
        mSetText(mExerciseModel!.data!.sets![0].rest.toString() + "s").expand(),
        dividerHorizontalLine(isSmall: true),
        mSetText(mExerciseModel!.data!.sets![1].rest.toString() + "s").expand(),
        dividerHorizontalLine(isSmall: true),
        mSetText(mExerciseModel!.data!.sets![2].rest.toString() + "s").expand(),
      ]);
    } else {
      return HorizontalList(
        itemCount: mExerciseModel!.data!.sets!.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              16.width,
              mSetText(mExerciseModel!.data!.sets![index].rest.toString() + "s"),
              16.width,
              dividerHorizontalLine(isSmall: true),
              16.width,
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    if (showAdOnExerciseDetail) showInterstitialAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.mExerciseName.validate(), context: context, actions: [
        Image.asset(ic_menu, height: 24, width: 24, color: primaryColor).paddingRight(8).onTap(() {
          TipsScreen(
                  mExerciseVideo: mExerciseModel!.data!.videoUrl.validate(),
                  mTips: mExerciseModel!.data!.tips.validate(),
                  mExerciseImage: mExerciseModel!.data!.exerciseImage.validate(),
                  mExerciseInstruction: mExerciseModel!.data!.instruction)
              .launch(context);
        })
      ]),
      bottomNavigationBar: AppButton(
        color: primaryColor,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        width: context.width(),
        onTap: () {
          if (mExerciseModel!.data!.type == "duration") {
            ExerciseDurationScreen(mExerciseModel).launch(context);
          } else {
            ExerciseDurationScreen1(mExerciseModel).launch(context);
          }
        },
        text: languages.lblStartExercise,
      ),
      body: FutureBuilder(
        future: geExerciseDetailApi(widget.mExerciseId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            mExerciseModel = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ChewieScreen(mExerciseModel!.data!.videoUrl.validate(), mExerciseModel!.data!.exerciseImage.validate()).center(),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: mExerciseModel!.data!.isPremium == 1
                            ? Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(6), backgroundColor: primaryColor, border: Border.all(color: primaryColor)),
                                child: Text(languages.lblPro, style: primaryTextStyle(color: white, size: 12)),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                  16.height,
                  getHeading(mExerciseModel!.data!.levelTitle.validate()).visible(!mExerciseModel!.data!.levelTitle.isEmptyOrNull),
                  12.height,
                  if (mExerciseModel!.data!.type == SETS)
                    Container(
                      width: context.width(),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? cardDarkColor : GreyLightColor.withOpacity(0.3)),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: mSets1(),
                    ),
                  4.height,
                  if (mExerciseModel!.data!.type == SETS)
                    Container(
                      width: context.width(),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? cardDarkColor : GreyLightColor.withOpacity(0.3)),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: mSets2(),
                    ),
                  if (mExerciseModel!.data!.type == DURATION)
                    Container(
                      width: context.width(),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? cardDarkColor : GreyLightColor.withOpacity(0.3)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mExerciseModel!.data!.duration.validate(), style: boldTextStyle()),
                          2.height,
                          Text(languages.lblDuration, style: primaryTextStyle()),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 16),
                  16.height,
                  Divider(endIndent: 16, indent: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Text(languages.lblBodyParts, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16),
                      8.height,
                      HorizontalList(
                        physics: BouncingScrollPhysics(),
                        controller: mScrollController,
                        itemCount: mExerciseModel!.data!.bodypartName!.length,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        spacing: 16,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: context.width() * 0.18,
                            child: Column(
                              children: [
                                cachedImage(
                                  mExerciseModel!.data!.bodypartName![index].bodypartImage.validate(),
                                  fit: BoxFit.fill,
                                  height: 65,
                                  width: context.width() * 0.18,
                                ).cornerRadiusWithClipRRect(150),
                                6.height,
                                Text(mExerciseModel!.data!.bodypartName![index].title.validate(), style: primaryTextStyle(size: 14), textAlign: TextAlign.center, maxLines: 2),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(endIndent: 16, indent: 16),
                    ],
                  ).visible(mExerciseModel!.data!.bodypartName!.isNotEmpty),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Text(languages.lblEquipments, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16),
                      16.height,
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          cachedImage(mExerciseModel!.data!.equipmentImg.validate(), height: 145, width: context.width() * 0.32, fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
                          ClipRRect(
                            borderRadius: radius(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: context.width() * 0.32,
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), backgroundColor: Colors.grey.shade100.withOpacity(0.5)),
                                child: Text(mExerciseModel!.data!.equipmentTitle.validate(), style: primaryTextStyle(size: 12, color: Colors.black)).center(),
                              ),
                            ),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      30.height,
                    ],
                  ).visible(!mExerciseModel!.data!.equipmentTitle.isEmptyOrNull),
                ],
              ),
            );
          }
          return snapWidgetHelper(snapshot);
        },
      ),
    );
  }
}
