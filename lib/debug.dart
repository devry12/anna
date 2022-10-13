import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

logDebug(String title, value) {
  if (kDebugMode) {
    logger.d("$title $value");
  }
}

logError(String title, value) {
  if (kDebugMode) {
    logger.e("$title $value");
  }
}
