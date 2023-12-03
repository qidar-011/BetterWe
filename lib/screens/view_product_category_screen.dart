import 'package:flutter/material.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../components/product_category_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/colors.dart';
import '../extensions/loader_widget.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/product_category_response.dart';
import '../network/rest_api.dart';

class ViewProductCategoryScreen extends StatefulWidget {
  const ViewProductCategoryScreen({super.key});

  @override
  State<ViewProductCategoryScreen> createState() => _ViewProductCategoryScreenState();
}

class _ViewProductCategoryScreenState extends State<ViewProductCategoryScreen> {
  ScrollController scrollController = ScrollController();
  List<ProductCategoryModel> mProductCategoryList = [];
  ProductCategoryModel? mCategoryProductModel;
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
    getProductCategoryData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> getProductCategoryData() async {
    appStore.setLoading(true);
    await getProductCategoryApi(page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mProductCategoryList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mProductCategoryList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblProductCategory, textColor: blackColor, elevation: 0, color: Colors.white, context: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 16, top: 8),
            child: AnimatedWrap(
              runSpacing: 16,
              spacing: 16,
              children: List.generate(mProductCategoryList.length, (index) {
                return ProductCategoryComponent(
                  mProductCategoryModel: mProductCategoryList[index],
                  isGrid: true,
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
