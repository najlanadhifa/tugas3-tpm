import 'package:flutter/material.dart';
import 'stopwatch_service.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final StopwatchService stopwatch = StopwatchService();

  final Color bgColor = Color(0xFFF7F0E8);
  final Color mainColor = Color(0xFF604652);
  final Color btnDark = Color(0xFF735557);
  final Color btnLight = Color(0xFFD29F80);

  @override
  void initState() {
    super.initState();
    stopwatch.onTick = () {
      if (mounted) setState(() {});
    };
  }

  @override
  void dispose() {
    stopwatch.onTick = null;
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, "0");
    return "$minutes:$seconds.$milliseconds";
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = stopwatch.isRunning;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Stopwatch'),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                stopwatch.reset();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              _formatTime(stopwatch.elapsed),
              style: TextStyle(
                color: mainColor,
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: stopwatch.lapTimes.isEmpty
                  ? Center(child: Text('Belum ada catatan waktu', style: TextStyle(color: Colors.grey[600])))
                  : ListView.builder(
                      reverse: true,
                      itemCount: stopwatch.lapTimes.length,
                      itemBuilder: (context, index) {
                        final lapNumber = stopwatch.lapTimes.length - index;
                        final lapTime = stopwatch.lapTimes[index];
                        final diff = index == stopwatch.lapTimes.length - 1
                            ? lapTime
                            : lapTime - stopwatch.lapTimes[index + 1];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Lap ${lapNumber.toString().padLeft(2, '0')}", style: TextStyle(color: mainColor)),
                              Text("+ ${_formatTime(diff)}", style: TextStyle(color: Colors.grey[700])),
                              Text(_formatTime(lapTime), style: TextStyle(color: mainColor)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circleButton(
                  icon: Icons.flag,
                  onPressed: isRunning ? () => setState(() => stopwatch.addLap()) : null,
                  color: mainColor,
                ),
                _circleButton(
                  icon: isRunning ? Icons.pause : Icons.play_arrow,
                  onPressed: () => setState(() => stopwatch.toggle()),
                  color: isRunning ? btnLight : btnDark,
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, VoidCallback? onPressed, required Color color}) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: CircleBorder(),
      fillColor: onPressed != null ? color : btnLight.withOpacity(0.5),
      padding: EdgeInsets.all(20.0),
      elevation: 4,
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
