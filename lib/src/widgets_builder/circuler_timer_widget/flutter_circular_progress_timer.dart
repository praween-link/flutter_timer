part of '../imports.dart';

typedef FCurcularTimerBuilder = Widget Function(
  BuildContext context,
  String? value,
  double? progress,
);

double deg2rad(double deg) => deg * math.pi / 180;

class FlutterCircularProgressTimer extends StatefulWidget {
  final FCurcularTimerBuilder builder;
  final CircularTimerDecoraton? decoraton;
  final double? radius;
  final TimerControllerValues? timerControllerValues;
  final bool isPieShape;

  const FlutterCircularProgressTimer({
    super.key,
    required this.builder,
    this.decoraton,
    this.radius,
    this.timerControllerValues,
    this.isPieShape = false,
  });

  @override
  State<FlutterCircularProgressTimer> createState() =>
      _FlutterCircularProgressTimerState();
}

class _FlutterCircularProgressTimerState
    extends State<FlutterCircularProgressTimer> {
  double _progress = 0.0;

  late TimerFController _timerFController;
  int maxRecordTime = 60;

  @override
  void initState() {
    _timer();
    super.initState();
  }

  _timer() {
    _timerFController = TimerFController(
      listeningDelay: widget.timerControllerValues?.listeningDelay,
      startTime: widget.timerControllerValues?.startTime,
      statusListener: widget.timerControllerValues?.statusListener,
      timeFormate: widget.timerControllerValues?.timeFormate ?? "HH:MM:SS:ms",
      isCountdown: widget.timerControllerValues?.isCountdown ?? true,
      duration: widget.timerControllerValues?.duration,
      progress0to1Listener: (v) {
        _progress = v;
      },
    );
    if (widget.timerControllerValues?.controller != null) {
      widget.timerControllerValues?.controller!(_timerFController);
    }
  }

  @override
  void dispose() {
    _timerFController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: _timerFController.controller.stream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  color: widget.decoraton?.fillColor ?? Colors.transparent,
                  borderRadius:
                      BorderRadius.circular((widget.radius ?? 60) * 2)),
              child: CustomPaint(
                painter: CircularPaint(
                  isPieShape: widget.isPieShape,
                  progressShadow: widget.decoraton?.progressShadow,
                  progressBackgroundColor:
                      widget.decoraton?.progressBackgroundColor,
                  progressValue: _progress,
                  prgressThickness: widget.decoraton?.prgressThickness ?? 8.0,
                  progressColors: widget.decoraton?.progressColors,
                  progressMaskFilter: widget.decoraton?.progressMaskFilter,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide(
                      color: Color.fromRGBO(0, 0, 0, 0),
                      width: 2.5,
                    )),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: widget.radius ?? 60,
                    child:
                        widget.builder.call(context, snapshot.data, _progress),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
