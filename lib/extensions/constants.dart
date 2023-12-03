import 'package:flutter/material.dart';
import '../../extensions/extension_util/int_extensions.dart';
import 'colors.dart';
import 'common.dart';

int defaultElevation = 4;
double defaultRadius = 12.0;
double defaultBlurRadius = 8.0;
double defaultSpreadRadius = 5;
double defaultAppBarElevation = 0.0;

double tabletBreakpointGlobal = 600.0;
double desktopBreakpointGlobal = 720.0;

Color? defaultInkWellSplashColor;
Color? defaultInkWellHoverColor;
Color? defaultInkWellHighlightColor;
double? defaultInkWellRadius;
Color defaultLoaderBgColorGlobal = Colors.white;
Color? defaultLoaderAccentColorGlobal;

Color textPrimaryColorGlobal = textPrimaryColor;
Color textSecondaryColorGlobal = dividerDarkColor;
double textBoldSizeGlobal = 16;
double textPrimarySizeGlobal = 16;
double textSecondarySizeGlobal = 14;
String? fontFamilyBoldGlobal;
String? fontFamilyPrimaryGlobal;
String? fontFamilySecondaryGlobal;
FontWeight fontWeightBoldGlobal = FontWeight.bold;
FontWeight fontWeightPrimaryGlobal = FontWeight.normal;
FontWeight fontWeightSecondaryGlobal = FontWeight.normal;
bool enableAppButtonScaleAnimationGlobal = true;
bool forceEnableDebug = false;

int? appButtonScaleAnimationDurationGlobal;
ShapeBorder? defaultAppButtonShapeBorder;

double defaultAppButtonRadius = 10.0;
double defaultAppButtonElevation = 4.0;
PageRouteAnimation? pageRouteAnimationGlobal= PageRouteAnimation.Fade;
Duration pageRouteTransitionDurationGlobal = 400.milliseconds;

int passwordLengthGlobal = 6;

// var errorSomethingWentWrong = 'Something Went Wrong';
// var errorThisFieldRequired = 'This field is required';
// var errorInternetNotAvailable = 'Your internet is not working';
// var errorNotAllow = 'Sorry, You are not allowed';
// var errorMessage = 'Please try again';
var errorSomethingWentWrong = 'يبدو أن هناك مشكلة. يرجى المحاولة مرة أخرى لاحقًا.';
var errorThisFieldRequired = 'هذا الحقل مطلوب';
var errorInternetNotAvailable = 'تعذر الاتصال بالإنترنت. يرجى التحقق من إعدادات الشبكة.';
var errorNotAllow = 'هذا المحتوى غير متاح لك حاليًا.';

const playStoreBaseURL = 'https://play.google.com/store/apps/details?id=';
const appStoreBaseURL = 'https://apps.apple.com/in/app/';

const SELECTED_LANGUAGE_CODE = 'selected_language_code';
const THEME_MODE_INDEX = 'theme_mode_index';

var errorMessage = 'حاول مرة اخرى';


var customDialogHeight = 0.0;
var customDialogWidth = 250.0;


const MAIL_TO_PREFIX = 'mailto:';
const TEL_PREFIX = 'tel:';

const facebookBaseURL = 'https://www.facebook.com/';
const instagramBaseURL = 'https://www.instagram.com/';
const linkedinBaseURL = 'https://www.linkedin.com/in/';
const twitterBaseURL = 'https://twitter.com/';
const youtubeBaseURL = 'https://www.youtube.com/';
const redditBaseURL = 'https://reddit.com/r/';
const telegramBaseURL = 'https://t.me/';
const facebookMessengerURL = 'https://m.me/';
const whatsappURL = 'https://wa.me/';
const googleDriveURL = 'https://docs.google.com/viewer?url=';

const spacingControlHalf = 2;
const spacingControl = 4;
const spacingStandard = 8;
const spacingStandardNew = 16;
const spacingMedium = 20;
const spacingLarge = 26;
const spacingXL = 30;
const spacingXXL = 34;

ShapeBorder? defaultDialogShape;

