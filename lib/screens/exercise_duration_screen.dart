import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../models/exercise_detail_response.dart';
import '../components/count_down_progress_indicator.dart';
import '../extensions/widgets.dart';
import '../utils/app_colors.dart';
import 'chewie_screen.dart';

class ExerciseDurationScreen extends StatefulWidget {
  static String tag = '/ExerciseDurationScreen';
  final ExerciseDetailResponse? mExerciseModel;

  ExerciseDurationScreen(this.mExerciseModel);

  @override
  ExerciseDurationScreenState createState() => ExerciseDurationScreenState();
}

class ExerciseDurationScreenState extends State<ExerciseDurationScreen> {
  CountDownController mCountDownController = CountDownController();
  Duration? duration;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    init();
    flutterTts = FlutterTts();
  }

  init() async {
    //
    duration = parseDuration(widget.mExerciseModel!.data!.duration.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Duration parseDuration(String durationString) {
    List<String> components = durationString.split(':');

    int hours = int.parse(components[0]);
    int minutes = int.parse(components[1]);
    int seconds = int.parse(components[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.mExerciseModel!.data!.title.validate(), context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChewieScreen(widget.mExerciseModel!.data!.videoUrl.validate(), widget.mExerciseModel!.data!.exerciseImage.validate()).center(),
            34.height,
            SizedBox(
              height: 150,
              width: context.width(),
              child: CountDownProgressIndicator(
                controller: mCountDownController,
                strokeWidth: 15,
                valueColor: primaryColor,
                backgroundColor: primaryOpacity,
                initialPosition: 0,
                duration: widget.mExerciseModel!.data!.duration.isEmptyOrNull ? widget.mExerciseModel!.data!.duration!.toInt() : duration!.inSeconds,
                timeFormatter: (seconds) {
                  return Duration(seconds: seconds).toString().split('.')[0].padLeft(8, '0');
                },
                text: 'mm:ss',
                onComplete: () {
                  // toast("done");
                },
              ),
            ).center(),
            34.height,
          ],
        ).center(),
      ),
    );
  }
}
