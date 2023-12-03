import 'package:flutter/material.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../screens/no_data_screen.dart';
import '../screens/subscribe_screen.dart';
import '../utils/app_colors.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/app_button.dart';
import '../extensions/constants.dart';
import '../extensions/system_utils.dart';
import '../main.dart';

import '../models/subscribePlan_response.dart';
import '../network/rest_api.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final SubscriptionPlan? mList;

  const SubscriptionDetailScreen({super.key, this.mList});

  @override
  State<SubscriptionDetailScreen> createState() => _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  List<SubscriptionPlan> mSubscriptionPlanList = [];
  bool select = true;

  ScrollController scrollController = ScrollController();

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  void init() async {
    getSubscriptionList();
  }

  Future<void> getSubscriptionList() async {
    appStore.setLoading(true);
    getSubScriptionPlanList(page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mSubscriptionPlanList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mSubscriptionPlanList.add(e)).toList();

      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> cancelPackage() async {
    Map req = {
      "id": userStore.subscriptionDetail!.subscriptionPlan!.id,
    };
    await cancelPlanApi(req).then((value) async {
      await getUSerDetail(context, userStore.userId).whenComplete(() {
        userStore.isSubscribe = 0;
        setState(() {});
        toast(value.message);
        finish(context);
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  Color getTextColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor;
      case INACTIVE:
        return Colors.grey;
      case CANCELLED:
        return RedColor;
      case EXPIRED:
        return YellowColor;
      default:
        return Colors.black;
    }
  }

  Color getBgColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor.withOpacity(0.15);
      case INACTIVE:
        return Colors.grey.withOpacity(0.10);
      case CANCELLED:
        return RedColor.withOpacity(0.10);
      case EXPIRED:
        return YellowColor.withOpacity(0.5);
      default:
        return Colors.black;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblSubscriptionPlans,
          context: context,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.dividerColor))),
              child: Row(children: [
                Container(
                        padding: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 1.5, color: select ? primaryColor : Colors.transparent),
                        )),
                        child: Text(
                          languages.lblActive,
                          style: boldTextStyle(color: select ? primaryColor : textSecondaryColorGlobal),
                        ).center())
                    .onTap(() {
                  setState(() {
                    select = !select;
                  });
                }).expand(),
                Container(
                        padding: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 1.5, color: select ? Colors.transparent : primaryColor),
                        )),
                        child: Text(
                          languages.lblHistory,
                          style: boldTextStyle(color: select ? textSecondaryColorGlobal : primaryColor),
                        ).center())
                    .onTap(() {
                  setState(() {
                    select = !select;
                  });
                }).expand(),
              ]).paddingSymmetric(
                horizontal: 16,
              ),
            ),
          )),
      body: select
          ? userStore.subscriptionDetail!.subscriptionPlan == null || userStore.subscriptionDetail!.subscriptionPlan!.status == "inactive"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
                    20.height,
                    Text(languages.lblSubscriptionMsg, style: boldTextStyle(size: 16, color: textSecondaryColorGlobal)),
                    50.height,
                    AppButton(
                      text: languages.lblViewPlans,
                      width: context.width(),
                      color: primaryColor,
                      onTap: () {
                        SubscribeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                      },
                    ).paddingAll(16)
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      16.height,
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? cardDarkColor : GreenColor.withOpacity(0.10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userStore.subscriptionDetail!.subscriptionPlan!.packageName.validate(), style: boldTextStyle()).expand(),
                                PriceWidget(
                                  price: userStore.subscriptionDetail!.subscriptionPlan!.totalAmount!.toStringAsFixed(2),
                                  color: primaryColor,
                                  textStyle: boldTextStyle(color: primaryColor, size: 20),
                                ),
                              ],
                            ),
                            Text(
                                languages.lblYourPlanValid +
                                    parseDocumentDate(DateTime.parse(userStore.subscriptionDetail!.subscriptionPlan!.subscriptionStartDate.validate())) +
                                    " ${languages.lblTo} " +
                                    parseDocumentDate(DateTime.parse(userStore.subscriptionDetail!.subscriptionPlan!.subscriptionEndDate.validate())),
                                style: primaryTextStyle(color: primaryColor, size: 12)),
                            8.height,
                            Container(child: htmlWidget(context, userStore.subscriptionDetail!.subscriptionPlan!.packageData!.description.validate(), textPrimaryColorGlobal, secondaryTextStyle())),
                            16.height,
                          ],
                        ),
                      ),
                      24.height,
                      AppButton(
                        text: languages.lblCancelSubscription,
                        width: context.width(),
                        color: primaryOpacity,
                        textColor: primaryColor,
                        onTap: () {
                          cancelPackage();
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                )
          : mSubscriptionPlanList.isNotEmpty
              ? AnimatedListView(
                  itemCount: mSubscriptionPlanList.length,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  shrinkWrap: true,
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? cardDarkColor : getBgColor(mSubscriptionPlanList[index].status.validate())),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mSubscriptionPlanList[index].packageName.validate(), style: boldTextStyle()).expand(),
                            PriceWidget(
                              price: mSubscriptionPlanList[index].totalAmount.validate().toString(),
                              color: primaryColor,
                              textStyle: boldTextStyle(),
                            ),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Text(
                              parseDocumentDate(DateTime.parse(mSubscriptionPlanList[index].subscriptionStartDate.validate())) +
                                  " ${languages.lblTo} " +
                                  parseDocumentDate(DateTime.parse(mSubscriptionPlanList[index].subscriptionEndDate.validate())),
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(height: 6, width: 6, decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: textSecondaryColorGlobal)),
                                6.width,
                                Text(mSubscriptionPlanList[index].paymentType.validate().capitalizeFirstLetter(), style: primaryTextStyle()),
                              ],
                            ).expand(),
                            Text(mSubscriptionPlanList[index].status.validate().capitalizeFirstLetter()=='Inactive'?'غير نشط':mSubscriptionPlanList[index].status.validate().capitalizeFirstLetter()=='Active'?'نشط':mSubscriptionPlanList[index].status.validate().capitalizeFirstLetter(), style: boldTextStyle(color: getTextColor(mSubscriptionPlanList[index].status.validate())))
                          ],
                        )
                      ]),
                    );
                  },
                )
              : SizedBox(height: context.height() * 0.65, child: NoDataScreen().center()).visible(!appStore.isLoading),
    );
  }
}
