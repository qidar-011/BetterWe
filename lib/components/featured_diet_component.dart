import 'dart:ui';
import 'package:flutter/material.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../models/diet_response.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../screens/diet_detail_screen.dart';
import '../extensions/colors.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../network/rest_api.dart';
import '../screens/subscribe_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';

class FeaturedDietComponent extends StatefulWidget {
  final isList;
  final DietModel? mDietModel;

  final bool? isFeatured;
  final bool? isCategory;

  final int? mCategoryId;

  final Function? onCall;

  FeaturedDietComponent({this.mDietModel, this.isList = false, this.isFeatured, this.isCategory, this.mCategoryId, this.onCall});

  @override
  _FeaturedDietComponentState createState() => _FeaturedDietComponentState();
}

class _FeaturedDietComponentState extends State<FeaturedDietComponent> {
  int? numPage;

  bool isLastPage = false;

  List<DietModel> mDietList = [];

  Future<void> setDiet(int? id) async {
    appStore.setLoading(true);
    Map req = {"diet_id": id};
    await setDietFavApi(req).then((value) {
      toast(value.message);
      if (widget.mDietModel!.isFavourite == 1) {
        widget.mDietModel!.isFavourite = 0;
      } else {
        widget.mDietModel!.isFavourite = 1;
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
    return widget.isList
        ? Container(
            margin: EdgeInsets.only(bottom: 16),
            width: context.width(),
            decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius(16)) : boxDecorationRoundedWithShadow(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    cachedImage(widget.mDietModel!.dietImage.validate(), width: context.width(), height: 190, fit: BoxFit.cover).cornerRadiusWithClipRRectOnly(bottomLeft: 0, bottomRight: 0, topRight: 16, topLeft: 16),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: Colors.white.withOpacity(0.5)),
                              child: Image.asset(widget.mDietModel!.isFavourite == 1 ? ic_favorite_fill : ic_favorite, height: 20, width: 20, color: widget.mDietModel!.isFavourite == 1 ? primaryColor : white))
                          .onTap(
                        () {

                          setState(() {});
                          setDiet(widget.mDietModel!.id.validate());
                        },
                      ),
                    ),
                    widget.mDietModel!.isPremium == 1
                        ? Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(6), backgroundColor: primaryColor),
                              child: Text(languages.lblPro, style: boldTextStyle(size: 12, color: Colors.white)),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Text(widget.mDietModel!.title.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).paddingSymmetric(horizontal: 16, vertical: 12),
              ],
            ),
          ).onTap(() async {
            widget.mDietModel!.isPremium == 1
                ? userStore.isSubscribe == 0
                    ? SubscribeScreen().launch(context)
                    : DietDetailScreen(dietModel: widget.mDietModel!).launch(context)
                : await DietDetailScreen(dietModel: widget.mDietModel!).launch(context);
            setState(() {});
          })
        : Container(
            margin: EdgeInsets.only(bottom: 16, right: 8),
            width: context.width() * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    cachedImage(widget.mDietModel!.dietImage.validate(), width: context.width() * 0.65, height: 240, fit: BoxFit.fill).cornerRadiusWithClipRRect(16),
                    Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: Colors.white.withOpacity(0.5)),
                                child: Image.asset(widget.mDietModel!.isFavourite == 1 ? ic_favorite_fill : ic_favorite, height: 20, width: 20, color: widget.mDietModel!.isFavourite == 1 ? primaryColor : white))
                            .onTap(() {
                          setState(() {});
                          setDiet(widget.mDietModel!.id.validate());
                        })),
                    widget.mDietModel!.isPremium == 1
                        ? Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(6), backgroundColor: primaryColor),
                              child: Text(languages.lblPro, style: boldTextStyle(size: 12, color: Colors.white)),
                            ),
                          )
                        : SizedBox(),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: radiusOnly(bottomRight: 16, bottomLeft: 16, topLeft: 8, topRight: 8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(bottomRight: 16, bottomLeft: 16, topLeft: 8, topRight: 8), backgroundColor: Colors.grey.shade100.withOpacity(0.5)),
                            child: Text(
                              widget.mDietModel!.title.validate(),
                              style: primaryTextStyle(color: black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ).paddingSymmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).onTap(() async {
            widget.mDietModel!.isPremium == 1
                ? userStore.isSubscribe == 0
                    ? SubscribeScreen().launch(context)
                    : DietDetailScreen(dietModel: widget.mDietModel!).launch(context)
                : await DietDetailScreen(dietModel: widget.mDietModel!).launch(context);
            setState(() {});
          });
  }
}
