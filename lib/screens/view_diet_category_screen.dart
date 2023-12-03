import 'package:flutter/material.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../screens/view_all_diet.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../components/diet_category_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/colors.dart';
import '../extensions/loader_widget.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/category_diet_response.dart';
import '../network/rest_api.dart';

class ViewDietCategoryScreen extends StatefulWidget {
  @override
  _ViewDietCategoryScreenState createState() => _ViewDietCategoryScreenState();
}

class _ViewDietCategoryScreenState extends State<ViewDietCategoryScreen> {
  ScrollController scrollController = ScrollController();
  List<CategoryDietModel> mDietCategoryList = [];
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
    getDietCategoryData();
  }

  Future<void> getDietCategoryData() async {
    appStore.setLoading(true);
    await getDietCategoryApi(page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mDietCategoryList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mDietCategoryList.add(e)).toList();
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
      appBar: appBarWidget(languages.lblDietCategories, textColor: blackColor, elevation: 0, color: Colors.white, context: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 16, top: 4),
            child: AnimatedWrap(
              runSpacing: 2,
              spacing: 16,
              children: List.generate(mDietCategoryList.length, (index) {
                return DietCategoryComponent(
                  mCategoryDietModel: mDietCategoryList[index],
                  isGrid: true,
                  onCall: () {
                    ViewAllDiet(mTitle: mDietCategoryList[index].title.validate(), isCategory: true, mCategoryId: mDietCategoryList[index].id).launch(context);
                  },
                );
              }),
            ).paddingSymmetric(horizontal: 16),
          ),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
