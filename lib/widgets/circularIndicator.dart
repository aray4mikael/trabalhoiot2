import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularIndicator extends StatefulWidget {
  double valor = 0.0;

  CircularIndicator({super.key, required this.valor});

  @override
  State<CircularIndicator> createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> {
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 68,
      lineWidth: 10.0,
      animation: true,
      percent: widget.valor / 100,
      center: Text(
        "${widget.valor} %",
        style: const TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 255, 255)),
      ),
      backgroundColor: Color.fromARGB(255, 212, 210, 210),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Color.fromARGB(255, 0, 140, 255),
    );
  }
}
