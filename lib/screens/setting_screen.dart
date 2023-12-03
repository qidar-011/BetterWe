import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../utils/app_colors.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/widgets.dart';
import '../../screens/sign_in_screen.dart';
import '../components/theme_selection_dialog.dart';
import '../extensions/common.dart';
import '../extensions/confirmation_dialog.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';
import '../network/rest_api.dart';
import '../service/auth_service.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import 'change_pwd_screen.dart';
import 'language_screen.dart';

class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    hideKeyboard(context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future deleteAccount(BuildContext context) async {
    appStore.setLoading(true);
    await deleteUserAccountApi().then((value) async {
      await deleteUserFirebase().then((value) async {
        await logout(context).then((value) async {
          appStore.setLoading(false);
          await removeKey(EMAIL);
          await removeKey(PASSWORD);
          await removeKey(IS_REMEMBER);
          SignInScreen().launch(context, isNewTask: true);
        });
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: appBarWidget(languages.lblSettings, context: context),
          body: Column(
            children: [
              // mOption(ic_language, languages.lblSelectLanguage, () async{
              //   bool? res=await LanguageScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
              //   if(res==true){
              //     setState(() { });
              //   }
              // }),
              // Divider(height: 0),
              mOption(ic_theme, languages.lblAppThemes, () async {
                await showInDialog(context, shape: RoundedRectangleBorder(borderRadius: radius()), builder: (_) => ThemeSelectionDialog(), contentPadding: EdgeInsets.zero);
              }),
              Divider(height: 0),
              mOption(ic_change_password, languages.lblChangePassword, () {
                ChangePwdScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
              }).visible(!getBoolAsync(IS_SOCIAL)),
              //Divider(height: 0).visible(!getBoolAsync(IS_SOCIAL)),
              // mOption(ic_delete, languages.lblDeleteAccount, () async {
              //   await showConfirmDialogCustom(
              //     context,
              //     title: languages.lblDeleteMsg,
              //     dialogType: DialogType.DELETE,
              //     positiveText: languages.lblDelete,
              //     negativeText: languages.lblCancel,
              //     image: ic_delete,
              //     iconColor: primaryColor,
              //     primaryColor: primaryColor,
              //     onAccept: (c) async {
              //       await deleteAccount(context);
              //     },
              //   );
              // }),
            ],
          ),
        );
      }
    );
  }
}
