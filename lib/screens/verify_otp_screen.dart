import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/otp_text_field.dart';
import '../extensions/app_button.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';
import 'dashboard_screen.dart';
import 'sign_up_screen.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String? verificationId;
  final String? phoneNumber;
  final String? mobileNo;
  final bool? isCodeSent;
  final PhoneAuthCredential? credential;

  VerifyOTPScreen({this.verificationId, this.isCodeSent, this.phoneNumber, this.mobileNo, this.credential});

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String otpCode = '';

  Future<void> submit() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    AuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: otpCode);

    await FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
      Map req = {
        "email": "",
        "username": widget.phoneNumber!.replaceAll('+', ''),
        "first_name": "",
        "last_name": "",
        "login_type": LoginTypeOTP,
        "user_type": LoginUser,
        "accessToken": widget.phoneNumber!.replaceAll('+', ''),
        "phone_number": widget.phoneNumber!.replaceAll('+', ''),
        'player_id': getStringAsync(PLAYER_ID).validate(),
      };

      await socialOtpLogInApi(req).then((value) async {
        await setValue(IS_OTP, true);
        await setValue(IS_SOCIAL, true);
        userStore.setPhoneNo(widget.phoneNumber!.replaceAll('+', ''));
        userStore.setUserPassword(widget.phoneNumber!.replaceAll('+', ''));
        await removeKey(IS_REMEMBER);
        appStore.setLoading(false);
        print(widget.phoneNumber!.replaceAll('+', ''));
        if (value.isUserExist == false) {
          finish(context);
          SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', '')).launch(context);
        } else {
          await setValue(TOKEN, value.data!.apiToken.validate());
          userStore.setToken(value.data!.apiToken.validate());
          await getUSerDetail(context, value.data!.id.validate()).whenComplete(() {
            DashboardScreen().launch(context, isNewTask: true);
          });
        }
      }).catchError((e) {
        appStore.setLoading(false);
        if (e.toString().contains('invalid_username')) {
          finish(context);
          SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', '')).launch(context);
        } else {
          toast(e.toString());
        }
        setState(() {});
      });
    }).catchError((e) {
      log("e===" + e.toString());
      toast(e.toString());
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void initState() {
    appStore.setLoading(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", context: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.lblVerifyOTP, style: boldTextStyle(size: 22)),
                Text('${languages.lblCode} ${widget.phoneNumber!}', style: secondaryTextStyle()),
                30.height,
                OTPTextField(
                  pinLength: 6,
                  fieldWidth: context.width() * 0.1,
                  onChanged: (s) {
                    otpCode = s;
                  },
                  onCompleted: (pin) {
                    otpCode = pin;
                    submit();
                  },
                ).center(),
                30.height,
                AppButton(
                  text: languages.lblVerifyProceed,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    submit();
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
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
