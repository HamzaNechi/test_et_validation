import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'chrono.dart';

class TherapyCountdown extends StatefulWidget {
  final DateTime therapyDate;

  TherapyCountdown({required this.therapyDate});

  @override
  _TherapyCountdownState createState() => _TherapyCountdownState();
}

class _TherapyCountdownState extends State<TherapyCountdown> {
   late Duration _remainingDuration;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _remainingDuration = widget.therapyDate.difference(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingDuration -= Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      padding: EdgeInsets.only(top: 3.0, right: 4.0),
      child: CountDownTimer(
        secondsRemaining: _remainingDuration.inSeconds,
        whenTimeExpires: () {
          setState(() {
            // Handle timer expiration
          });
        },
        countDownTimerStyle: TextStyle(
          color: Color(0XFFf5a623),
          fontSize: 17.0,
          height: 1.2,
        ),
      ),
    );
  }
}
