import 'package:flutter/material.dart';
import '../main.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../utils/app_common.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/text_styles.dart';
import '../extensions/decorations.dart';
import '../models/category_diet_response.dart';
import '../screens/view_all_diet.dart';
import '../utils/app_colors.dart';

class DietCategoryComponent extends StatefulWidget {
  final CategoryDietModel? mCategoryDietModel;
  final isGrid;

  final Function? onCall;

  DietCategoryComponent({
    this.mCategoryDietModel,
    this.isGrid = false,
    this.onCall,
  });

  @override
  _DietCategoryComponentState createState() => _DietCategoryComponentState();
}

class _DietCategoryComponentState extends State<DietCategoryComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isGrid ? (context.width() - 48) / 2 : context.width() * 0.38,
      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), backgroundColor: appStore.isDarkMode ? context.cardColor : cardBackground),
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          cachedImage(widget.mCategoryDietModel!.categorydietImage!.validate(), fit: BoxFit.contain, width: context.width(), height: 100).cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12),
          4.height,
          Text(
            widget.mCategoryDietModel!.title!.validate(),
            style: primaryTextStyle(size: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 16),
          16.height,
        ],
      ),
    ).paddingOnly(bottom: 8, right: widget.isGrid ? 0 : 10).onTap(() {
      ViewAllDiet(
        isCategory: true,
        mCategoryId: widget.mCategoryDietModel!.id,
        mTitle: widget.mCategoryDietModel!.title,
      ).launch(context);
    });
  }
}
