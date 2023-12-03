import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_fitness/extensions/loader_widget.dart';
import '../../components/level_component.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/widgets.dart';
import '../../main.dart';
import '../../screens/view_body_part_screen.dart';
import '../../screens/view_equipment_screen.dart';
import '../../screens/view_level_screen.dart';
import '../../utils/app_colors.dart';
import '../components/body_part_component.dart';
import '../components/equipment_component.dart';
import '../components/workout_component.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/text_styles.dart';
import '../models/dashboard_response.dart';
import '../network/rest_api.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/search_screen.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';
import 'filter_workout_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController mScrollController = ScrollController();
  TextEditingController mSearchCont = TextEditingController();

  String? mSearchValue = "";
  bool _showClearButton = false;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mHeading(String? title, {bool? isSeeAll = false, Function? onCall}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
        IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Feather.chevron_right, color: primaryColor),
            onPressed: () {
              onCall!.call();
            }).paddingRight(2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appStore.selectedLanguageCode == 'ar' ? .11*context.height() : 70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Observer(builder: (context) {
                  return Container(
                          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(color: primaryColor, width: 1)),
                          child: cachedImage(userStore.profileImage.validate(), width: 42, height: 42, fit: BoxFit.cover).cornerRadiusWithClipRRect(100).paddingAll(1))
                      .onTap(() {
                    EditProfileScreen().launch(context);
                  });
                }),
                10.width,

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(languages.lblHey + userStore.displayName.validate().capitalizeFirstLetter() + "👋", style: boldTextStyle(size: 18), overflow: TextOverflow.ellipsis, maxLines: 2),
                    appStore.selectedLanguageCode == 'ar ' ? 0.height : 2.height,

                    Text(languages.lblHomeWelMsg, style: secondaryTextStyle()),
                  ],
                ).expand(),
              ],
            ).expand(),
            Container(
              decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(16),
                  border: Border.all(color: appStore.isDarkMode ? Colors.white : context.dividerColor.withOpacity(0.9), width: 0.6),
                  backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Image.asset(ic_notification, width: 24, height: 24, color: appStore.isDarkMode ? Colors.white : Colors.grey),
            ).onTap(
              () {
                NotificationScreen().launch(context);
              },
            )
          ],
        ).paddingOnly(top: context.statusBarHeight + 16, left: 16, right: 16, bottom: 8),
      ),
      body: RefreshIndicator(
        backgroundColor: context.scaffoldBackgroundColor,
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
            () {
              setState(() {});
            },
          );
        },
        child: FutureBuilder(
          future: getDashboardApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DashboardResponse? mDashboardResponse = snapshot.data;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    AppTextField(
                      controller: mSearchCont,
                      textFieldType: TextFieldType.OTHER,
                      isValidationRequired: false,
                      autoFocus: false,
                      suffix: _getClearButton(),
                      decoration: defaultInputDecoration(context, label: languages.lblSearch, isFocusTExtField: true),
                      onTap: () {
                        hideKeyboard(context);
                        SearchScreen().launch(context);
                      },
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mHeading(languages.lblBodyPartExercise, onCall: () {
                          ViewBodyPartScreen().launch(context);
                        }),

                        HorizontalList(
                          physics: BouncingScrollPhysics(),
                          controller: mScrollController,
                          itemCount: mDashboardResponse!.bodypart!.length,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          spacing: 16,
                          itemBuilder: (context, index) {
                            return BodyPartComponent(bodyPartModel: mDashboardResponse.bodypart![index]);
                          },
                        ),
                      ],
                    ).visible(mDashboardResponse.bodypart!.isNotEmpty),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,
                        mHeading(languages.lblEquipmentsExercise, onCall: () {
                          ViewEquipmentScreen().launch(context);
                        }),
                        HorizontalList(
                          physics: BouncingScrollPhysics(),
                          itemCount: mDashboardResponse.equipment!.length,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          spacing: 16,
                          itemBuilder: (context, index) {
                            return EquipmentComponent(mEquipmentModel: mDashboardResponse.equipment![index]);
                          },
                        ),
                      ],
                    ).visible(mDashboardResponse.equipment!.isNotEmpty),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,
                        mHeading(languages.lblWorkouts, onCall: () {
                          FilterWorkoutScreen().launch(context).then((value) {
                            setState(() {});
                          });
                        }),
                        HorizontalList(
                          physics: BouncingScrollPhysics(),
                          itemCount: mDashboardResponse.workout!.length,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          spacing: 16,
                          itemBuilder: (context, index) {
                            return WorkoutComponent(
                              mWorkoutModel: mDashboardResponse.workout![index],
                              onCall: () {
                                appStore.setLoading(true);
                                setState(() {});
                                appStore.setLoading(false);
                              },
                            );
                          },
                        ),
                      ],
                    ).visible(mDashboardResponse.workout!.isNotEmpty),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,
                        mHeading(languages.lblLevels, onCall: () {
                          ViewLevelScreen().launch(context);
                        }),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: mDashboardResponse.level!.length,
                          itemBuilder: (context, index) {
                            return LevelComponent(mLevelModel: mDashboardResponse.level![index]);
                          },
                        ),
                        16.height,
                      ],
                    ).visible(mDashboardResponse.level!.isNotEmpty)
                  ],
                ),
              );
            }
            return snapWidgetHelper(snapshot, loadingWidget: Loader());
          },
        ),
      ),
    );
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return mSuffixTextFieldIconWidget(ic_search);
    }

    return IconButton(
      onPressed: () => mSearchCont.clear(),
      icon: Icon(Icons.clear),
    );
  }
}
