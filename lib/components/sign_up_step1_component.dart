import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/shared_pref.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../screens/sign_in_screen.dart';
import '../../utils/app_images.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/app_constants.dart';

class SignUpStep1Component extends StatefulWidget {
  final bool? isNewTask;

  SignUpStep1Component({this.isNewTask = false});

  @override
  _SignUpStep1ComponentState createState() => _SignUpStep1ComponentState();
}

class _SignUpStep1ComponentState extends State<SignUpStep1Component> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  TextEditingController mFNameCont = TextEditingController();
  TextEditingController mLNameCont = TextEditingController();
  TextEditingController mEmailCont = TextEditingController();
  TextEditingController mPassCont = TextEditingController();
  TextEditingController mConfirmPassCont = TextEditingController();
  TextEditingController mMobileNumberCont = TextEditingController();

  FocusNode mEmailFocus = FocusNode();
  FocusNode mPassFocus = FocusNode();
  FocusNode mFNameFocus = FocusNode();
  FocusNode mLNameFocus = FocusNode();
  FocusNode mConfirmPassFocus = FocusNode();
  FocusNode mMobileNumberFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    if (widget.isNewTask != true) {
      mFNameCont.text = userStore.fName.validate();
      mLNameCont.text = userStore.lName.validate();
      mEmailCont.text = userStore.email.validate();
      mPassCont.text = userStore.password.validate();
      mMobileNumberCont.text = userStore.phoneNo.validate();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: mFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(languages.lblTellUsAboutYourself, style: boldTextStyle(size: 22)),
            16.height,
            Text(languages.lblFirstName, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            4.height,
            AppTextField(
              controller: mFNameCont,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              focus: mFNameFocus,
              nextFocus: mLNameFocus,
              suffix: mSuffixTextFieldIconWidget(ic_user),
              decoration: defaultInputDecoration(context, label: languages.lblEnterFirstName),
            ),
            16.height,
            Text(languages.lblLastName, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            4.height,
            AppTextField(
              controller: mLNameCont,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              focus: mLNameFocus,
              cursorColor: primaryColor,
              nextFocus: mMobileNumberFocus,
              suffix: mSuffixTextFieldIconWidget(ic_user),
              decoration: defaultInputDecoration(context, label: languages.lblEnterLastName),
            ),
            16.height,
            Text(languages.lblPhoneNumber, style: secondaryTextStyle(color: textPrimaryColorGlobal)).visible(getBoolAsync(IS_OTP) != true),
            4.height.visible(getBoolAsync(IS_OTP) != true),
            AppTextField(
              controller: mMobileNumberCont,
              textFieldType: TextFieldType.PHONE,
              isValidationRequired: true,
              focus: mMobileNumberFocus,
              nextFocus: mEmailFocus,
              suffix: mSuffixTextFieldIconWidget(ic_call),
              decoration: defaultInputDecoration(context,
                  label: languages.lblEnterPhoneNumber,
                  mPrefix: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CountryCodePicker(
                          initialSelection: countryCode,
                          showCountryOnly: false,
                          showFlag: false,
                          boxDecoration: BoxDecoration(borderRadius: radius(defaultRadius), color: context.scaffoldBackgroundColor),
                          showFlagDialog: true,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: primaryTextStyle(),
                          onInit: (c) {},
                          onChanged: (c) {},
                        ),
                        VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                        16.width,
                      ],
                    ),
                  )),
            ).visible(getBoolAsync(IS_OTP) != true),
            16.height.visible(getBoolAsync(IS_OTP) != true),
            Text(languages.lblEmail, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            4.height,
            AppTextField(
              controller: mEmailCont,
              textFieldType: TextFieldType.EMAIL,
              isValidationRequired: true,
              focus: mEmailFocus,
              nextFocus: mPassFocus,
              suffix: mSuffixTextFieldIconWidget(ic_mail),
              decoration: defaultInputDecoration(context, label: languages.lblEnterEmail),
            ),
            16.height.visible(getBoolAsync(IS_OTP) != true),
            Text(languages.lblPassword, style: secondaryTextStyle(color: textPrimaryColorGlobal)).visible(getBoolAsync(IS_OTP) != true),
            4.height.visible(getBoolAsync(IS_OTP) != true),
            AppTextField(
              controller: mPassCont,
              focus: mPassFocus,
              nextFocus: mConfirmPassFocus,
              textFieldType: TextFieldType.PASSWORD,
              keyboardType: TextInputType.visiblePassword,
              decoration: defaultInputDecoration(context, label: languages.lblEnterPassword),
              onFieldSubmitted: (c) {},
            ).visible(getBoolAsync(IS_OTP) != true),
            16.height.visible(getBoolAsync(IS_OTP) != true),
            Text(languages.lblConfirmPassword, style: secondaryTextStyle(color: textPrimaryColorGlobal)).visible(getBoolAsync(IS_OTP) != true),
            4.height.visible(getBoolAsync(IS_OTP) != true),
            AppTextField(
              controller: mConfirmPassCont,
              focus: mConfirmPassFocus,
              textFieldType: TextFieldType.PASSWORD,
              keyboardType: TextInputType.visiblePassword,
              decoration: defaultInputDecoration(context, label: languages.lblEnterConfirmPwd),
              onFieldSubmitted: (c) {},
              validator: (String? value) {
                if (value!.isEmpty) return errorThisFieldRequired;
                if (value.length < passwordLengthGlobal) return languages.errorPwdLength;
                if (value.trim() != mPassCont.text.trim()) return languages.errorPwdMatch;
                return null;
              },
            ).visible(getBoolAsync(IS_OTP) != true),
            24.height,
            AppButton(
              text: languages.lblNext,
              width: context.width(),
              color: primaryColor,
              onTap: () {
                if (mFormKey.currentState!.validate()) {
                  hideKeyboard(context);
                  userStore.setFirstName(mFNameCont.text);
                  userStore.setLastName(mLNameCont.text);
                  if (getBoolAsync(IS_OTP) != true) {
                    userStore.setPhoneNo(mMobileNumberCont.text);
                    userStore.setUserPassword(mPassCont.text);
                  }
                  userStore.setUserEmail(mEmailCont.text);
                  appStore.signUpIndex = 1;
                  setState(() {});
                }
              },
            ),
            24.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(languages.lblAlreadyAccount, style: primaryTextStyle()),
                GestureDetector(
                    child: Text(
                      languages.lblLogin,
                      style: primaryTextStyle(color: primaryColor),
                    ).paddingLeft(4),
                    onTap: () {
                      SignInScreen().launch(context);
                    })
              ],
            ),
            24.height,
          ],
        ).paddingAll(16),
      ),
    );
  }
}
