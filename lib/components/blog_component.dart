import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../screens/blog_detail_screen.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/blog_response.dart';
import '../utils/app_common.dart';

class BlogComponent extends StatefulWidget {
  final BlogModel? mBlogModel;
  final Function? onCall;

  BlogComponent({this.mBlogModel, this.onCall});

  @override
  _BlogComponentState createState() => _BlogComponentState();
}

class _BlogComponentState extends State<BlogComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius()) : boxDecorationRoundedWithShadow(defaultRadius.toInt()),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              BlogDetailScreen(mBlogModel: widget.mBlogModel!).launch(context);
            },
            child: Hero(
              tag: widget.mBlogModel!,
              transitionOnUserGestures: true,
              child: cachedImage(widget.mBlogModel!.postImage.validate(), width: 70, height: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
            ),
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              4.height,
              Text(
                widget.mBlogModel!.title.validate(),
                style: boldTextStyle(size: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              10.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(MaterialIcons.access_time, size: 16, color: textSecondaryColorGlobal),
                  4.width,
                  Text(parseDocumentDate(DateTime.parse(widget.mBlogModel!.datetime.validate())), style: secondaryTextStyle()),
                  16.width,
                  Container(height: 6, width: 6, decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: textSecondaryColorGlobal)),
                  8.width,
                  Text(widget.mBlogModel!.categoryName!.first.title.validate(), style: secondaryTextStyle())
                ],
              ),
              2.height,
            ],
          ).expand()
        ],
      ),
    ).onTap(() {
      BlogDetailScreen(mBlogModel: widget.mBlogModel!).launch(context);
    });
  }
}
