import 'dart:async';

import 'package:edemand_partner/utils/constant.dart';
import 'package:flutter/material.dart';

class CountDownTimer {
  StreamController timerController = StreamController.broadcast();
  StreamSubscription<int>? _subscription;

  int maxTimeValue = Constant.resendOTPCountDownTime;
  //Timer? _timer;
  Stream get listenChanges => timerController.stream;

  start(VoidCallback onEnd) {
    Stream<int> stream = Stream.periodic(
      const Duration(seconds: 1),
      (computationCount) {
        maxTimeValue -= 1;

        return maxTimeValue;
      },
    );
    _subscription?.cancel();

    _subscription = stream.listen((int data) {
      if (!timerController.isClosed) {
        timerController.add(data);

        if (data == 0) {
          maxTimeValue = Constant.resendOTPCountDownTime;
          onEnd();
          _subscription?.pause();
          _subscription?.cancel();
        }
      }
    });
  }

  listenText({Color? color}) {
    return StreamBuilder(
      stream: timerController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("-" * Constant.resendOTPCountDownTime.toString().length,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0),
              textAlign: TextAlign.center);
        }

        return Text(snapshot.data.toString());
      },
    );
  }

  pause() {
    _subscription?.pause();
  }

  reset() {
    _subscription?.cancel();
    start(() {});
  }

  resume() {
    _subscription?.resume();
  }

  close() {
    _subscription?.cancel();
  }
}
