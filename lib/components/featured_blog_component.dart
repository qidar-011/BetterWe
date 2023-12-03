import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../../extensions/common.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../screens/blog_detail_screen.dart';
import '../extensions/text_styles.dart';
import '../models/blog_response.dart';
import '../utils/app_common.dart';

class FeaturedBlogComponent extends StatefulWidget {
  final BlogModel? mBlogModel;

  FeaturedBlogComponent({this.mBlogModel});

  @override
  _FeaturedBlogComponentState createState() => _FeaturedBlogComponentState();
}

class _FeaturedBlogComponentState extends State<FeaturedBlogComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            cachedImage(widget.mBlogModel!.postImage.validate(), width: context.width(), height: context.height() * 0.37, fit: BoxFit.cover).cornerRadiusWithClipRRect(12).onTap(() {
              BlogDetailScreen(mBlogModel: widget.mBlogModel!).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            }),
            mBlackEffect(context.width(), context.height() * 0.37, radiusValue: 0).cornerRadiusWithClipRRect(12),
          ],
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Text(widget.mBlogModel!.title.validate(), style: boldTextStyle(color: Colors.white)),
        ),
      ],
    ).onTap(() {
      BlogDetailScreen(mBlogModel: widget.mBlogModel!).launch(context);
    });
  }
}
