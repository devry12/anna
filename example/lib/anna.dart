import 'package:anna/anna.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKeys = GlobalKey<NavigatorState>();

class AnnaConfig {
  Anna anna = Anna(navigatorKey: navigatorKeys);

  dioInterceptor() {
    return anna.dioInterceptor();
  }

  navigatorKey() {
    return anna.getNavigatorKey();
  }

  showInterceptor() {
    return anna.openLog();
  }
}
