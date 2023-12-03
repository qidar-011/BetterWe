import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../screens/web_view_screen.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../models/product_response.dart';
import '../extensions/app_button.dart';
import '../extensions/decorations.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';

class ProductDetailScreen extends StatefulWidget {
  static String tag = '/productDetailScreen';
  final ProductModel? productModel;

  ProductDetailScreen({this.productModel});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (showAdOnProductDetail) loadInterstitialAds();
  }

  @override
  void dispose() {
    if (showAdOnProductDetail) showInterstitialAds();
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
        statusBarIconBrightness: appStore.isDarkMode ? Brightness.dark : Brightness.dark,
        systemNavigationBarIconBrightness: appStore.isDarkMode ? Brightness.dark : Brightness.dark,
      ),
      child: Scaffold(
        bottomNavigationBar: AppButton(
          text: languages.lblBuyNow,
          width: context.width(),
          color: primaryColor,
          onTap: () {
            WebViewScreen(mInitialUrl: widget.productModel!.affiliateLink.toString()).launch(context);
          },
        ).paddingSymmetric(horizontal: 16, vertical: 12),
        body: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              child: Stack(
                children: [
                  cachedImage(widget.productModel!.productImage.validate(), width: context.width(), height: context.height() * 0.38, fit: BoxFit.fill),
                  Positioned(
                    top: context.statusBarHeight,
                    child: IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon: Icon(appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left, color: primaryColor, size: 28),
                    ),
                  ),
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    16.height,
                    Text(widget.productModel!.title.validate(), style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
                    8.height,
                    PriceWidget(
                      price: widget.productModel!.price.validate().toString(),
                      color: primaryColor,
                      textStyle: boldTextStyle(color: primaryColor, size: 20),
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    Divider(color: appStore.isDarkMode ? Colors.white : context.dividerColor, indent: 16, endIndent: 16),
                    8.height,
                    Container(child: htmlWidget(context, widget.productModel!.description.toString(), appStore.isDarkMode ? Colors.white : socialBackground, primaryTextStyle())).paddingSymmetric(horizontal: 16),
                    80.height,
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
