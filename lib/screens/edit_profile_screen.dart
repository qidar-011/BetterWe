import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/system_utils.dart';
import '../../main.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../models/user_response.dart';
import '../network/network_utils.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/app_images.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController mFNameCont = TextEditingController();
  TextEditingController mLNameCont = TextEditingController();
  TextEditingController mEmailCont = TextEditingController();
  TextEditingController mAgeCont = TextEditingController();
  TextEditingController mMobileNumberCont = TextEditingController();
  TextEditingController mWeightCont = TextEditingController();
  TextEditingController mHeightCont = TextEditingController();

  FocusNode mEmailFocus = FocusNode();
  FocusNode mFNameFocus = FocusNode();
  FocusNode mLNameFocus = FocusNode();
  FocusNode mMobileNumberFocus = FocusNode();
  FocusNode mAgeFocus = FocusNode();
  FocusNode mWeightFocus = FocusNode();
  FocusNode mHeightFocus = FocusNode();

  List<String> item = ["أنثي", "ذكر"];

  String mGender = "أنثي";
  int? mHeight;
  int? mWeight;

  XFile? image;
  String? profileImg = '';

  double inputValue = 0.0;

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
    mFNameCont.text = userStore.fName;
    mLNameCont.text = userStore.lName;
    mEmailCont.text = userStore.email;
    mAgeCont.text = userStore.age;
    mMobileNumberCont.text = userStore.phoneNo;
    mWeightCont.text = userStore.weight;
    profileImg = userStore.profileImage;
    mHeightCont.text = userStore.height;
    userStore.heightUnit == FEET ? mHeight = 0 : mHeight = 1;
    userStore.weightUnit == LBS ? mWeight = 0 : mWeight = 1;
  //  mGender = userStore.gender.isEmptyOrNull ? "أنثي" : userStore.gender.capitalizeFirstLetter();
    mGender =userStore.gender.capitalizeFirstLetter()=='Male'?'ذكر':userStore.gender.capitalizeFirstLetter()=='Female'? "أنثي":userStore.gender.isEmptyOrNull?"أنثي": userStore.gender.capitalizeFirstLetter() ;
    print('=================================mGender: $mGender');
  }

  Future save() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
    multiPartRequest.fields['id'] = userStore.userId.toString();
    multiPartRequest.fields['first_name'] = mFNameCont.text;
    multiPartRequest.fields['last_name'] = mLNameCont.text;
    multiPartRequest.fields['email'] = mEmailCont.text;
    multiPartRequest.fields['username'] = mEmailCont.text;
    multiPartRequest.fields['phone_number'] = mMobileNumberCont.text;
    multiPartRequest.fields['gender'] = mGender;
    multiPartRequest.fields['user_profile[age]'] = mAgeCont.text;
    multiPartRequest.fields['user_profile[weight]'] = mWeightCont.text;
    multiPartRequest.fields['user_profile[height]'] = mHeightCont.text;
    multiPartRequest.fields['user_profile[height_unit]'] = mHeight == 0 ? FEET : METRICS_CM;
    multiPartRequest.fields['user_profile[weight_unit]'] = mWeight == 0 ? LBS : METRICS_WEIGHT_UNIT;

    if (image != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', image!.path.toString()));
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        if ((data as String).isJson()) {
          UserResponse res = UserResponse.fromJson(jsonDecode(data));
          print(res.toJson().toString());

          await userStore.setUserEmail(res.data!.email.validate());
          await userStore.setFirstName(res.data!.firstName.validate());
          await userStore.setLastName(res.data!.lastName.validate());
          await userStore.setUsername(res.data!.username.validate());
          await userStore.setGender(res.data!.gender.validate());
          await userStore.setUserImage(res.data!.profileImage.validate());
          await userStore.setDisplayName(res.data!.displayName.validate());
          await userStore.setPhoneNo(res.data!.phoneNumber.validate());
          await userStore.setAge(res.data!.userProfile!.age.validate());
          await userStore.setHeight(res.data!.userProfile!.height.validate());
          await userStore.setHeightUnit(res.data!.userProfile!.heightUnit.validate());
          await userStore.setWeight(res.data!.userProfile!.weight.validate());
          await userStore.setWeightUnit(res.data!.userProfile!.weightUnit.validate());

          appStore.setLoading(false);
          finish(context, true);
          setState(() {});
        }
      },
      onError: (error) {
        log(multiPartRequest.toString());
        toast(error.toString());
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
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
      child: Text(value.toString(), style: secondaryTextStyle(color: mHeight == index ? Colors.white : textColor)),
    ).onTap(() {
      mHeight = index;
      hideKeyboard(context);
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
      child: Text(value!, style: secondaryTextStyle(color: mWeight == index ? Colors.white : textColor)),
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
  }

  void convertKgToLbs() {
    double a = double.parse(mWeightCont.text.isEmptyOrNull ? "0.0" : mWeightCont.text.validate()) * 2.2046;
    if (!mWeightCont.text.isEmptyOrNull) {
      mWeightCont.text = a.toStringAsFixed(2).toString();
    }
    mWeightCont.selection = TextSelection.fromPosition(TextPosition(offset: mWeightCont.text.length));
  }

  Future getImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {});
  }

  Widget profileImage() {
    if (image != null) {
      return Container(
        padding: EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(width: 2, color: primaryColor.withOpacity(0.5))),
        child: Image.file(File(image!.path), height: 90, width: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(65),
      );
    } else if (!profileImg.isEmptyOrNull) {
      return Container(
        padding: EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(width: 2, color: primaryColor.withOpacity(0.5))),
        child: cachedImage(profileImg, width: 90, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(65),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(width: 2, color: primaryColor.withOpacity(0.5))),
        child: CircleAvatar(maxRadius: 60, backgroundColor: Colors.white, backgroundImage: AssetImage(ic_logo)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Stack(
              children: [
                Container(height: context.height() * 0.4, color: primaryColor),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left, color: white, size: 28).onTap(() {
                        Navigator.pop(context);
                      }),
                      16.width,
                      Text(languages.lblEditProfile, style: boldTextStyle(size: 20, color: white)),
                    ],
                  ).paddingOnly(top: context.statusBarHeight + 16, left: 16, right: appStore.selectedLanguageCode == 'ar' ? 16 : 0),
                ),
                Container(
                  margin: EdgeInsets.only(top: context.height() * 0.2),
                  height: context.height() * 0.4,
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topRight: 16, topLeft: 16), backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : Colors.white),
                ),
                Column(children: [
                  16.height,
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      profileImage(),
                      Container(decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryOpacity), padding: EdgeInsets.all(6), child: Image.asset(ic_camera,color: primaryColor, height: 20, width: 20))
                          .onTap(() {
                        getImage();
                      }).visible(!getBoolAsync(IS_SOCIAL))
                    ],
                  ).paddingOnly(top: context.height() * 0.11).center(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Text(languages.lblFirstName, style: secondaryTextStyle()),
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
                      Text(languages.lblLastName, style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        controller: mLNameCont,
                        textFieldType: TextFieldType.NAME,
                        isValidationRequired: true,
                        focus: mLNameFocus,
                        nextFocus: mMobileNumberFocus,
                        suffix: mSuffixTextFieldIconWidget(ic_user),
                        decoration: defaultInputDecoration(context, label: languages.lblEnterLastName),
                      ),
                      16.height,
                      Text(languages.lblEmail, style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        controller: mEmailCont,
                        textFieldType: TextFieldType.EMAIL,
                        isValidationRequired: true,
                        focus: mEmailFocus,
                        readOnly: true,
                        nextFocus: mMobileNumberFocus,
                        suffix: mSuffixTextFieldIconWidget(ic_mail),
                        decoration: defaultInputDecoration(context, label: languages.lblEnterEmail),
                      ),
                      16.height,
                      Text(languages.lblPhoneNumber, style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        controller: mMobileNumberCont,
                        textFieldType: TextFieldType.PHONE,
                        isValidationRequired: true,
                        focus: mMobileNumberFocus,
                        readOnly: getBoolAsync(IS_OTP) != true ? false : true,
                        nextFocus: mAgeFocus,
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
                      ),
                      16.height,
                      Text(languages.lblAge, style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        controller: mAgeCont,
                        textFieldType: TextFieldType.NUMBER,
                        isValidationRequired: true,
                        focus: mAgeFocus,
                        nextFocus: mWeightFocus,
                        suffix: mSuffixTextFieldIconWidget(ic_user),
                        decoration: defaultInputDecoration(context, label: languages.lblEnterAge),
                      ),
                      16.height,
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages.lblWeight, style: secondaryTextStyle()),
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
                              // isValidationRequired: true,
                              focus: mWeightFocus,
                              nextFocus: mHeightFocus,
                              validator: (value) {
                                if (value!.length < 2) {
                                  return languages.lblEnterText;
                                }
                                return null;
                              },
                              suffix: Container(
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: appStore.isDarkMode ? context.cardColor : GreyLightColor,
                                ),
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
                            Text(languages.lblHeight, style: secondaryTextStyle()),
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
                              validator: (value) {
                                if (value!.length < 2) {
                                  return languages.lblEnterText;
                                }
                                return null;
                              },
                              focus: mHeightFocus,
                              suffix: Container(
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: appStore.isDarkMode ? context.cardColor : GreyLightColor,
                                ),
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
                          ],
                        ),
                      ),
                      16.height,
                      Text(languages.lblGender, style: secondaryTextStyle()),
                      4.height,
                      DropdownButtonFormField(
                        items: item
                            .map((value) => DropdownMenuItem<String>(
                                  child: Text(value, style: primaryTextStyle()),
                                  value: value,
                                ))
                            .toList(),
                        isExpanded: false,
                        isDense: true,
                        borderRadius: radius(),
                        decoration: defaultInputDecoration(context),
                        value: mGender,
                        onChanged: (String? value) {
                          setState(() {
                            mGender = value.validate();
                          });
                        },
                      ),
                      24.height,
                      AppButton(
                          text: languages.lblSave,
                          width: context.width(),
                          color: primaryColor,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              save();
                            }
                          }),
                      24.height,
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ])
              ],
            )),
            Observer(
              builder: (context) {
                return Loader().center().visible(appStore.isLoading);
              },
            )
          ],
        ),
      ),
    );
  }
}
