import 'package:flutter/material.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/widgets.dart';
import '../components/adMob_component.dart';
import '../components/featured_diet_component.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../models/category_diet_response.dart';
import '../models/diet_response.dart';
import '../network/rest_api.dart';
import '../utils/app_config.dart';
import 'no_data_screen.dart';

class ViewAllDiet extends StatefulWidget {
  final bool? isFeatured;
  final bool? isCategory;
  final int? mCategoryId;
  final String? mTitle;
  final bool? isAssign;
  final bool? isFav;

  ViewAllDiet({this.isFeatured = false, this.isCategory, this.mCategoryId, this.mTitle, this.isFav = false, this.isAssign = false});

  @override
  _ViewAllDietState createState() => _ViewAllDietState();
}

class _ViewAllDietState extends State<ViewAllDiet> {
  ScrollController scrollController = ScrollController();
  List<DietModel> mDietList = [];
  CategoryDietModel? mCategoryDietModel;

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
    getDietData();
  }

  Future<void> getDietData() async {
    appStore.setLoading(true);
    await getDietApi(page: page, widget.isFeatured == true ? "yes" : "no", widget.isCategory, isAssign: widget.isAssign, categoryId: widget.mCategoryId, isFav: widget.isFav).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mDietList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mDietList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAssign == true || widget.isFav == true
          ? PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: SizedBox(),
            )
          : appBarWidget(widget.mTitle.validate(), context: context),
      body: Stack(
        children: [
          mDietList.isNotEmpty
              ? AnimatedListView(
                  controller: scrollController,
                  itemCount: mDietList.length,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: widget.isFav == true || widget.isAssign == true ? 16 : 8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return FeaturedDietComponent(
                      isList: true,
                      mDietModel: mDietList[index],
                      onCall: () {
                        if (widget.isFav == true) {
                          mDietList.clear();
                          getDietData();
                        }
                      },
                    );
                  },
                )
              : NoDataScreen(mTitle: languages.lblResultNoFound).visible(!appStore.isLoading),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
      bottomNavigationBar: showBannerAdOnDiet && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox(),
    );
  }
}
