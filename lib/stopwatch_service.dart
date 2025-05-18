import 'dart:async';

class StopwatchService {
  static final StopwatchService _instance = StopwatchService._internal();

  factory StopwatchService() => _instance;

  Stopwatch _stopwatch = Stopwatch();
  List<Duration> _lapTimes = [];
  Timer? _timer;

  Function()? onTick;

  StopwatchService._internal() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (_stopwatch.isRunning && onTick != null) {
        onTick!();
      }
    });
  }

  Duration get elapsed => _stopwatch.elapsed;

  List<Duration> get lapTimes => _lapTimes;

  bool get isRunning => _stopwatch.isRunning;

  void start() {
    _stopwatch.start();
  }

  void stop() {
    _stopwatch.stop();
  }

  void toggle() {
    isRunning ? stop() : start();
  }

  void reset() {
    _stopwatch.reset();
    _lapTimes.clear();
  }

  void addLap() {
    _lapTimes.insert(0, _stopwatch.elapsed);
  }
}
