import 'package:flutter/material.dart';

DateTime? _currentBackPressTime;

/// DoublePressBackWidget
class DoublePressBackWidget extends StatelessWidget {
  final Widget child;
  final String? message;
  final WillPopCallback? onWillPop;

  DoublePressBackWidget({
    Key? key,
    required this.child,
    this.message,
    this.onWillPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () {
        DateTime now = DateTime.now();

        onWillPop?.call();
        if (_currentBackPressTime == null ||
            now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
          _currentBackPressTime = now;
         // snackBar(message ?? 'Press back again to exit');

          return Future.value(false);
        }
        return Future.value(true);
      },
    );
  }
}
