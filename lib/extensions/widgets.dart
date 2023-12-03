import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/web_view_screen.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/system_utils.dart';
import '../../extensions/text_styles.dart';
import '../utils/app_constants.dart';
import 'common.dart';
import 'confirmation_dialog.dart';
import 'constants.dart';
import 'loader_widget.dart';

/// show confirm dialog box
Future<bool?> showConfirmDialog<bool>(
  context,
  String title, {
  String positiveText = 'Yes',
  String negativeText = 'No',
  Color? buttonColor,
  Color? barrierColor,
  bool? barrierDismissible,
  Function? onAccept,
}) async {
  return showDialog(
    context: context,
    // barrierDismissible: barrierDismissible ?? false,
    builder: (_) => AlertDialog(
      title: Text(title.validate(), style: primaryTextStyle()),
      actions: <Widget>[
        SimpleDialogOption(
          child: Text(negativeText.validate(), style: secondaryTextStyle()),
          onPressed: () {
            finish(_, false);
          },
        ),
        SimpleDialogOption(
          onPressed: () {
            finish(_, true);

            onAccept?.call();
          },
          child: Text(
            positiveText.validate(),
            style: primaryTextStyle(color: buttonColor ?? Theme.of(_).primaryColor),
          ),
        ),
      ],
    ),
  );
}

/// show child widget in dialog
Future<T?> showInDialog<T>(
  BuildContext context, {
  Widget? title,
  @Deprecated('Use builder instead') Widget? child,
  Widget? Function(BuildContext)? builder,
  ShapeBorder? shape,
  TextStyle? titleTextStyle,
  EdgeInsetsGeometry? contentPadding,
  //bool scrollable = false,
  Color? backgroundColor,
  DialogAnimation dialogAnimation = DialogAnimation.DEFAULT,
  double? elevation,
  Color? barrierColor,
  //EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  List<Widget>? actions,
  bool barrierDismissible = true,
  bool hideSoftKeyboard = true,
  Duration? transitionDuration,
  Curve curve = Curves.easeInBack,
}) async {
  if (hideSoftKeyboard) hideKeyboard(context);

  return await showGeneralDialog<T>(
    context: context,
    barrierColor: barrierColor ?? Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    barrierLabel: '',
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration ?? 400.milliseconds,
    transitionBuilder: (_, animation, secondaryAnimation, c) {
      return dialogAnimatedWrapperWidget(
        animation: animation,
        dialogAnimation: dialogAnimation,
        curve: curve,
        child: AlertDialog(
          content: builder != null ? builder.call(_) : child,
          shape: shape ?? defaultDialogShape,
          title: title,
          titleTextStyle: titleTextStyle,
          contentPadding: contentPadding ?? EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          //scrollable: scrollable,
          backgroundColor: backgroundColor,
          elevation: elevation ?? defaultElevation.toDouble(),
          //insetPadding: insetPadding,
          actions: actions,
        ),
      );
    },
  );
}

/// Default AppBar
AppBar appBarWidget(String title,
    {@Deprecated('Use titleWidget instead') Widget? child,
    Widget? titleWidget,
    List<Widget>? actions,
    Color? color,
    bool center = false,
    Color? textColor,
    int textSize = 18,
    double titleSpacing = 2,
    bool showBack = true,
    bool isBottom = true,
    Color? shadowColor,
    double? elevation,
    Widget? backWidget,
    @Deprecated('Use systemOverlayStyle instead') Brightness? brightness,
    SystemUiOverlayStyle? systemUiOverlayStyle,
    TextStyle? titleTextStyle,
    PreferredSizeWidget? bottom,
    Widget? flexibleSpace,
    required BuildContext context}) {
  return AppBar(
    centerTitle: center,
    title: titleWidget ??
        Text(
          title,
          style: titleTextStyle ?? (boldTextStyle(color: appStore.isDarkMode ? Colors.white : Colors.black, size: textSize)),
        ),
    actions: actions ?? [],
    automaticallyImplyLeading: showBack,
    backgroundColor: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
    leading: showBack ? (backWidget ?? backIcon(context)) : null,
    shadowColor: shadowColor,
    elevation: elevation ?? defaultAppBarElevation,
    systemOverlayStyle: systemUiOverlayStyle ??
        SystemUiOverlayStyle(
          statusBarColor: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
          statusBarIconBrightness:appStore.isDarkMode ? Brightness.light: Brightness.dark,
          statusBarBrightness:appStore.isDarkMode ? Brightness.light: Brightness.light,
        ),
    bottom: bottom,
    titleSpacing: titleSpacing,
    flexibleSpace: flexibleSpace,
  );
}

Widget backIcon(BuildContext context) {
  return Icon(
    appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left,
    color: primaryColor,
    size: 28
  ).onTap(() {
    Navigator.pop(context);
  });
}

/// Handle error and loading widget when using FutureBuilder or StreamBuilder
Widget snapWidgetHelper<T>(
  AsyncSnapshot<T> snap, {
  Widget? errorWidget,
  Widget? loadingWidget,
  String? defaultErrorMessage,
  @Deprecated('Do not use this') bool checkHasData = false,
  Widget Function(String)? errorBuilder,
}) {
  if (snap.hasError) {
    log(snap.error);
    if (errorBuilder != null) {
      return errorBuilder.call(defaultErrorMessage ?? snap.error.toString());
    }
    return errorWidget ??
        Text(
          defaultErrorMessage ?? snap.error.toString(),
          style: primaryTextStyle(),
        ).center();
  } else if (!snap.hasData) {
    return loadingWidget ?? Loader();
  } else {
    return SizedBox();
  }
}

/// Returns true is snapshot is loading
bool isSnapshotLoading(AsyncSnapshot snap, {bool checkHasData = false}) {
  return snap.connectionState == ConnectionState.active || snap.connectionState == ConnectionState.waiting;
}

backArrow(BuildContext context) {
  return Icon(
    Icons.arrow_back_ios_new,
    color: primaryColor,
  ).onTap(() {
    finish(context);
  });
}

/// html widget
htmlWidget(BuildContext context, String postContent, Color color, TextStyle style) {
  return HtmlWidget(
    postContent,
    onErrorBuilder: (context, element, error) => Text('$element error: $error'),
    onLoadingBuilder: (context, element, loadingProgress) => CircularProgressIndicator(),
    onTapUrl: (p0) {
      WebViewScreen(mInitialUrl: p0.validate()).launch(context);
      return true;
    },
    renderMode: RenderMode.column,
    textStyle: style,
  );
}

class PriceWidget extends StatefulWidget {
  static String tag = '/PriceWidget';
  var price;
  double? size = 22.0;
  Color? color;
  TextStyle? textStyle;

  PriceWidget({Key? key, this.price, this.color, this.size, this.textStyle}) : super(key: key);

  @override
  PriceWidgetState createState() => PriceWidgetState();
}

class PriceWidgetState extends State<PriceWidget> {
  var currency = '₹';

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    setState(() {
      currency = getStringAsync(CurrencySymbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userStore.currencyPosition == "left") {
      return Text('$currency ${widget.price.toString().replaceAll(".00", "")}',
          style: widget.textStyle ?? GoogleFonts.inter(fontSize: widget.size, color: widget.color != null ? widget.color : primaryColor, fontWeight: FontWeight.w600));
    } else {
      return Text('${widget.price.toString().replaceAll(".00", "")} $currency',
          style: widget.textStyle ?? GoogleFonts.inter(fontSize: widget.size, color: widget.color != null ? widget.color : primaryColor, fontWeight: FontWeight.w600));
    }
  }
}
