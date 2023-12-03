import 'package:flutter/material.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../main.dart';
import '../../screens/dashboard_screen.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../models/register_request.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';

class SignUpStep4Component extends StatefulWidget {
  @override
  _SignUpStep4ComponentState createState() => _SignUpStep4ComponentState();
}

class _SignUpStep4ComponentState extends State<SignUpStep4Component> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  TextEditingController mWeightCont = TextEditingController();
  TextEditingController mHeightCont = TextEditingController();

  FocusNode mWeightFocus = FocusNode();
  FocusNode mHeightFocus = FocusNode();

  int? mHeight = 0;
  int? mWeight = 0;

  double? mFeetValue = 0.0328084;
  double? mCMValue = 30.48;

  bool isKGClicked = false;
  bool isLBSClicked = false;
  bool isFeetClicked = false;
  bool isCMClicked = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    mWeightCont.text = userStore.weight.validate();
    mHeightCont.text = userStore.height.validate();

    mWeight = userStore.weightUnit == LBS ? 0 : 1;
    mHeight = userStore.heightUnit == FEET ? 0 : 1;

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mHeightOption(String? value, int? index) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(6),
          backgroundColor: mHeight == index
              ? primaryColor
              : appStore.isDarkMode
                  ? context.cardColor
                  : GreyLightColor),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(value!, style: secondaryTextStyle(color: mHeight == index ? Colors.white : textSecondaryColorGlobal)),
    ).onTap(() {
      hideKeyboard(context);
      mHeight = index;
      if (index == 1) {
        if (!isFeetClicked) {
          convertFeetToCm();
          isFeetClicked = true;
          isCMClicked = false;
        }
      } else {
        if (!isCMClicked) {
          convertCMToFeet();
          isCMClicked = true;
          isFeetClicked = false;
        }
      }
      setState(() {});
    });
  }

  //Convert Feet to Cm
  void convertFeetToCm() {
    double a = double.parse(mHeightCont.text.isEmptyOrNull ? "0.0" : mHeightCont.text.validate()) * 30.48;
    if (!mHeightCont.text.isEmptyOrNull) {
      mHeightCont.text = a.toStringAsFixed(2).toString();
    }
    mHeightCont.selection = TextSelection.fromPosition(TextPosition(offset: mHeightCont.text.length));
    print(a.toStringAsFixed(2).toString());
  }

  //Convert CM to Feet
  void convertCMToFeet() {
    double a = double.parse(mHeightCont.text.isEmptyOrNull ? "0.0" : mHeightCont.text.validate()) * 0.0328;
    if (!mHeightCont.text.isEmptyOrNull) {
      mHeightCont.text = a.toStringAsFixed(2).toString();
    }
    mHeightCont.selection = TextSelection.fromPosition(TextPosition(offset: mHeightCont.text.length));
    print(a.toStringAsFixed(2).toString());
  }

  Widget mWeightOption(String? value, int? index) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(6),
          backgroundColor: mWeight == index
              ? primaryColor
              : appStore.isDarkMode
                  ? context.cardColor
                  : GreyLightColor),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(value!, style: secondaryTextStyle(color: mWeight == index ? Colors.white : textSecondaryColorGlobal)),
    ).onTap(() {
      mWeight = index;
      hideKeyboard(context);
      if (index == 0) {
        if (!isLBSClicked) {
          convertKgToLbs();
          isLBSClicked = true;
          isKGClicked = false;
        }
      } else {
        if (!isKGClicked) {
          convertLbsToKg();
          isKGClicked = true;
          isLBSClicked = false;
        }
      }
      setState(() {});
    });
  }

