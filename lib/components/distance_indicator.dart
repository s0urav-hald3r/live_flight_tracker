import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class DistanceIndicator extends StatefulWidget {
  final double totalDistance;
  final double currentDistance;
  const DistanceIndicator({
    super.key,
    required this.totalDistance,
    required this.currentDistance,
  });

  @override
  State<DistanceIndicator> createState() => _DistanceIndicatorState();
}

class _DistanceIndicatorState extends State<DistanceIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double getProgress() {
    final progress = widget.currentDistance / widget.totalDistance;
    return progress > 1 ? 1 : progress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 40.h,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: ProgressLinePainter(progress: getProgress()),
            child: Stack(
              children: [
                Positioned(
                  left: _animation.value *
                      (getProgress() * MediaQuery.of(context).size.width -
                          32.w -
                          (getProgress() * 70)), // Movement along the line
                  top: 1.h,
                  child: SvgPicture.asset(hPlane),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProgressLinePainter extends CustomPainter {
  final double progress;
  ProgressLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Draw the progress line
    canvas.drawLine(
      const Offset(0, 20), // Start of the line
      Offset(size.width, 20), // End of the line
      paint..color = textColor, // Dark blue for full line
    );

    // Draw the filled portion
    canvas.drawLine(
      const Offset(0, 20),
      Offset(size.width * progress, 20), // Adjust this for dynamic progress
      paint..color = primaryColor, // Bright blue for progress
    );

    // Draw the dots
    canvas.drawCircle(const Offset(0, 20), 5, paint..color = primaryColor);
    canvas.drawCircle(Offset(size.width, 20), 5, paint..color = textColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
