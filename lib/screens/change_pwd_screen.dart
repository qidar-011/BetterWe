import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../main.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/widgets.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';

class ChangePwdScreen extends StatefulWidget {
  @override
  _ChangePwdScreenState createState() => _ChangePwdScreenState();
}

class _ChangePwdScreenState extends State<ChangePwdScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  TextEditingController mOldCont = TextEditingController();
  TextEditingController mPassCont = TextEditingController();
  TextEditingController mConfirmPassCont = TextEditingController();

  FocusNode mOldFocus = FocusNode();
  FocusNode mPassFocus = FocusNode();
  FocusNode mConfirmPassFocus = FocusNode();

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

  Future<void> changePwd() async {
    hideKeyboard(context);
    if (mFormKey.currentState!.validate()) {
      Map req = {
        'old_password': mOldCont.text.trim(),
        'new_password': mPassCont.text.trim(),
      };
      appStore.setLoading(true);
      await changePwdApi(req).then((value) {
        setValue(PASSWORD, mPassCont.text);
        toast(value.message.validate());
        appStore.setLoading(false);
        finish(context);
      }).catchError((error) {
        log(error);
        appStore.setLoading(false);
        toast(error.toString());
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblChangePassword, context: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: mFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.height,
                  Text(languages.lblPasswordMsg, style: primaryTextStyle(size: 14)),
                  24.height,
                  Text(languages.lblCurrentPassword, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                  4.height,
                  AppTextField(
                    controller: mOldCont,
                    focus: mOldFocus,
                    nextFocus: mPassFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: defaultInputDecoration(context, label: languages.lblEnterCurrentPwd),
                    onFieldSubmitted: (c) {},
                  ),
                  16.height,
                  Text(languages.lblNewPassword, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                  4.height,
                  AppTextField(
                    controller: mPassCont,
                    focus: mPassFocus,
                    nextFocus: mConfirmPassFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: defaultInputDecoration(context, label: languages.lblEnterNewPwd),
                    onFieldSubmitted: (c) {},
                  ),
                  16.height,
                  Text(languages.lblConfirmPassword, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                  4.height,
                  AppTextField(
                    controller: mConfirmPassCont,
                    focus: mConfirmPassFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: defaultInputDecoration(context, label: languages.lblEnterConfirmPwd),
                    validator: (String? value) {
                      if (value!.isEmpty) return errorThisFieldRequired;
                      if (value.length < passwordLengthGlobal) return languages.errorPwdLength;
                      if (value.trim() != mPassCont.text.trim()) return languages.errorPwdMatch;
                      return null;
                    },
                    onFieldSubmitted: (c) {
                      changePwd();
                    },
                  ),
                  24.height,
                  AppButton(
                    text: languages.lblSubmit,
                    width: context.width(),
                    color: primaryColor,
                    onTap: () {
                      changePwd();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          ),
          Observer(
            builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            },
          )
        ],
      ),
    );
  }
}
