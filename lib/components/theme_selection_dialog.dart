import 'package:flutter/material.dart';
import 'package:mighty_fitness/extensions/common.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../utils/app_colors.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/app_constants.dart';

class ThemeSelectionDialog extends StatefulWidget {
  static String tag = '/ThemeSelectionDialog';

  @override
  ThemeSelectionDialogState createState() => ThemeSelectionDialogState();
}

class ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  List<String> themeModeList = [languages.lblLight, languages.lblDark, languages.lblSystemDefault];

  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            decoration: boxDecorationWithShadow(backgroundColor: primaryColor, borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages.lblSelectTheme, style: boldTextStyle(size: 20, color: Colors.white)).paddingLeft(12),
                CloseButton(color: Colors.white),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 8),
            itemCount: themeModeList.length,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile(
                value: index,
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                groupValue: currentIndex,
                activeColor: primaryColor,
                title: Text(themeModeList[index], style: primaryTextStyle()),
                onChanged: (dynamic val) {
                  currentIndex = val;
                  setValue(THEME_MODE_INDEX, val);
                  if (val == ThemeModeSystem) {
                    appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                  } else if (val == ThemeModeLight) {
                    appStore.setDarkMode(false);
                  } else if (val == ThemeModeDark) {
                    appStore.setDarkMode(true);
                  }
                  setState(() {});
                  afterBuildCreated(() {
                    finish(context);
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
