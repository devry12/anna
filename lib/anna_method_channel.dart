import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'anna_platform_interface.dart';

/// An implementation of [AnnaPlatform] that uses method channels.
class MethodChannelAnna extends AnnaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('anna');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
