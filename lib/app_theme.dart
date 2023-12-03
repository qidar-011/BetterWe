import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../extensions/colors.dart';
import '../../extensions/decorations.dart';
import '../utils/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
      scaffoldBackgroundColor: whiteColor,
      primaryColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.black),
      dividerColor: viewLineColor,
      cardColor: cardLightColor,
      colorScheme: ColorScheme(
        primary: primaryColor,
        secondary: primaryColor,
        surface: Colors.white,
        background: Colors.white,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.redAccent,
        brightness: Brightness.light,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: radius(20), side: BorderSide(width: 1,color: primaryColor)),
        checkColor: MaterialStateProperty.all(Colors.white),
        fillColor: MaterialStateProperty.all(primaryColor),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ));

  static final ThemeData darkTheme = ThemeData(
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: scaffoldColorDark,
    iconTheme: IconThemeData(color: Colors.white),
    cardColor: cardDarkColor,
    colorScheme: ColorScheme(
      primary: primaryColor,
      secondary: primaryColor,
      surface: Colors.black,
      background: Colors.black,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.redAccent,
      brightness: Brightness.dark,
    ),
    dividerColor: Colors.white24,
    textTheme: GoogleFonts.interTextTheme(),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: radius(20), side: BorderSide(width: 1,color: primaryColor)),
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateProperty.all(primaryColor),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
