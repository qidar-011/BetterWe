import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get lblGetStarted;

  String get lblNext;

  String get lblWelcomeBack;

  String get lblWelcomeBackDesc;

  String get lblLogin;

  String get lblEmail;

  String get lblEnterEmail;

  String get lblPassword;

  String get lblEnterPassword;

  String get lblRememberMe;

  String get lblForgotPassword;

  String get lblNewUser;

  String get lblHome;

  String get lblDiet;

  String get lblReport;

  String get lblProfile;

  String get lblAboutUs;

  String get lblBlog;

  String get lblChangePassword;

  String get lblEnterCurrentPwd;

  String get lblEnterNewPwd;

  String get lblCurrentPassword;

  String get lblNewPassword;

  String get lblConfirmPassword;

  String get lblEnterConfirmPwd;

  String get errorPwdLength;

  String get errorPwdMatch;

  String get lblSubmit;

  String get lblEditProfile;

  String get lblFirstName;

  String get lblEnterFirstName;

  String get lblEnterLastName;

  String get lblLastName;

  String get lblPhoneNumber;

  String get lblEnterPhoneNumber;

  String get lblEnterAge;

  String get lblAge;

  String get lblWeight;

  String get lblLbs;

  String get lblKg;

  String get lblEnterWeight;

  String get lblHeight;

  String get lblFeet;

  String get lblCm;

  String get lblEnterHeight;

  String get lblGender;

  String get lblSave;

  String get lblForgotPwdMsg;

  String get lblContinue;

  String get lblSelectLanguage;

  String get lblNoInternet;

  String get lblContinueWithPhone;

  String get lblRcvCode;

  String get lblYear;

  String get lblFavourite;

  String get lblSelectTheme;

  String get lblDeleteAccount;

  String get lblPrivacyPolicy;

  String get lblLogout;

  String get lblLogoutMsg;

  String get lblVerifyOTP;

  String get lblVerifyProceed;

  String get lblCode;

  String get lblTellUsAboutYourself;

  String get lblAlreadyAccount;

  String get lblWhtGender;

  String get lblMale;

  String get lblFemale;

  String get lblHowOld;

  String get lblLetUsKnowBetter;

  String get lblLight;

  String get lblDark;

  String get lblSystemDefault;

  String get lblStore;

  String get lblPlan;

  String get lblAboutApp;

  String get lblPasswordMsg;

  String get lblDelete;

  String get lblCancel;

  String get lblSettings;

  String get lblHeartRate;

  String get lblMonthly;

  String get lblNoFoundData;

  String get lblTermsOfServices;

  String get lblFollowUs;

  String get lblWorkouts;

  String get lblChatConfirmMsg;

  String get lblYes;

  String get lblNo;

  String get lblClearConversion;

  String get lblChatHintText;

  String get lblTapBackAgainToLeave;

  String get lblPro;

  String get lblCalories;

  String get lblCarbs;

  String get lblFat;

  String get lblProtein;

  String get lblKcal;

  String get lblIngredients;

  String get lblInstruction;

  String get lblStartExercise;

  String get lblDuration;

  String get lblBodyParts;

  String get lblEquipments;

  String get lblHomeWelMsg;

  String get lblBodyPartExercise;

  String get lblEquipmentsExercise;

  String get lblLevels;

  String get lblBuyNow;

  String get lblSearchExercise;

  String get lblAll;

  String get lblTips;

  String get lblDietCategories;

  String get lblSkip;

  String get lblWorkoutType;

  String get lblLevel;

  String get lblBmi;

  String get lblCopiedToClipboard;

  String get lblFullBodyWorkout;

  String get lblTypes;

  String get lblClearAll;

  String get lblSelectAll;

  String get lblShowResult;

  String get lblSelectLevels;

  String get lblUpdate;

  String get lblSteps;

  String get lblPackageTitle;

  String get lblPackageTitle1;

  String get lblSubscriptionPlans;

  String get lblSubscribe;

  String get lblActive;

  String get lblHistory;

  String get lblSubscriptionMsg;

  String get lblCancelSubscription;

  String get lblViewPlans;

  String get lblHey;

  String get lblRepeat;

  String get lblEveryday;

  String get lblReminderName;

  String get lblDescription;

  String get lblSearch;

  String get lblTopFitnessReads;

  String get lblTrendingBlogs;

  String get lblBestDietDiscoveries;

  String get lblDietaryOptions;

  String get lblFav;

  String get lblBreak;

  String get lblProductCategory;

  String get lblProductList;

  String get lblTipsInst;

  String get lblContactAdmin;

  String get lblOr;

  String get lblRegisterNow;

  String get lblDailyReminders;

  String get lblPayments;

  String get lblPay;

  String get lblAppThemes;

  String get lblTotalSteps;

  String get lblDate;

  String get lblDeleteAccountMSg;

  String get lblHint;

  String get lblAdd;

  String get lblNotifications;

  String get lblNotificationEmpty;

  String get lblQue1;

  String get lblQue2;

  String get lblQue3;

  String get lblFitBot;

  String get lblG;

  String get lblEnterText;

  String get lblYourPlanValid;

  String get lblTo;

  String get lblSets;

  String get lblSuccessMsg;

  String get lblPaymentFailed;

  String get lblSuccess;

  String get lblDone;

  String get lblWorkoutLevel;

  String get lblReps;

  String get lblSecond;

  String get lblFavoriteWorkoutAndNutristions;

  String get lblShop;

  String get lblDeleteMsg;

  String get lblSelectPlanToContinue;

  String get lblResultNoFound;

  String get lblExerciseNoFound;

  String get lblBlogNoFound;

  String get lblWorkoutNoFound;

  String get lblTenSecondRemaining;

  String get lblThree;

  String get lblTwo;

  String get lblOne;

  String get lblExerciseDone;

  String get lblMonth;

  String get lblDay;
}
