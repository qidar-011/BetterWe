import 'package:flutter/material.dart';
import '../extensions/widgets.dart';
import '../main.dart';

import '../extensions/constants.dart';
import '../extensions/text_styles.dart';
import '../models/get_setting_response.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  SettingList? settingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblPrivacyPolicy, context: context),
      body: Column(
        children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 16), child: htmlWidget(context, userStore.privacyPolicy, textPrimaryColorGlobal, primaryTextStyle())),
        ],
      ),
    );
  }
}
