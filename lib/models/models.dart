import 'dart:async';
import '../extensions/extension_util/string_extensions.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

class Tabata {
  int? sets;
  int? reps;
  List<String>? exerciseTime;
  List<String>? restTime;
  Duration? breakTime;
  Duration? startDelay;
  String? status;

  Tabata({
    required this.sets,
    required this.reps,
    required this.startDelay,
    required this.exerciseTime,
    required this.restTime,
    required this.breakTime,
    required this.status,
  });

  Tabata.fromJson(Map<String, dynamic> json) {
    sets = json['sets'];
    reps = json['reps'];
    status = json['status'];
    exerciseTime = json['exerciseTime'].cast<String>();
    restTime = json['restTime'].cast<String>();
    breakTime = Duration(seconds: json['breakTime']);
    startDelay = Duration(seconds: json['startDelay']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sets'] = this.sets;
    data['reps'] = this.reps;
    data['status'] = this.status;
    data['exerciseTime'] = this.exerciseTime;
    data['restTime'] = this.restTime;
    data['breakTime'] = this.breakTime!.inSeconds;
    data['startDelay'] = this.startDelay!.inSeconds;
    return data;
  }

}

enum WorkoutState { initial, starting, exercising, resting, breaking, finished }

class Workout {
  Tabata _config;

  /// Callback for when the workout's state has changed.
  Function _onStateChange;

  WorkoutState _step = WorkoutState.initial;

  Timer? _timer;

  late Duration _timeLeft;

  Duration _totalTime = Duration(seconds: 0);

  int _set = 0;

  String _status = "";

  int _rep = 0;

  Workout(this._config, this._onStateChange);

  /// Starts or resumes the workout
  start() {
    flutterTts.awaitSpeakCompletion(true);
    if (_step == WorkoutState.initial) {
      _step = WorkoutState.starting;

      flutterTts.speak("three");
      if (_config.startDelay!.inSeconds == 0) {
        _nextStep();
      } else {
        _timeLeft = _config.startDelay!;
      }
    }

    _timer = Timer.periodic(Duration(seconds: 1), _tick);
    _onStateChange();
  }

  /// Pauses the workout
  pause() {
    _timer?.cancel();
    _onStateChange();
  }

  /// Stops the timer without triggering the state change callback.
  dispose() {
    _timer?.cancel();
  }

  _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _totalTime += Duration(seconds: 1);
    }

    if (_timeLeft.inSeconds == 1) {
      _nextStep();
    } else {
      _timeLeft -= Duration(seconds: 1);
      if (_step == WorkoutState.starting) {
        flutterTts.speak(_timeLeft.inSeconds.toString());
      } else {
        if (_step != WorkoutState.resting) {
          if (_timeLeft.inSeconds == 10) {
            flutterTts.speak("Ten second remaining");
          }
        }
        if (_timeLeft.inSeconds == 3) {
          // _playSound(_settings.countdownPip);
          if (_step == WorkoutState.resting) {
            flutterTts.speak("Three second remaining for rest");
          } else {
            flutterTts.speak("Three second remaining");
          }
        }
      }
    }
    _onStateChange();
  }

  /// Moves the workout to the next step and sets up state for it.
  _nextStep() {
    if (_step == WorkoutState.exercising) {
      if (rep == _config.reps) {
        if (set == _config.sets) {
          _finish();
        } else {
          _startBreak();
        }
      } else {
        _startRest();
      }
    } else if (_step == WorkoutState.resting) {
      _startRep();
    } else if (_step == WorkoutState.starting || _step == WorkoutState.breaking) {
      flutterTts.speak("Go");

      _startSet();
    }
  }

  // Future _playSound(String sound) {
  //   if (_settings.silentMode) {
  //     return Future.value();
  //   }
  //   return player.play(sound, mode: PlayerMode.LOW_LATENCY);
  // }

  _startRest() {
    _step = WorkoutState.resting;
    if (Duration(seconds: _config.restTime![_rep - 1].toInt()).inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = Duration(seconds: _config.restTime![_rep - 1].toInt());
    flutterTts.speak('${_timeLeft.inSeconds.toString()} second rest up next ${_config.exerciseTime![_rep]} ${_config.status}');
  }

  _startRep() {
    _rep++;
    _step = WorkoutState.exercising;
    _timeLeft = Duration(seconds: _config.exerciseTime![_rep - 1].toInt());
  }

  _startBreak() {
    _step = WorkoutState.breaking;
    if (_config.breakTime!.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.breakTime!;
    flutterTts.speak("break");
    // _playSound(_settings.startBreak);
  }

  _startSet() {
    // flutterTts.speak("Exercise Start");
    _set++;
    _rep = 1;
    _step = WorkoutState.exercising;
    _timeLeft = Duration(seconds: _config.exerciseTime![_rep - 1].toInt());
    // _playSound(_settings.startSet);
  }

  _finish() {
    _timer?.cancel();
    _step = WorkoutState.finished;
    _timeLeft = Duration(seconds: 0);
    flutterTts.speak("Exercise Complete");
    // _playSound(_settings.endWorkout).then((p) {
    //   if (p == null) {
    //     return;
    //   }
    //   p.onPlayerCompletion.first.then((_) {
    //     _playSound(_settings.endWorkout);
    //   });
    // });
  }

  get config => _config;

  get status => _status;

  get set => _set;

  get rep => _rep;

  get step => _step;

  get timeLeft => _timeLeft;

  get totalTime => _totalTime;

  get isActive => _timer != null && _timer!.isActive;
}
