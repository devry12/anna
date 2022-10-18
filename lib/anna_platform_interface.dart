import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'anna_method_channel.dart';

abstract class AnnaPlatform extends PlatformInterface {
  /// Constructs a AnnaPlatform.
  AnnaPlatform() : super(token: _token);

  static final Object _token = Object();

  static AnnaPlatform _instance = MethodChannelAnna();

  /// The default instance of [AnnaPlatform] to use.
  ///
  /// Defaults to [MethodChannelAnna].
  static AnnaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AnnaPlatform] when
  /// they register themselves.
  static set instance(AnnaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
