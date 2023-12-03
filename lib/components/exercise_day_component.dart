import 'package:flutter/material.dart';
import '../main.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../models/day_exercise_response.dart';
import '../screens/exercise_detail_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_common.dart';

class ExerciseDayComponent extends StatefulWidget {
  static String tag = '/ExerciseDayComponent';
  final DayExerciseModel? mDayExerciseModel;
  final List<String>? mSets;

  ExerciseDayComponent({this.mDayExerciseModel, this.mSets});

  @override
  ExerciseDayComponentState createState() => ExerciseDayComponentState();
}

class ExerciseDayComponentState extends State<ExerciseDayComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius(12)) : boxDecorationRoundedWithShadow(12),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(
                widget.mDayExerciseModel!.exerciseImage.validate(),
                width: 55,
                height: 55,
                fit: BoxFit.fill,
              ).cornerRadiusWithClipRRect(10),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  6.height,
                  Text(widget.mDayExerciseModel!.exerciseTitle.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  6.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.mDayExerciseModel!.exercise!.type == DURATION) Text(widget.mDayExerciseModel!.exercise!.duration.toString() + " " + languages.lblDuration, style: secondaryTextStyle(size: 12)),
                      if (widget.mDayExerciseModel!.exercise!.type == SETS) Text(widget.mSets!.join(" ").toString(), style: secondaryTextStyle(size: 12)),
                      if (widget.mDayExerciseModel!.exercise!.isPremium == 1)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radius(6)),
                          child: Text(languages.lblPro, style: primaryTextStyle(color: Colors.white, size: 12)),
                        )
                    ],
                  ),
                ],
              ).expand()
            ],
          ).expand(),
        ],
      ),
    ).onTap(() {
      ExerciseDetailScreen(mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(), mExerciseId: widget.mDayExerciseModel!.exerciseId.validate()).launch(context);
    });
  }
}
