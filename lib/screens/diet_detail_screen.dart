import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/constants.dart';
import '../extensions/widgets.dart';
import '../utils/app_colors.dart';
import '../../extensions/colors.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../models/diet_response.dart';
import '../extensions/decorations.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../network/rest_api.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/app_images.dart';

class DietDetailScreen extends StatefulWidget {
  final DietModel? dietModel;
  final Function? onCall;
  final bool? isCategory;
  final bool? isFeatured;

  DietDetailScreen({
    this.dietModel,
    this.onCall,
    this.isFeatured,
    this.isCategory,
  });

  @override
  _DietDetailScreenState createState() => _DietDetailScreenState();
}

class _DietDetailScreenState extends State<DietDetailScreen> {
  bool select = true;
  int page = 1;
  int? numPage;
  bool isLastPage = false;
  List<DietModel> mDietList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (showAdOnDietDetail) loadInterstitialAds();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> setDiet(int? id) async {
    appStore.setLoading(true);
    Map req = {"diet_id": id};
    await setDietFavApi(req).then((value) {
      toast(value.message);
      appStore.setLoading(false);
      if (widget.dietModel!.isFavourite == 1) {
        widget.dietModel!.isFavourite = 0;
      } else {
        widget.dietModel!.isFavourite = 1;
      }

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (showAdOnDietDetail) showInterstitialAds();
    super.dispose();
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
        backgroundColor: Colors.black45,
        body: Stack(
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
                      cachedImage(widget.dietModel!.dietImage.validate(), width: context.width(), height: context.height() * 0.37, fit: BoxFit.cover),
                      Container(color: Colors.black45, height: context.height() * 0.37, width: context.width()),
                    ],
                  ),
                  Positioned(
                      top: context.statusBarHeight,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              finish(context);
                            },
                            icon: Icon(appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left, color: whiteColor),
                          ),
                          if (widget.dietModel!.isPremium == 1)
                            Container(
                              margin: EdgeInsets.only(left: 16, top: 8),
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(4), backgroundColor: primaryColor),
                              child: Text(languages.lblPro, style: boldTextStyle(size: 12, color: Colors.white)),
                            ),
                        ],
                      )),
                  Positioned(
                      top: context.statusBarHeight + 10,
                      right: 16,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: Colors.white.withOpacity(0.5)),
                          child: Image.asset(
                            widget.dietModel!.isFavourite == 1 ? ic_favorite_fill : ic_favorite,
                            height: 20,
                            width: 20,
                            color: widget.dietModel!.isFavourite == 1 ? primaryColor : Colors.white,
                          )).onTap(() {
                        setDiet(widget.dietModel!.id.validate());
                        setState(() {});
                      })),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dietModel!.title.validate(),
                          style: boldTextStyle(color: Colors.white, size: 20),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).expand(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          margin: EdgeInsets.only(left: 16),
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? Colors.black.withOpacity(0.6) : whiteColor.withOpacity(0.3), borderRadius: radius(8)),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Feather.clock, color: Colors.white, size: 16).paddingRight(4)),
                                TextSpan(text: widget.dietModel!.totalTime.validate(), style: secondaryTextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.65,
              maxChildSize: 0.9,
              builder: (context, controller) => Container(
                width: context.width(),
                decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: 20, topRight: 20), backgroundColor: context.scaffoldBackgroundColor),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Row(
                        children: [
                          getVitamins(ic_calories, widget.dietModel!.calories.validate() + " " + languages.lblKcal, languages.lblCalories).expand(),
                          dividerHorizontalLine(),
                          getVitamins(ic_carbs, widget.dietModel!.carbs.validate() + " ${languages.lblG}", languages.lblCarbs).expand(),
                          dividerHorizontalLine(),
                          getVitamins(ic_fat, widget.dietModel!.fat.validate() + " ${languages.lblG}", languages.lblFat).expand(),
                          dividerHorizontalLine(),
                          getVitamins(ic_protein, widget.dietModel!.protein.validate() + " ${languages.lblG}", languages.lblProtein).expand(),
                        ],
                      ).paddingSymmetric(horizontal: 10, vertical: 8),
                      8.height,
                      Divider(color: appStore.isDarkMode ? Colors.white : context.dividerColor, indent: 16, endIndent: 16, height: 0.5),
                      8.height,
                      Container(
                        padding: EdgeInsets.only(top: 22),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: appStore.isDarkMode ? whiteColor : context.dividerColor, width: 0.5))),
                        child: Row(children: [
                          Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: select ? primaryColor : Colors.transparent))),
                                  child: Text(languages.lblIngredients, style: boldTextStyle(color: select ? primaryColor : textSecondaryColorGlobal)).center())
                              .onTap(() {
                            setState(() {
                              select = !select;
                            });
                          }).expand(),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: select ? Colors.transparent : primaryColor))),
                            child: Text(languages.lblInstruction, style: boldTextStyle(color: select ? textSecondaryColorGlobal : primaryColor)).center(),
                          ).onTap(() {
                            setState(() {
                              select = !select;
                            });
                          }).expand(),
                        ]).paddingSymmetric(horizontal: 16),
                      ),
                      16.height,
                      select ? ingredients() : instruction()
                    ],
                  ).paddingOnly(bottom: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getVitamins(String image, String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(image, height: 26, width: 26, fit: BoxFit.contain, color: primaryColor),
        8.height,
        Text(title, style: boldTextStyle(),textAlign: TextAlign.center),
        4.height,
        Text(subTitle, style: secondaryTextStyle()),
      ],
    );
  }

  Widget getIngredients(String title) {
    return Text(title, style: primaryTextStyle(color: scaffoldBackgroundColor));
  }

  Widget ingredients() {
    return Container(
      child: htmlWidget(context, widget.dietModel!.ingredients.toString(), textPrimaryColorGlobal, primaryTextStyle()),
    ).paddingSymmetric(horizontal: 16);
  }

  Widget instruction() {
    return Container(
      child: htmlWidget(context, widget.dietModel!.description.validate(), textPrimaryColorGlobal, primaryTextStyle()),
    ).paddingSymmetric(horizontal: 16);
  }

  Widget dividerHorizontalLine() {
    return SizedBox(
      height: 65,
      child: VerticalDivider(color: context.dividerColor, width: 10, thickness: 1, indent: 10, endIndent: 10),
    );
  }
}
