import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/widgets.dart';
import '../../extensions/colors.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../network/rest_api.dart';
import '../../utils/app_images.dart';
import '../components/exercise_day_component.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/constants.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/day_exercise_response.dart';
import '../models/workout_detail_response.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int? id;

  final WorkoutDetailModel? mWorkoutModel;

  WorkoutDetailScreen({this.id, this.mWorkoutModel});

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  ScrollController scrollController = ScrollController();
  int page = 1;
  int? numPage;
  int currentTabIndex = 0;
  int? mWorkoutId;

  bool isLastPage = false;
  bool isLoading = false;

  List<DayExerciseModel> mDayExerciseList = [];
  List<Workoutday> mWorkoutDayList = [];
  List<Widget> tabs = [];

  WorkoutDetailModel? mWorkoutDetailModel;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (showAdOnWorkoutDetail) loadInterstitialAds();
    appStore.setLoading(true);
    await getWorkoutDetailApi(widget.id.validate()).then((value) {
      mWorkoutDetailModel = value.data;
      tabs.clear();
      for (int i = 0; i < value.workoutday!.length; i++) {
        ///TODO
        tabs.add(Text("Day ${i + 1}"));
      }
      mWorkoutDayList = value.workoutday!;
      getDayExerciseData(value.workoutday!.first.id.validate());
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          getDayExerciseData(mWorkoutId);
        }
      }
    });
  }

  @override
  void dispose() {
    if (showAdOnWorkoutDetail) showInterstitialAds();
    super.dispose();
  }

  Future<void> getDayExerciseData(int? id) async {
    await getDayExerciseApi(id).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mDayExerciseList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mDayExerciseList.add(e)).toList();
      appStore.setLoading(false);
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      isLoading = false;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Widget mData(String? img, String? mTitle, String? mValue) {
    return Column(
      children: [
        Image.asset(img.toString(), width: 24, height: 24, color: primaryColor),
        4.height,
        Text(mTitle.validate(), style: boldTextStyle()),
        4.height,
        Text(mValue.validate(), style: secondaryTextStyle()),
      ],
    );
  }

  Future<void> setWorkout(int? id) async {
    appStore.setLoading(true);
    Map req = {"workout_id": id};
    await setWorkoutFavApi(req).then((value) {
      toast(value.message);
      appStore.setLoading(false);
      if (mWorkoutDetailModel!.isFavourite == 1) {
        mWorkoutDetailModel!.isFavourite = 0;
      } else {
        mWorkoutDetailModel!.isFavourite = 1;
      }
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
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
            if (widget.mWorkoutModel != null)
              DefaultTabController(
                length: mWorkoutDayList.isEmpty ? 0 : mWorkoutDayList.length,
                initialIndex: currentTabIndex,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              cachedImage(widget.mWorkoutModel!.workoutImage.validate(), width: context.width(), height: context.height() * 0.39, fit: BoxFit.cover),
                              mBlackEffect(context.width(), context.height() * 0.39, radiusValue: 0),
                            ],
                          ),
                          Positioned(
                              top: context.statusBarHeight,
                              left: appStore.selectedLanguageCode == 'ar' ? 8 : 0,
                              child: Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      finish(context);
                                    },
                                    icon: Icon(appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left, color: whiteColor),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 12, top: 16),
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radius(6)),
                                    child: Text(languages.lblPro, style: secondaryTextStyle(color: white)),
                                  ).visible(widget.mWorkoutModel!.isPremium == 1)
                                ],
                              )),
                          if (mWorkoutDetailModel != null)
                            Positioned(
                              right: 16,
                              top: context.statusBarHeight + 8,
                              child: InkWell(
                                onTap: () {
                                  setWorkout(mWorkoutDetailModel!.id.validate());
                                },
                                child: Container(
                                  decoration: boxDecorationWithRoundedCorners(backgroundColor: favBackground, boxShape: BoxShape.circle),
                                  padding: EdgeInsets.all(5),
                                  child: Image.asset(mWorkoutDetailModel!.isFavourite == 1 ? ic_favorite_fill : ic_favorite, color: mWorkoutDetailModel!.isFavourite == 1 ? primaryColor : white, width: 20, height: 20)
                                      .center(),
                                ),
                              ),
                            ),
                          Positioned(left: 16, bottom: 42, child: Text(widget.mWorkoutModel!.title.capitalizeFirstLetter().toString(), style: boldTextStyle(size: 20, color: Colors.white)))
                        ],
                      ),
                    ),
                    DraggableScrollableSheet(
                      initialChildSize: 0.65,
                      minChildSize: 0.65,
                      maxChildSize: 0.9,
                      builder: (context, controller) => Container(
                        width: context.width(),
                        decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: 20.0, topRight: 20.0), backgroundColor: context.scaffoldBackgroundColor),
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  mData(ic_dumbbell, widget.mWorkoutModel!.workoutTypeTitle.validate(), languages.lblWorkoutType),
                                  mData(ic_level, widget.mWorkoutModel!.levelTitle.validate(), languages.lblLevel),
                                ],
                              ).paddingSymmetric(horizontal: 32),
                              10.height,
                              Divider(indent: 16, endIndent: 16),
                              10.height,
                              if (!appStore.isLoading)
                                Column(
                                  children: [
                                    Container(
                                      child: htmlWidget(context, mWorkoutDetailModel!.description.validate(), textSecondaryColorGlobal, secondaryTextStyle()),
                                    ).paddingSymmetric(horizontal: 16).visible(!mWorkoutDetailModel!.description.isEmptyOrNull),
                                    20.height,
                                    TabBar(
                                      indicatorColor: primaryColor,
                                      unselectedLabelStyle: primaryTextStyle(),
                                      labelStyle: boldTextStyle(),
                                      labelColor: primaryColor,
                                      labelPadding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                                      unselectedLabelColor: appStore.isDarkMode ? Colors.white : textSecondaryColorGlobal,
                                      isScrollable: true,
                                      tabs: tabs,
                                      onTap: (index) {
                                        currentTabIndex = index;
                                        mWorkoutId = mWorkoutDetailModel!.id;
                                        isLoading = true;
                                        getDayExerciseData(mWorkoutDayList[index].id);
                                        setState(() {});
                                      },
                                    ),
                                    Divider(height: 0, indent: 16),
                                    Stack(
                                      children: [
                                        mDayExerciseList.isNotEmpty
                                            ? AnimatedListView(
                                                controller: scrollController,
                                                itemCount: mDayExerciseList.length,
                                                physics: NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  List<String>? mSets = [];
                                                  if (mDayExerciseList[index].exercise!.type == "sets") {
                                                    if (mDayExerciseList[index].exercise!.sets!.isNotEmpty) {
                                                      mDayExerciseList[index].exercise!.sets!.forEach((element) {
                                                        if (mDayExerciseList[index].exercise!.based.toString() == "time") {
                                                          mSets.add(element.time.toString() + "s");
                                                        } else {
                                                          mSets.add(element.reps.toString() + "x");
                                                        }
                                                      });
                                                    }
                                                  }
                                                  return ExerciseDayComponent(mDayExerciseModel: mDayExerciseList[index], mSets: mSets);
                                                },
                                              )
                                            : Text(mWorkoutDayList[currentTabIndex].isRest == 1 ? languages.lblBreak : languages.lblNoFoundData, style: secondaryTextStyle())
                                                .center()
                                                .paddingOnly(top: 50)
                                                .visible(!isLoading == true),
                                        Loader().center().paddingOnly(top: 50).visible(isLoading == true).center()
                                      ],
                                    ),
                                  ],
                                )
                            ],
                          ).paddingOnly(bottom: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Loader().center().visible(appStore.isLoading)
          ],
        ),
      ),
    );
  }
}
