import 'package:flutter/material.dart';
import 'package:mighty_fitness/extensions/extension_util/context_extensions.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import 'package:pedometer/pedometer.dart';
import '../extensions/decorations.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';

class StepCountComponent extends StatefulWidget {
  static String tag = '/StepCountComponent';

  @override
  StepCountComponentState createState() => StepCountComponentState();
}

class StepCountComponentState extends State<StepCountComponent> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  String _status = '?', _steps = '0';

  bool? isError = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      isError = true;
      _steps = 'Not Supported';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius(16),backgroundColor: context.cardColor):boxDecorationRoundedWithShadow(16,backgroundColor: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: appStore.isDarkMode ? Colors.black : Colors.white),
                padding: EdgeInsets.all(6),
                child: Image.asset(ic_step, width: 22, height: 22, color: primaryColor),
              ),
              Text(languages.lblSteps, style: boldTextStyle(size: 18, color: appStore.isDarkMode ? primaryColor : black)),
            ],
          ),
          12.height,
          Image.asset(ic_running, height: 60, color: primaryColor).center(),
          12.height,
          isError == true ? Text(_steps, style: secondaryTextStyle()).paddingSymmetric(vertical: 8).center() : Text(_steps, style: boldTextStyle(size: 22)).center(),
          Text(languages.lblTotalSteps, style: secondaryTextStyle()).center().visible(isError != true)
        ],
      ),
    );
  }
}
