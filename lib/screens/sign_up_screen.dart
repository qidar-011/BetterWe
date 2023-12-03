import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../extensions/constants.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/system_utils.dart';
import '../../extensions/widgets.dart';
import '../../main.dart';
import '../extensions/colors.dart';
import '../utils/app_colors.dart';
import '../components/sign_up_step1_component.dart';
import '../components/sign_up_step2_component.dart';
import '../components/sign_up_step3_component.dart';
import '../components/sign_up_step4_component.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;

  SignUpScreen({this.phoneNumber});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? isNewTask = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    appStore.signUpIndex = 0;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (appStore.signUpIndex == 0) {
          appStore.setLoading(false);
          finish(context);
          return false;
        } else {
          isNewTask = false;
          appStore.signUpIndex--;
          setState(() {});
          return false;
        }
      },
      child: Observer(builder: (context) {
        return Scaffold(
          appBar: appBarWidget("",
              backWidget: Icon(
                Octicons.chevron_left,
                color: primaryColor,
                size: 28,
              ).onTap(() {
                if (appStore.signUpIndex == 0) {
                  finish(context);
                } else {
                  isNewTask = false;
                  appStore.signUpIndex--;
                  setState(() {});
                }
              }),
              color: whiteColor,
              elevation: 0,
              textColor: textPrimaryColorGlobal,
              context: context),
          body: Column(
            children: [
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (index) {
                  return Container(
                    alignment: Alignment.center,
                    height: 6,
                    width: context.width() / 4.5,
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: appStore.signUpIndex >= index ? primaryColor : GreyLightColor,
                    ),
                  );
                }).toList(),
              ).paddingSymmetric(horizontal: 12),
              16.height,
              if (appStore.signUpIndex == 0) SignUpStep1Component(isNewTask: isNewTask).expand(),
              if (appStore.signUpIndex == 1) SignUpStep2Component(isNewTask: isNewTask).expand(),
              if (appStore.signUpIndex == 2) SignUpStep3Component(isNewTask: isNewTask).expand(),
              if (appStore.signUpIndex == 3) SignUpStep4Component().expand(),
            ],
          ),
        );
      }),
    );
  }
}
