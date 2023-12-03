import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_fitness/extensions/loader_widget.dart';
import '../extensions/constants.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../utils/app_colors.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../network/rest_api.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../../models/blog_response.dart';

class BlogDetailScreen extends StatefulWidget {
  final BlogModel? mBlogModel;

  BlogDetailScreen({this.mBlogModel});

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  Map? req;
  BlogModel? mBlog;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (showAdOnBlogDetail) loadInterstitialAds();
    req = {"id": widget.mBlogModel!.id};
    appStore.setLoading(true);
    await getBlogDetailApi(req!).then((value) {
      mBlog = value.data!;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    if (showAdOnBlogDetail) showInterstitialAds();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
            Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Hero(
                        tag: widget.mBlogModel!,
                        transitionOnUserGestures: true,
                        child: cachedImage(widget.mBlogModel!.postImage.validate(), width: context.width(), height: context.height() * 0.39, fit: BoxFit.fill),
                      ),
                      mBlackEffect(context.width(), context.height() * 0.37, radiusValue: 0),
                      Positioned(
                          top: context.statusBarHeight + 16,
                          left: 16,
                          child: Icon(appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left, color: Colors.white, size: 28).onTap(() {
                            Navigator.pop(context);
                          })),
                      Positioned(
                        top: context.statusBarHeight + 55,
                        left: 16,
                        child: Container(
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: whiteColor.withOpacity(0.4), borderRadius: radius(8)),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.access_time_outlined, color: Colors.white, size: 16).paddingRight(4),
                                ),
                                TextSpan(text: parseDocumentDate(DateTime.parse(widget.mBlogModel!.datetime.validate())), style: secondaryTextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 40,
                        child: Text(widget.mBlogModel!.title.validate(), style: boldTextStyle(color: Colors.white, size: 18), maxLines: 2, overflow: TextOverflow.ellipsis),
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
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: 20.0, topRight: 20.0), backgroundColor: context.scaffoldBackgroundColor),
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.mBlogModel!.tagsName!.isNotEmpty
                              ? Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: List.generate(
                                    widget.mBlogModel!.tagsName!.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: (() {
                                          setState(() {});
                                        }),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: boxDecorationWithRoundedCorners(
                                              backgroundColor: appStore.isDarkMode ? context.cardColor : Colors.white, borderRadius: radius(24), border: Border.all(width: 0.3, color: primaryColor)),
                                          child: Text(widget.mBlogModel!.tagsName![index].title.validate(), style: secondaryTextStyle(color: primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ),
                                      );
                                    },
                                  ),
                                ).paddingOnly(left: 16, bottom: 16, top: 16, right: appStore.selectedLanguageCode == 'ar' ? 16 : 0)
                              : SizedBox().paddingOnly(top: 16),
                          if (!appStore.isLoading)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: htmlWidget(context, mBlog!.description.validate(), textPrimaryColorGlobal, primaryTextStyle()),
                            ),
                          16.height,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Observer(builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            }),
          ],
        ),
      ),
    );
  }
}
