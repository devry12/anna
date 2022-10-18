library anna;

import 'package:anna/anna_platform_interface.dart';
import 'package:anna/core.dart';
import 'package:anna/dio/dio_Interceptors.dart';
import 'package:anna/screen/ui.dart';
import 'package:anna/shake/shake.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

///analytics network adjustment
class Anna {
  GlobalKey<NavigatorState>? navigatorKey;
  int maxCallsCount;
  late AnnaCore core;
  bool showWithShake;
  ShakeDetector? _shakeDetector;

  var controller = Get.put(AnnaController());

  Anna(
      {this.navigatorKey,
      this.maxCallsCount = 100,
      this.showWithShake = false}) {
    if (showWithShake) {
      _shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: () {
          if (!controller.isOpen.value) {
            openLog();
          }
        },
        shakeThresholdGravity: 5,
      );
    }

    core = AnnaCore(
        maxCallsCount: maxCallsCount,
        navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>());
  }

  Future<String?> getPlatformVersion() {
    return AnnaPlatform.instance.getPlatformVersion();
  }

  void dispose() {
    _shakeDetector!.stopListening();
  }

  dioInterceptor() {
    return dioInterceptors(core: core);
  }

  getNavigatorKey() {
    return navigatorKey;
  }

  openLog() {
    controller.isOpen.value = true;
    Navigator.push<void>(
      navigatorKey!.currentState!.context,
      MaterialPageRoute(
        builder: (context) => AnnaCallList(
          core: core,
        ),
      ),
    ).then((value) {
      controller.isOpen.value = false;
    });
  }
}
