import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/widgets.dart';
import '../screens/no_data_screen.dart';
import '../screens/view_all_product_screen.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/text_styles.dart';
import '../components/product_category_component.dart';
import '../components/product_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/app_text_field.dart';
import '../extensions/decorations.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../models/product_category_response.dart';
import '../models/product_response.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';
import 'view_product_category_screen.dart';

class ProductScreen extends StatefulWidget {
  static String tag = '/ProductScreen';

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  TextEditingController mSearch = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode mSearchFocus = FocusNode();

  List<ProductCategoryModel>? mProductCategoryList = [];
  List<ProductModel>? mProductList = [];
  List<ProductModel>? mSearchProductList = [];

  bool _showClearButton = false;
  bool isLastPage = false;

  int page = 1;
  int? numPage;

  String? mSearchValue = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    getProductData();
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

  getProductData() async {
    appStore.setLoading(true);
    await getProductCategoryApi().then((value) {
      mProductCategoryList = value.data;
      setState(() {});
    }).catchError((e) {
      setState(() {});
    }).whenComplete(() async {
      getProductDataAPI();
    });
  }

  getProductDataAPI() async {
    await getProductApi(mSearch: mSearchValue).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mProductList!.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mProductList!.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
          icon: Icon(Feather.chevron_right, color: primaryColor),
        ),
      ],
    ).paddingSymmetric(vertical: 8);
  }

  Widget mStoreProductList() {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      children: List.generate(mProductList!.length, (index) {
        return ProductComponent(
          mProductModel: mProductList![index],
          onCall: () {
            getProductData();
            setState(() {});
          },
        );
      }),
    ).paddingSymmetric(horizontal: 16);
  }

  @override
  void dispose() {
    mSearch.clear();
    mSearch.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblShop, context: context, showBack: false, titleSpacing: 16),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    getProductDataAPI();
                    setState(() {});
                  },
                ).paddingSymmetric(horizontal: 16),
                mSearchValue.isEmptyOrNull
                    ? Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mHeading(languages.lblProductCategory, onCall: () {
                                ViewProductCategoryScreen().launch(context);
                              }),
                              HorizontalList(
                                physics: BouncingScrollPhysics(),
                                itemCount: mProductCategoryList!.length,
                                spacing: 16,
                                padding: EdgeInsets.only(left: 14, right: 16, bottom: 4),
                                itemBuilder: (context, index) {
                                  return ProductCategoryComponent(
                                    mProductCategoryModel: mProductCategoryList![index],
                                    onCall: () {
                                      getProductData();
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ],
                          ).visible(mProductCategoryList!.isNotEmpty),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mHeading(languages.lblProductList, onCall: () {
                                ViewAllProductScreen().launch(context);
                              }),
                              mStoreProductList()
                            ],
                          ).visible(mProductList!.isNotEmpty)
                        ],
                      )
                    : Stack(
                        children: [
                          mStoreProductList().paddingTop(16),
                          SizedBox(height: context.height() * 0.6, child: NoDataScreen(mTitle: languages.lblResultNoFound).visible(mProductList!.isEmpty).center().visible(!appStore.isLoading))
                        ],
                      ),
              ],
            ),
          ),
          Loader().visible(appStore.isLoading),
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
        mSearch.clear();
        mSearchValue = "";
        hideKeyboard(context);
        getProductDataAPI();
      },
      icon: Icon(Icons.clear),
    );
  }
}
