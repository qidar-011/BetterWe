import 'package:flutter/material.dart';
import '../main.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../models/exercise_response.dart';
import '../screens/exercise_detail_screen.dart';
import '../screens/subscribe_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_common.dart';

class ExerciseComponent extends StatefulWidget {
  final ExerciseModel? mExerciseModel;
  final Function? onCall;

  ExerciseComponent({this.mExerciseModel, this.onCall});

  @override
  _ExerciseComponentState createState() => _ExerciseComponentState();
}

class _ExerciseComponentState extends State<ExerciseComponent> {
  List<String>? mSets = [];

  @override
  void initState() {
    if (widget.mExerciseModel!.type == SETS) {
      if (widget.mExerciseModel!.sets != null) {
        widget.mExerciseModel!.sets!.forEach((element) {
          if (widget.mExerciseModel!.based.toString() == TIME) {
            mSets!.add(element.time.toString() + "s");
          } else {
            mSets!.add(element.reps.toString() + "x");
          }
          setState(() {});
        });
      }
    }
    super.initState();
  }

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
                widget.mExerciseModel!.exerciseImage.validate(),
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(10),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  6.height,
                  Text(widget.mExerciseModel!.title.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  6.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.mExerciseModel!.type == DURATION) Text(widget.mExerciseModel!.duration.validate() + " " + languages.lblDuration, style: secondaryTextStyle(size: 12)),
                      if (widget.mExerciseModel!.type == SETS) Text(mSets!.join(" ").toString(), style: secondaryTextStyle(size: 12)),
                      if (widget.mExerciseModel!.isPremium == 1)
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
      widget.mExerciseModel!.isPremium == 1
          ? userStore.isSubscribe == 0
              ? SubscribeScreen().launch(context)
              : ExerciseDetailScreen(mExerciseName: widget.mExerciseModel!.title.validate(), mExerciseId: widget.mExerciseModel!.id.validate()).launch(context)
          : ExerciseDetailScreen(mExerciseName: widget.mExerciseModel!.title.validate(), mExerciseId: widget.mExerciseModel!.id.validate()).launch(context);
    });
  }
}
