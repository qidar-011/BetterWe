import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../extensions/text_styles.dart';
import '../main.dart';

class CountDownProgressIndicator1 extends StatefulWidget {
  final int duration;
  final Color backgroundColor;

  final Color valueColor;

  final CountDownController1? controller;

  final Function? onComplete;

  final double strokeWidth;

  final int initialPosition;

  final TextStyle? timeTextStyle;

  final String Function(int seconds)? timeFormatter;

  final TextStyle? labelTextStyle;

  final String? text;

  final bool autostart;

  const CountDownProgressIndicator1({
    Key? key,
    required this.duration,
    this.initialPosition = 0,
    required this.backgroundColor,
    required this.valueColor,
    this.controller,
    this.onComplete,
    this.timeTextStyle,
    this.timeFormatter,
    this.labelTextStyle,
    this.strokeWidth = 10,
    this.text,
    this.autostart = true,
  })  : assert(duration > 0),
        assert(initialPosition < duration),
        super(key: key);

  @override
  _CountDownProgressIndicator1State createState() => _CountDownProgressIndicator1State();
}

class _CountDownProgressIndicator1State extends State<CountDownProgressIndicator1> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late FlutterTts flutterTts;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    flutterTts.awaitSpeakCompletion(true);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.duration,
      ),
    );
    _animation = Tween<double>(
      begin: widget.initialPosition.toDouble(),
      end: widget.duration.toDouble(),
    ).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
        widget.controller!.restart(initialPosition: 5.0);
        setState(() {});
        widget.onComplete?.call();
      }
    });
    _animationController.addListener(() async {
      int j = (widget.duration - _animation.value).round();
      countdown(flutterTts, j);
      setState(() {});
    });

    widget.controller?._state = this;

    if (widget.autostart) onAnimationStart();
  }

  void countdown(FlutterTts tts, int from) async {
    if (from == 10) tts.speak(languages.lblTenSecondRemaining.toString());
    if (from == 3) tts.speak(languages.lblThree.toString());
    if (from == 2) tts.speak(languages.lblTwo.toString());
    if (from == 1) tts.speak(languages.lblOne.toString());
    if (from == 0) {
      tts.speak(languages.lblExerciseDone.toString());
    }
  }

  @override
  void reassemble() {
    onAnimationStart();
    super.reassemble();
  }

  void onAnimationStart() {
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: CircularProgressIndicator(
              strokeWidth: widget.strokeWidth,
              backgroundColor: widget.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
              value: _animation.value / widget.duration,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.timeFormatter?.call((widget.duration - _animation.value).ceil()) ?? (widget.duration - _animation.value).toStringAsFixed(0),
                    style: widget.timeTextStyle ?? boldTextStyle(size: 28),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CountDownController1 {
  late _CountDownProgressIndicator1State _state;

  void pause() {
    _state._animationController.stop(canceled: false);
  }

  void resume() {
    _state._animationController.forward();
  }

  void start() {
    if (!_state.widget.autostart) {
      _state._animationController.forward(from: _state.widget.initialPosition.toDouble());
    }
  }

  void restart({int? duration, required double initialPosition}) {
    if (duration != null) {
      _state._animationController.duration = Duration(seconds: duration);
    }

    _state._animationController.forward(from: initialPosition);
  }
}
