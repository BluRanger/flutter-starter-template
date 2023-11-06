import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import '../../router/auto_route.dart';
import 'issue.dart';

class ShakeService {
  ShakeService(AppRouter appRouter) {
    reportBug(appRouter);
  }

  Future<void> reportBug(AppRouter appRouter) async {
    ShakeDetector.autoStart(
      onPhoneShake: () {
        showDialog(
          context: appRouter.navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Report Issue'),
              content: IssueForm(appRouter.navigatorKey, "Shake Service"),
            );
          },
        );
        // Do stuff on phone shake
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 1000,
      shakeCountResetTime: 2000,
      shakeThresholdGravity: 2.7,
    );
  }
}
