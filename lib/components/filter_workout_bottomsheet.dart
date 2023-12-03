import 'package:flutter/material.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/app_button.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../models/level_response.dart';
import '../models/workout_type_response.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';

class FilterWorkoutBottomSheet extends StatefulWidget {
  final int? listId;
  final int? workoutTypeId;

  final Function? onCall;

  final List<LevelModel>? mLevelList;
  final List<WorkoutTypeModel>? mWorkoutTypesList;

  const FilterWorkoutBottomSheet({super.key, this.listId, this.mLevelList, this.onCall, this.mWorkoutTypesList, this.workoutTypeId});

  @override
  State<FilterWorkoutBottomSheet> createState() => _FilterWorkoutBottomSheetState();
}

class _FilterWorkoutBottomSheetState extends State<FilterWorkoutBottomSheet> {
  List<int> mLevelIdList = [];
  List<int> mWorkoutIdList = [];

  bool isSelectedAll = false;

  @override
  Widget build(BuildContext context) {
    return widget.listId == 1
        ? SingleChildScrollView(
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(languages.lblTypes, style: boldTextStyle()).expand(),
                        isSelectedAll
                            ? Text(languages.lblClearAll, style: primaryTextStyle(color: primaryColor)).onTap(() {
                                setState(() {
                                  for (int i = 0; i < widget.mWorkoutTypesList!.length; i++) {
                                    widget.mWorkoutTypesList![i].select = false;
                                  }
                                  isSelectedAll = false;
                                  mWorkoutIdList.clear();
                                });
                              })
                            : Text(languages.lblSelectAll, style: primaryTextStyle(color: primaryColor)).onTap(() {
                                setState(() {
                                  for (int i = 0; i < widget.mWorkoutTypesList!.length; i++) {
                                    widget.mWorkoutTypesList![i].select = true;
                                    mWorkoutIdList.add(widget.mWorkoutTypesList![i].id.validate());
                                    isSelectedAll = true;
                                  }
                                });
                              })
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    AnimatedListView(
                      itemCount: widget.mWorkoutTypesList!.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (widget.mWorkoutTypesList![index].select == true) {
                          if (!mWorkoutIdList.contains(widget.mWorkoutTypesList![index].id.validate())) {
                            mWorkoutIdList.add(widget.mWorkoutTypesList![index].id.validate());
                          }
                        } else {
                          mWorkoutIdList.remove(widget.mWorkoutTypesList![index].id.validate());
                        }
                        return Row(
                          children: [
                            Text(widget.mWorkoutTypesList![index].title.validate(), style: primaryTextStyle()).expand(),
                            widget.mWorkoutTypesList![index].select == true ? Image.asset(ic_checkbox_fill, height: 20, width: 20) : Image.asset(ic_checkbox, height: 20, width: 20)
                          ],
                        ).paddingSymmetric(vertical: 8).onTap(() async {
                          setState(() {
                            widget.mWorkoutTypesList![index].select = !widget.mWorkoutTypesList![index].select.validate();
                          });
                        });
                      },
                    ),
                    AppButton(
                      text: languages.lblShowResult,
                      width: context.width(),
                      color: primaryColor,
                      onTap: () {
                        widget.onCall!.call(mWorkoutIdList);
                        print(mWorkoutIdList);
                        finish(context);
                      },
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                  ],
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.close, size: 24, color: primaryColor).onTap(() {
                          finish(context);
                        }),
                        16.width,
                        Text(languages.lblSelectLevels, style: boldTextStyle()).expand(),
                        Text(languages.lblClearAll, style: primaryTextStyle(color: primaryColor, size: 14)).onTap(() {
                          setState(() {
                            for (var element in widget.mLevelList!) {
                              if (element.select = false) {
                                element.select = true;
                              } else {
                                element.select = false;
                                mLevelIdList.remove(element.id.validate());
                              }
                            }
                          });
                        })
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    AnimatedListView(
                      itemCount: widget.mLevelList!.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (widget.mLevelList![index].select == true) {
                          if (!mLevelIdList.contains(widget.mLevelList![index].id.validate())) {
                            mLevelIdList.add(widget.mLevelList![index].id.validate());
                          }
                        } else {
                          mLevelIdList.remove(widget.mLevelList![index].id.validate());
                        }
                        return Row(
                          children: [
                            Text(widget.mLevelList![index].title.validate(), style: primaryTextStyle()).expand(),
                            widget.mLevelList![index].select == true ? Image.asset(ic_checkbox_fill, height: 20, width: 20) : Image.asset(ic_checkbox, height: 20, width: 20),
                          ],
                        ).paddingSymmetric(vertical: 8).onTap(() async {
                          setState(() {
                            widget.mLevelList![index].select = !widget.mLevelList![index].select.validate();
                          });
                        });
                      },
                    ),
                    AppButton(
                      text: languages.lblShowResult,
                      width: context.width(),
                      color: primaryColor,
                      onTap: () {
                        widget.onCall!.call(mLevelIdList);
                        finish(context);
                      },
                    ).paddingAll(16),
                  ],
                ),
              ],
            ),
          );
  }
}
