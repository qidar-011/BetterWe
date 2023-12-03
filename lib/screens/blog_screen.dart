import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../screens/view_all_blog_screen.dart';
import '../../components/blog_component.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/widgets.dart';
import '../../main.dart';
import '../../models/blog_response.dart';
import '../components/featured_blog_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/loader_widget.dart';
import '../extensions/text_styles.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';
import 'no_data_screen.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  ScrollController scrollController = ScrollController();

  List<BlogModel> mFeaturedBlogList = [];
  List<BlogModel> mOtherBlogList = [];
  List<BlogModel> mSearchBlogList = [];

  int page = 1;
  int? numPage;
  int currentIndex = 0;

  bool isLastPage = false;
  bool _showClearButton = false;

  TextEditingController mSearch = TextEditingController();
  FocusNode mSearchFocus = FocusNode();
  String? mSearchValue = "";

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
    mSearch.addListener(() {
      setState(() {
        _showClearButton = mSearch.text.length > 0;
      });
    });
  }

  void init() async {
    getBlogData();
  }

  Future<void> getBlogData() async {
    appStore.setLoading(true);
    getBlogApi("yes").then((value) {
      Iterable it = value.data!;
      it.map((e) => mFeaturedBlogList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    }).whenComplete(() {
      getBlogApi("no").then((value) {
        appStore.setLoading(false);
        numPage = value.pagination!.totalPages;
        isLastPage = false;
        if (page == 1) {
          mOtherBlogList.clear();
        }
        Iterable it = value.data!;
        it.map((e) => mOtherBlogList.add(e)).toList();
        setState(() {});
      }).catchError((e) {
        isLastPage = true;
        appStore.setLoading(false);
        setState(() {});
      });
    });
  }

  getBlogDataAPI() async {
    await getSearchBlogApi(mSearch: mSearchValue).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mSearchBlogList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mSearchBlogList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Widget mBlogList() {
    return AnimatedWrap(
      runSpacing: 8,
      spacing: 8,
      children: List.generate(mOtherBlogList.length, (index) {
        return BlogComponent(
          mBlogModel: mOtherBlogList[index],
          onCall: () {
            setState(() {});
          },
        );
      }),
    ).paddingSymmetric(horizontal: 16);
  }

  Widget mHeading(String? title, {bool? isSeeAll = false, Function? onCall}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            onCall!.call();
          },
          icon: Icon(
            Feather.chevron_right,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblBlog, context: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                2.height,
                AppTextField(
                  controller: mSearch,
                  textFieldType: TextFieldType.OTHER,
                  isValidationRequired: false,
                  autoFocus: false,
                  suffix: _getClearButton(),
                  decoration: defaultInputDecoration(context, isFocusTExtField: true, label: languages.lblSearch),
                  onChanged: (v) {
                    mSearchValue = v;
                    appStore.setLoading(true);
                    getBlogDataAPI();
                    setState(() {});
                  },
                ).paddingSymmetric(horizontal: 16),
                mSearchValue.isEmptyOrNull
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              8.height,
                              mHeading(languages.lblTopFitnessReads, onCall: () {
                                ViewAllBlogScreen(isFeatured: true).launch(context);
                              }),
                              SizedBox(
                                width: context.width(),
                                height: context.height() * 0.25,
                                child: Swiper(
                                  onIndexChanged: (index) {
                                    currentIndex = index;
                                    setState(() {});
                                  },
                                  itemBuilder: (BuildContext context, int index) {
                                    return FeaturedBlogComponent(mBlogModel: mFeaturedBlogList[index]);
                                  },
                                  itemCount: mFeaturedBlogList.length,
                                  itemWidth: context.width() * 0.87,
                                  layout: SwiperLayout.STACK,
                                ),
                              ).paddingOnly(left: 8, bottom: 8),
                              dotIndicator(mFeaturedBlogList, currentIndex),
                            ],
                          ).visible(mFeaturedBlogList.isNotEmpty),
                          Column(
                            children: [
                              16.height,
                              mHeading(languages.lblTrendingBlogs, onCall: () {
                                ViewAllBlogScreen(isFeatured: false).launch(context);
                              }),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                controller: scrollController,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                itemCount: mOtherBlogList.length,
                                itemBuilder: (context, index) {
                                  return BlogComponent(mBlogModel: mOtherBlogList[index]);
                                },
                              ),
                            ],
                          ).visible(mOtherBlogList.isNotEmpty),
                        ],
                      )
                    : Stack(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            controller: scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: mSearchBlogList.length,
                            itemBuilder: (context, index) {
                              return BlogComponent(mBlogModel: mSearchBlogList[index]);
                            },
                          ).paddingTop(16),
                          SizedBox(
                            height: context.height() * 0.6,
                            child: NoDataScreen(mTitle: languages.lblResultNoFound).visible(mSearchBlogList.isEmpty).center().visible(!appStore.isLoading),
                          )
                        ],
                      ),
              ],
            ),
          ),
          mFeaturedBlogList.isEmpty && mOtherBlogList.isEmpty
              ? NoDataScreen(
                  mTitle: languages.lblResultNoFound,
                ).visible(!appStore.isLoading)
              : SizedBox(),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return mSuffixTextFieldIconWidget(ic_search);
    }

    return IconButton(
      onPressed: () {
        getBlogData();
        mSearch.clear();
        mFeaturedBlogList.clear();
        mSearchValue = "";
        hideKeyboard(context);
      },
      icon: Icon(Icons.clear),
    );
  }
}
