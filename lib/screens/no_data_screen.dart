import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import '../extensions/text_styles.dart';
import '../utils/app_images.dart';

class NoDataScreen extends StatefulWidget {
  static String tag = '/NoDataScreen';

  final String? mTitle;
  NoDataScreen({this.mTitle});
  @override
  NoDataScreenState createState() => NoDataScreenState();
}

class NoDataScreenState extends State<NoDataScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
          16.height,
          Text(widget.mTitle??languages.lblNoFoundData, style: boldTextStyle()),
        ],
      ).center(),
    );
  }
}
