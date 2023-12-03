import 'package:flutter/material.dart';
import 'package:mighty_fitness/extensions/extension_util/context_extensions.dart';
import '../extensions/colors.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../models/language_data_model.dart';
import '../utils/app_config.dart';
import '../utils/app_images.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblSelectLanguage, context: context),
      body: AnimatedListView(
        itemCount: localeLanguageList.length,
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          LanguageDataModel data = localeLanguageList[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            margin: EdgeInsets.only(bottom: 16),
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE) == data.languageCode.validate()
                    ? primaryColor
                    : appStore.isDarkMode
                        ? context.scaffoldBackgroundColor
                        : cardLightColor,
                border: Border.all(color: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE) == data.languageCode.validate() ? primaryColor.withOpacity(0.80) : GreyLightColor)),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(data.flag.validate(), width: 32, fit: BoxFit.cover),
                    16.width,
                    Text(
                      '${data.name.validate()}',
                      style: boldTextStyle(
                          color: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE) == data.languageCode.validate()
                              ? Colors.white
                              : appStore.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                    ).expand(),
                    getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE) == data.languageCode.validate()
                        ? Image.asset(ic_radio_fill, height: 20, width: 20, color: Colors.white)
                        : Image.asset(ic_radio, height: 20, width: 20),
                  ],
                ),
                4.height,
                // Divider(),
              ],
            ).paddingSymmetric(vertical: 4).onTap(() async {
              setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
              selectedLanguageDataModel = data;
              appStore.setLanguage(data.languageCode!, context: context);
              finish(context, true);
              setState(() {});
            }),
          );
        },
      ),
    );
  }
}
