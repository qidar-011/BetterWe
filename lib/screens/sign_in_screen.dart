import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../main.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/forgot_pwd_screen.dart';
import '../../screens/otp_screen.dart';
import '../../screens/sign_up_screen.dart';
import '../../utils/app_images.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/device_extensions.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../network/rest_api.dart';
import '../service/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/app_constants.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  TextEditingController mEmailCont = TextEditingController();
  TextEditingController mPassCont = TextEditingController();

  FocusNode mEmailFocus = FocusNode();
  FocusNode mPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    if (getBoolAsync(IS_REMEMBER)) {
      mEmailCont.text = getStringAsync(EMAIL);
      mPassCont.text = getStringAsync(PASSWORD);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> save() async {
    hideKeyboard(context);
    Map<String, dynamic> req = {
      'email': mEmailCont.text.trim(),
      'user_type': LoginUser,
      'password': mPassCont.text.trim(),
      'player_id': getStringAsync(PLAYER_ID).validate(),
    };

    if (mFormKey.currentState!.validate()) {
      appStore.setLoading(true);
      await logInApi(req).then((value) async {
        updatePlayerId();
        if (value.data!.status == statusActive) {
          if (getBoolAsync(IS_REMEMBER)) {
            userStore.setUserPassword(mPassCont.text.trim());
          }
          getUSerDetail(context, value.data!.id).then((value) {
            DashboardScreen().launch(context, isNewTask: true);
          }).catchError((e) {
            print("error=>" + e.toString());
          });
        } else {
          toast(languages.lblContactAdmin);
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
      setState(() {});
    }
  }

  googleLogin() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await signInWithGoogle().then((user) async {
      print(user);
      setValue(IS_SOCIAL, true);
      await userStore.setUserEmail(user.email.validate());
      await userStore.setUsername(user.email.validate());
      await userStore.setUserImage(user.photoURL.validate());
      await userStore.setDisplayName(user.displayName.validate());
      await userStore.setPhoneNo(user.phoneNumber.validate());
      updatePlayerId();
      appStore.setLoading(false);
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  appleLogin() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await appleLogIn().then((value) {
      setValue(IS_SOCIAL, true);
      appStore.setLoading(false);
      updatePlayerId();
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Widget mSocialWidget(String icon, Function onCall) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: socialBackground, boxShape: BoxShape.circle),
      child: Image.asset(icon, height: 40, width: 40),
    ).onTap(() {
      onCall.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: Observer(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(top: context.statusBarHeight + 16),
                child: Form(
                  key: mFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languages.lblLogin, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
                      Container(
                        width: 40,
                        height: 2,
                        decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor),
                        margin: EdgeInsets.only(top: 4),
                      ).paddingSymmetric(horizontal: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(languages.lblWelcomeBack, style: boldTextStyle(size: 20)),
                              Text(languages.lblWelcomeBackDesc, style: secondaryTextStyle()),
                            ],
                          ),
                          Image.asset(ic_login_new, height: 100, width: 100, fit: BoxFit.fill, opacity: AlwaysStoppedAnimation(.5))
                        ],
                      ).paddingOnly(left: 16),
                      16.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
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
                          16.height,
                          Text(languages.lblPassword, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                          4.height,
                          AppTextField(
                            controller: mPassCont,
                            focus: mPassFocus,
                            textFieldType: TextFieldType.PASSWORD,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: defaultInputDecoration(context, label: languages.lblEnterPassword),
                            onFieldSubmitted: (c) {
                              save();
                            },
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      fillColor: MaterialStatePropertyAll(getBoolAsync(IS_REMEMBER) ? primaryColor : Colors.transparent),
                                      shape: RoundedRectangleBorder(borderRadius: radius(4)),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      focusColor: primaryColor,
                                      side: BorderSide(color: primaryColor),
                                      activeColor: primaryColor,
                                      value: getBoolAsync(IS_REMEMBER),
                                      onChanged: (bool? value) async {
                                        await setValue(IS_REMEMBER, value);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  6.width,
                                  Text(languages.lblRememberMe, style: secondaryTextStyle(color: primaryColor)),
                                ],
                              ).expand(),
                              Text(languages.lblForgotPassword, style: secondaryTextStyle(color: primaryColor)).onTap(() {
                                ForgotPwdScreen().launch(context);
                              }, hoverColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                            ],
                          ),
                          60.height,
                          // Row(
                          //   children: [
                          //     Container(width: context.width() * 0.4, height: 1, color: context.dividerColor),
                          //     Text(languages.lblOr, style: secondaryTextStyle()).paddingSymmetric(horizontal: 10),
                          //     Container(width: context.width() * 0.4, height: 1, color: context.dividerColor),
                          //   ],
                          // ),
                          // 24.height,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     mSocialWidget(ic_mobile, () {
                          //       OTPScreen().launch(context);
                          //     }).visible(ENABLE_OTP),
                          //     12.width,
                          //     mSocialWidget(ic_google, () {
                          //       googleLogin();
                          //     }).visible(ENABLE_GOOGLE_SIGN_IN),
                          //     12.width,
                          //     mSocialWidget(ic_apple, () {
                          //       appleLogin();
                          //     }).visible(ENABLE_APPLE_SIGN_IN && isIOS),
                          //   ],
                          // ).visible(ENABLE_SOCIAL_LOGIN),
                          // ENABLE_SOCIAL_LOGIN ? 24.height : 0.height,
                          AppButton(
                            text: languages.lblLogin,
                            width: context.width(),
                            color: primaryColor,
                            onTap: () {
                              save();
                            },
                          ),
                          24.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(languages.lblNewUser, style: primaryTextStyle()),
                              GestureDetector(
                                  child: Text(languages.lblRegisterNow, style: primaryTextStyle(color: primaryColor)).paddingLeft(4),
                                  onTap: () {
                                    SignUpScreen().launch(context);
                                  })
                            ],
                          ),
                          24.height,
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 4),
                    ],
                  ),
                ),
              ),
              Loader().center().visible(appStore.isLoading)
            ],
          );
        }),
      ),
    );
  }
}
