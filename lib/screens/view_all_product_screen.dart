import 'package:flutter/material.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../screens/no_data_screen.dart';

import '../components/adMob_component.dart';
import '../components/product_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/loader_widget.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/product_category_response.dart';
import '../models/product_response.dart';
import '../network/rest_api.dart';
import '../utils/app_config.dart';

class ViewAllProductScreen extends StatefulWidget {
  final bool? isCategory;
  final int? id;
  final String? title;

  const ViewAllProductScreen({super.key, this.isCategory = false, this.title, this.id});

  @override
  State<ViewAllProductScreen> createState() => _ViewAllProductScreenState();
}

class _ViewAllProductScreenState extends State<ViewAllProductScreen> {
  ScrollController scrollController = ScrollController();
  List<ProductModel> mProductList = [];
  ProductCategoryModel? mCategoryDietModel;
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
    getAllProductData();
  }

  Future<void> getAllProductData() async {
    appStore.setLoading(true);
    await getProductApi(page: page, isCategory: widget.isCategory, productId: widget.id.validate()).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mProductList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mProductList.add(e)).toList();
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
      appBar: appBarWidget(widget.isCategory == true ? widget.title.toString() : languages.lblProductList, elevation: 0, context: context),
      body: Stack(
        children: [
          mProductList.isNotEmpty
              ? SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 16, top: 4),
                  child: AnimatedWrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: List.generate(mProductList.length, (index) {
                      return ProductComponent(
                        mProductModel: mProductList[index],
                        onCall: () {
                          getAllProductData();
                          setState(() {});
                        },
                      );
                    }),
                  ).paddingSymmetric(horizontal: 16),
                )
              : NoDataScreen(
                  mTitle: languages.lblResultNoFound,
                ).center().visible(!appStore.isLoading),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
      bottomNavigationBar: showBannerOnProduct && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox(),
    );
  }
}