//Convert lbs to kg
  void convertLbsToKg() {
    double a = double.parse(mWeightCont.text.isEmptyOrNull ? "0.0" : mWeightCont.text.validate()) * 0.45359237;
    if (!mWeightCont.text.isEmptyOrNull) {
      mWeightCont.text = a.toStringAsFixed(2).toString();
    }
    mWeightCont.selection = TextSelection.fromPosition(TextPosition(offset: mWeightCont.text.length));
    print(a.toStringAsFixed(2).toString());
  }

  void convertKgToLbs() {
    double a = double.parse(mWeightCont.text.isEmptyOrNull ? "0.0" : mWeightCont.text.validate()) * 2.2046;
    if (!mWeightCont.text.isEmptyOrNull) {
      mWeightCont.text = a.toStringAsFixed(2).toString();
    }
    mWeightCont.selection = TextSelection.fromPosition(TextPosition(offset: mWeightCont.text.length));
    print(a.round().toString());
  }

  Future<void> saveData() async {
    hideKeyboard(context);
    UserProfile userProfile = UserProfile();
    userProfile.age = userStore.age.toInt();
    userProfile.heightUnit = userStore.heightUnit.validate();
    userProfile.height = userStore.height.validate();
    userProfile.weight = userStore.weight.validate();
    userProfile.weightUnit = userStore.weightUnit.validate();
    Map<String, dynamic> req;
    if(getBoolAsync(IS_OTP) != true){
       req = {
        'first_name': userStore.fName.validate(),
        'last_name': userStore.lName.validate(),
        'username': userStore.email.validate(),
        'email': userStore.email.validate(),
        'password': userStore.password.validate(),
        'user_type': LoginUser,
        'status': statusActive,
        'phone_number': userStore.phoneNo.validate(),
        'gender': userStore.gender.validate(),
        'user_profile': userProfile,
        "player_id": getStringAsync(PLAYER_ID).validate(),
      };
    }
    else{
      req = {
        'first_name': userStore.fName.validate(),
        'last_name': userStore.lName.validate(),
        'username': userStore.phoneNo.validate(),
        'email': userStore.email.validate(),
        'password': userStore.password.validate(),
        'user_type': LoginUser,
        'status': statusActive,
        'phone_number': userStore.phoneNo.validate(),
        'gender': userStore.gender.validate(),
        'user_profile': userProfile,
        "player_id": getStringAsync(PLAYER_ID).validate(),
        "login_type": LoginTypeOTP,
      };
    }

    appStore.setLoading(true);
    await registerApi(req).then((value) async {
      appStore.setLoading(false);
      userStore.setLogin(true);
      userStore.setToken(value.data!.apiToken.validate());
      getUSerDetail(context, value.data!.id).then((value) {
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        print("error=>" + e.toString());
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: mFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.lblLetUsKnowBetter, style: boldTextStyle(size: 22)),
                24.height,
                Text(languages.lblWeight, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                4.height,
                AppTextField(
                  onChanged: (_) {
                    setState(() {
                      isLBSClicked = false;
                      isKGClicked = false;
                    });
                  },
                  controller: mWeightCont,
                  textFieldType: TextFieldType.NUMBER,
                  isValidationRequired: true,
                  focus: mWeightFocus,
                  nextFocus: mHeightFocus,
                  suffix: Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? context.cardColor : GreyLightColor),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        mWeightOption(languages.lblLbs, 0),
                        4.width,
                        mWeightOption(languages.lblKg, 1),
                      ],
                    ),
                  ),
                  decoration: defaultInputDecoration(context, label: languages.lblEnterWeight),
                ),
                16.height,
                Text(languages.lblHeight, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                4.height,
                AppTextField(
                  onChanged: (_) {
                    setState(() {
                      isFeetClicked = false;
                      isCMClicked = false;
                    });
                  },
                  controller: mHeightCont,
                  textFieldType: TextFieldType.NUMBER,
                  isValidationRequired: true,
                  focus: mHeightFocus,
                  suffix: Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? context.cardColor : GreyLightColor),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        mHeightOption(languages.lblFeet, 0),
                        4.width,
                        mHeightOption(languages.lblCm, 1),
                      ],
                    ),
                  ),
                  decoration: defaultInputDecoration(context, label: languages.lblEnterHeight),
                ),
                24.height,
                AppButton(
                  text: languages.lblDone,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    if (mFormKey.currentState!.validate()) {
                      userStore.setHeight(mHeightCont.text.validate());
                      userStore.setWeight(mWeightCont.text.validate());
                      userStore.setWeightUnit(mWeight == 0 ? LBS : METRICS_WEIGHT_UNIT);
                      userStore.setHeightUnit(mHeight == 0 ? FEET : METRICS_CM);
                      saveData();
                      setState(() {});
                    }
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ),
        Loader().visible(appStore.isLoading)
      ],
    );
  }
}
