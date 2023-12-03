import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../main.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/list_extensions.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../models/exercise_detail_response.dart';
import '../components/count_down_progress_indicator1.dart';
import '../extensions/time_formatter.dart';
import '../extensions/widgets.dart';
import '../models/models.dart';
import 'chewie_screen.dart';

class ExerciseDurationScreen1 extends StatefulWidget {
  static String tag = '/ExerciseDurationScreen';
  final ExerciseDetailResponse? mExerciseModel;

  ExerciseDurationScreen1(this.mExerciseModel);

  @override
  ExerciseDurationScreen1State createState() => ExerciseDurationScreen1State();
}

class ExerciseDurationScreen1State extends State<ExerciseDurationScreen1> {
  CountDownController1 mCountDownController1 = CountDownController1();

  Duration? duration;
  late FlutterTts flutterTts;
  int i = 0;
  int? mLength;
  Workout? _workout;
  Tabata? _tabata;

  List<String>? mExTime = [];
  List<String>? mRestTime = [];

  @override
  initState() {
    super.initState();
    widget.mExerciseModel!.data!.sets!.forEachIndexed((element, index) {
      mExTime!.add(element.time.toString());
      mRestTime!.add(element.rest.toString());
      setState(() {});
    });

    _tabata = Tabata(
        sets: 1,
        reps: widget.mExerciseModel!.data!.sets!.length,
        startDelay: Duration(seconds: 3),
        exerciseTime: mExTime,
        restTime: mRestTime,
        breakTime: Duration(seconds: 60),
        status: widget.mExerciseModel!.data!.based == "reps" ? "reps" : "second");
    init();
    flutterTts = FlutterTts();
    flutterTts.awaitSpeakCompletion(true);
  }

  init() async {
    //
    mLength = widget.mExerciseModel!.data!.sets!.length - 1;
    _workout = Workout(_tabata!, _onWorkoutChanged);
    _start();
  }

  @override
  dispose() {
    _workout!.dispose();
    super.dispose();
  }

  _onWorkoutChanged() {
    if (_workout!.step == WorkoutState.finished) {
      finish(context);
    }

    this.setState(() {});
  }

  _start() {
    _workout!.start();
  }

  Widget dividerHorizontalLine({bool? isSmall = false}) {
    return Container(
      height: isSmall == true ? 40 : 65,
      width: 4,
      color: whiteColor,
    );
  }

  Widget mSetText(String value, {String? value2}) {
    return Text(value, style: boldTextStyle(size: 18)).center();
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

  Widget mData(List<Sets> strings) {
    List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      list.add(new Text(strings[i].time.toString()));
    }
    return new Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.mExerciseModel!.data!.title.validate(), context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ChewieScreen(widget.mExerciseModel!.data!.videoUrl.validate(), widget.mExerciseModel!.data!.exerciseImage.validate()).center(),
                30.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('${_workout!.rep}/${widget.mExerciseModel!.data!.sets!.length.toString()}', style: boldTextStyle(size: 18)),
                        Text(
                          languages.lblSets,
                          style: secondaryTextStyle(),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        _workout!.rep >= 1
                            ? mSetText(widget.mExerciseModel!.data!.based == "reps"
                                ? widget.mExerciseModel!.data!.sets![_workout!.rep - 1].reps.toString()
                                : widget.mExerciseModel!.data!.sets![_workout!.rep - 1].time.toString())
                            : mSetText("-"),

                        Text(
                          widget.mExerciseModel!.data!.based == "reps" ? languages.lblReps : languages.lblSecond,
                          style: secondaryTextStyle(),
                        )
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
                50.height,
                Container(child: FittedBox(child: Text(formatTime1(_workout!.timeLeft), style: boldTextStyle(size: 110)))),
                16.height,
              ],
            ),
          ],
        ).center(),
      ),
    );
  }
}
