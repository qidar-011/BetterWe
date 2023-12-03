import 'package:flutter/material.dart';
import '../extensions/widgets.dart';
import '../main.dart';

import '../extensions/constants.dart';
import '../extensions/text_styles.dart';
import '../models/get_setting_response.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  SettingList? settingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblTermsOfServices, context: context),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: htmlWidget(context, userStore.termsCondition, textPrimaryColorGlobal, primaryTextStyle()),
          ),
        ],
      ),
    );
  }
}
