import 'package:flutter/material.dart';
import '../utils/app_images.dart';
import '../../extensions/colors.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../utils/app_colors.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/workout_detail_response.dart';
import '../network/rest_api.dart';
import '../screens/subscribe_screen.dart';
import '../screens/workout_detail_screen.dart';
import '../utils/app_common.dart';

class WorkoutComponent extends StatefulWidget {
  final WorkoutDetailModel? mWorkoutModel;
  final Function? onCall;
  final bool isView;

  WorkoutComponent({this.mWorkoutModel, this.onCall, this.isView = false});

  @override
  _WorkoutComponentState createState() => _WorkoutComponentState();
}

class _WorkoutComponentState extends State<WorkoutComponent> {
  Future<void> setWorkout(int? id) async {
    appStore.setLoading(true);
    Map req = {"workout_id": id};
    await setWorkoutFavApi(req).then((value) {
      toast(value.message);
      appStore.setLoading(false);
      if (widget.mWorkoutModel!.isFavourite == 1) {
        widget.mWorkoutModel!.isFavourite = 0;
      } else {
        widget.mWorkoutModel!.isFavourite = 1;
      }
      appStore.setLoading(false);
      widget.onCall!.call();
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = widget.isView == true ? context.width() : context.width() * 0.72;
    var height = 190.0;
    return Stack(
      children: [
        cachedImage(widget.mWorkoutModel!.workoutImage.validate(), height: height, fit: BoxFit.cover, width: width).cornerRadiusWithClipRRect(16),
        mBlackEffect(width, height, radiusValue: 16),
        Positioned(
          left: 16,
          top: 8,
          right: 12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.mWorkoutModel!.isPremium == 1
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radius(4)),
                      child: Text(languages.lblPro, style: primaryTextStyle(color: Colors.white, size: 12)),
                    )
                  : SizedBox(),
              Container(
                decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.white.withOpacity(0.5), boxShape: BoxShape.circle),
                padding: EdgeInsets.all(5),
                child: Image.asset(widget.mWorkoutModel!.isFavourite == 1 ? ic_favorite_fill : ic_favorite, color: widget.mWorkoutModel!.isFavourite == 1 ? primaryColor : white, width: 20, height: 20).center(),
              ).onTap(() {
                setState(() {});
                setWorkout(widget.mWorkoutModel!.id.validate());
              }),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.mWorkoutModel!.title.capitalizeFirstLetter().validate(), style: boldTextStyle(color: white)),
              4.height,
              Row(
                children: [
                  Container(margin: EdgeInsets.only(right: 6), height: 4, width: 4, decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: white)),
                  Text('${widget.mWorkoutModel!.workoutTypeTitle.validate()}', style: secondaryTextStyle(color: white)),
                  8.width,
                  Container(height: 14, width: 2, color: primaryColor),
                  8.width,
                  Text(widget.mWorkoutModel!.levelTitle.validate(), style: secondaryTextStyle(color: white)),
                ],
              ),
            ],
          ),
        )
      ],
    ).onTap(() {
      widget.mWorkoutModel!.isPremium == 1
          ? userStore.isSubscribe == 0
              ? SubscribeScreen().launch(context)
              : WorkoutDetailScreen(id: widget.mWorkoutModel!.id, mWorkoutModel: widget.mWorkoutModel!).launch(context).then((value) {
                  widget.onCall!();
                })
          : WorkoutDetailScreen(id: widget.mWorkoutModel!.id,mWorkoutModel: widget.mWorkoutModel!).launch(context).then((value) {
              widget.onCall!();
            });
    }).paddingBottom(widget.isView == true ? 16 : 0);
  }
}
