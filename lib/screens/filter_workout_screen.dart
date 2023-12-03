import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../screens/no_data_screen.dart';
import '../screens/subscribe_screen.dart';
import '../screens/workout_detail_screen.dart';
import '../components/filter_workout_bottomsheet.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/loader_widget.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/level_response.dart';
import '../models/workout_detail_response.dart';
import '../models/workout_type_response.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';

class FilterWorkoutScreen extends StatefulWidget {
  final int? id;

  const FilterWorkoutScreen({super.key, this.id});

  @override
  State<FilterWorkoutScreen> createState() => _FilterWorkoutScreenState();
}

class _FilterWorkoutScreenState extends State<FilterWorkoutScreen> {
  ScrollController scrollController = ScrollController();

  List<WorkoutFilterList> list = [];
  List<WorkoutDetailModel> mWorkoutList = [];
  List<LevelModel> mLevelList = [];
  List<WorkoutTypeModel> mWorkoutTypeList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    getList();
    getWorkoutData();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          getWorkoutData();
        }
      }
    });
  }

  Future<void> setWorkout(int? id, int? isFavourite) async {
    appStore.setLoading(true);
    Map req = {"workout_id": id};
    await setWorkoutFavApi(req).then((value) async {
      toast(value.message);
      appStore.setLoading(false);
      if (isFavourite == 1) {
        isFavourite = 0;
      } else {
        isFavourite = 1;
      }

      appStore.setLoading(false);
      await getWorkoutFilterListApi(id: widget.id.validate()).then((value) {
        numPage = value.pagination!.totalPages;
        isLastPage = false;
        if (page == 1) {
          mWorkoutList.clear();
        }
        print(value);
        Iterable it = value.data!;
        it.map((e) => mWorkoutList.add(e)).toList();
        setState(() {});
      }).catchError((e) {
        isLastPage = true;
        appStore.setLoading(false);
        setState(() {});
      });
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getWorkoutData({bool? isFilter, bool? isLevel = false, bool? isTypes = false, var ids}) async {
    appStore.setLoading(true);
    await getWorkoutFilterListApi(page: page,id: widget.id.validate(), isFilter: isFilter, isLevel: isLevel, isType: isTypes, ids: ids).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mWorkoutList.clear();
      }
      print(value);
      Iterable it = value.data!;
      it.map((e) => mWorkoutList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    }).whenComplete(() {
      if (isFilter == true) {
        appStore.setLoading(false);
      } else {
        getWorkoutTypeData();
      }
    });
  }

  Future<void> getWorkoutTypeData() async {
    await getWorkoutTypeListApi(mPerPage: 100).then((value) {
      Iterable it = value.data!;
      it.map((e) => mWorkoutTypeList.add(e)).toList();
    }).catchError((e) {
      appStore.setLoading(false);
    }).whenComplete(() {
      getLevelData();
    });
  }

  Future<void> getLevelData() async {
    await getLevelListApi(mPerPage: 100).then((value) {
      Iterable it = value.data!;
      it.map((e) => mLevelList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = context.width();
    var height = 185.0;

    return Scaffold(
        appBar: appBarWidget(languages.lblWorkouts, elevation: 0, context: context),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontalList(
                      itemCount: list.length,
                      padding: EdgeInsets.only(left: 16, right: 8),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: list[index].select! ? primaryColor : context.scaffoldBackgroundColor, borderRadius: radius(24), border: Border.all(color: list[index].select! ? primaryColor : Colors.grey)),
                          child: Text(list[index].title.toString(), style: secondaryTextStyle(color: list[index].select! ? Colors.white : Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ).onTap(() async {
                          setState(() {
                            for (int i = 0; i < list.length; i++) {
                              list[i].select = i == index;
                            }
                          });
                          if (list[index].id == 0) {
                            getWorkoutData(isFilter: true);
                          } else {
                            await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                useSafeArea: true,
                                backgroundColor: appStore.isDarkMode ? cardDarkColor : context.cardColor,
                                shape: RoundedRectangleBorder(borderRadius: radiusOnly(topRight: 18, topLeft: 18)),
                                builder: (BuildContext context) {
                                  return FilterWorkoutBottomSheet(
                                      listId: list[index].id,
                                      mLevelList: mLevelList,
                                      mWorkoutTypesList: mWorkoutTypeList,
                                      onCall: (List<int> mList) {
                                        getWorkoutData(
                                            isFilter: true,
                                            ids: mList.toString().removeAllWhiteSpace().replaceAll("[", "").replaceAll("]", "").trim(),
                                            isTypes: list[index].id == 1 ? true : false,
                                            isLevel: list[index].id == 2 ? true : false);
                                        print(mList);
                                      });
                                });
                          }
                        });
                      }),
                  16.height,
                  mWorkoutList.isNotEmpty
                      ? AnimatedListView(
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: mWorkoutList.length,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemBuilder: (context, int i) {
                            return InkWell(
                              onTap: () {
                                mWorkoutList[i].isPremium == 1
                                    ? userStore.isSubscribe == 0
                                        ? SubscribeScreen().launch(context)
                                        : WorkoutDetailScreen(id: mWorkoutList[i].id,mWorkoutModel:mWorkoutList[i] ,).launch(context)
                                    : WorkoutDetailScreen(id: mWorkoutList[i].id,mWorkoutModel: mWorkoutList[i],).launch(context);
                              },
                              child: Stack(
                                children: [
                                  cachedImage(mWorkoutList[i].workoutImage.validate(), height: height, fit: BoxFit.cover, width: width).cornerRadiusWithClipRRect(16),
                                  mBlackEffect(width, height, radiusValue: 16),
                                  Positioned(
                                    left: 16,
                                    top: 8,
                                    right: 12,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        mWorkoutList[i].isPremium == 1
                                            ? Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radius(4)),
                                                child: Text(
                                                  languages.lblPro,
                                                  style: primaryTextStyle(color: Colors.white, size: 12),
                                                ),
                                              )
                                            : SizedBox(),
                                        Container(
                                                decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.white.withOpacity(0.5), boxShape: BoxShape.circle),
                                                padding: EdgeInsets.all(5),
                                                child: Image.asset(
                                                  mWorkoutList[i].isFavourite == 1 ? ic_favorite_fill : ic_favorite,
                                                  color: mWorkoutList[i].isFavourite == 1 ? primaryColor : white,
                                                  width: 20,
                                                  height: 20,
                                                ).center())
                                            .onTap(() {
                                          setState(() {});
                                          setWorkout(mWorkoutList[i].id.validate(), mWorkoutList[i].isFavourite);
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
                                        Text(mWorkoutList[i].title.capitalizeFirstLetter().validate(), style: boldTextStyle(color: white)),
                                        2.height,
                                        Row(
                                          children: [
                                            Container(margin: EdgeInsets.only(right: 6), height: 6, width: 6, decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: white)),
                                            Text('${mWorkoutList[i].workoutTypeTitle.validate()}', style: secondaryTextStyle(color: white)),
                                            8.width,
                                            Container(height: 14, width: 2, color: primaryColor),
                                            8.width,
                                            Text(mWorkoutList[i].levelTitle.validate(), style: secondaryTextStyle(color: white)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ).paddingBottom(16),
                            );
                          },
                        )
                      : SizedBox(
                          height: context.height() * 0.6,
                          child: NoDataScreen(mTitle: languages.lblWorkoutNoFound).center().visible(!appStore.isLoading),
                        )
                ],
              ),
            ),
            Observer(builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            })
          ],
        ));
  }

  getList() {
    list.add(WorkoutFilterList(0, languages.lblAll, true));
    list.add(WorkoutFilterList(1, languages.lblWorkoutType, false));
    list.add(WorkoutFilterList(2, languages.lblWorkoutLevel, false));
  }
}

class WorkoutFilterList {
  int? id;
  String? title;
  bool? select;

  WorkoutFilterList(this.id, this.title, this.select);
}
