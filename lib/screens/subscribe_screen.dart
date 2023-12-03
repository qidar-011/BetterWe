import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_fitness/screens/no_data_screen.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../network/rest_api.dart';
import '../screens/payment_screen.dart';
import '../utils/app_colors.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/app_button.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/subscription_response.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  ScrollController scrollController = ScrollController();
  List<SubscriptionModel> mSubscriptionListNew = [];

  int page = 1;
  int? numPage;
  int? currentIndex = 0;

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
    getPackageData();
  }

  Future<void> getPackageData() async {
    appStore.setLoading(true);
    getSubscription().then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mSubscriptionListNew.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mSubscriptionListNew.add(e)).toList();

      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Widget overlayContainer() {
    return Container(
      height: context.height() / 2.4,
      width: context.width(),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          appStore.isDarkMode ? Colors.black.withOpacity(0.3) : Colors.transparent,
          appStore.isDarkMode ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.3),
          appStore.isDarkMode ? context.scaffoldBackgroundColor : Colors.white,
        ],
      )),
    );
  }

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: context.scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Image.asset(Subscribe_Bg, fit: BoxFit.fill, height: context.height() / 2.4, width: context.width()),
                    overlayContainer(),
                    Positioned(
                      left: 16,
                      bottom: 0,
                      right: appStore.selectedLanguageCode == 'ar' ? 16 : 100,
                      child: Text(
                        languages.lblPackageTitle,
                        style: boldTextStyle(size: 26, color: primaryColor, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon: Icon(appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left, color: whiteColor, size: 28),
                    ).paddingTop(context.statusBarHeight + 8),
                  ],
                ),
                4.height,
                Text(languages.lblPackageTitle1, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16, vertical: 8),
                16.height,
                Loader().center().visible(appStore.isLoading),
                if (!appStore.isLoading)
                  mSubscriptionListNew.isNotEmpty
                      ? Column(
                          children: [
                            AnimatedListView(
                              itemCount: mSubscriptionListNew.length,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: appStore.selectedLanguageCode == 'ar' ? EdgeInsets.symmetric(horizontal: 16) : EdgeInsets.symmetric(horizontal: 0),
                                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), border: Border.all(color: selectedIndex == index ? primaryColor : context.dividerColor)),
                                  child: Column(
                                    children: [
                                      Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Row(
                                          children: [
                                            Image.asset(selectedIndex == index ? ic_radio_fill : ic_radio, height: 20, width: 20,color: primaryColor),
                                            8.width,
                                            Text(mSubscriptionListNew[index].name.validate(), style: boldTextStyle(size: 18)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            PriceWidget(
                                              price: mSubscriptionListNew[index].price.validate().toString(),
                                              color: primaryColor,
                                              textStyle: boldTextStyle(color: primaryColor, size: 20),
                                            ),

                                            2.width,
                                            mSubscriptionListNew[index].durationUnit.toString() == "monthly"
                                                ? Text("/ " + mSubscriptionListNew[index].duration.toString().validate() + " " + languages.lblMonth, style: primaryTextStyle())
                                                : Text("/ " + mSubscriptionListNew[index].duration.toString().validate() + " " + languages.lblYear.capitalizeFirstLetter(), style: primaryTextStyle()),
                                          ],
                                        ),
                                      ]),
                                      10.height,
                                      htmlWidget(context, mSubscriptionListNew[index].description.validate(), textPrimaryColorGlobal, secondaryTextStyle()),
                                      8.height,
                                    ],
                                  ).paddingOnly(left: 16, right: 16, bottom: 8, top: 16),
                                ).onTap(() {
                                  setState(() {
                                    if (selectedIndex == index) {
                                      selectedIndex = -1;
                                    } else {
                                      selectedIndex = index;
                                    }
                                  });
                                });
                              },
                            ),
                            AppButton(
                              text: languages.lblSubscribe,
                              width: context.width(),
                              color: primaryColor,
                              onTap: () {
                                selectedIndex == -1
                                    ? toast(languages.lblSelectPlanToContinue)
                                    : PaymentScreen(
                                        mSubscriptionModel: mSubscriptionListNew[selectedIndex],
                                      ).launch(context);
                              },
                            ).paddingSymmetric(horizontal: 16, vertical: 16),
                          ],
                        )
                      : NoDataScreen()
              ],
            ),
          )),
    );
  }
}
