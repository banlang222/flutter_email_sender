import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_email_sender_method_channel.dart';

abstract class FlutterEmailSenderPlatform extends PlatformInterface {
  /// Constructs a FlutterEmailSenderPlatform.
  FlutterEmailSenderPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEmailSenderPlatform _instance = MethodChannelFlutterEmailSender();

  /// The default instance of [FlutterEmailSenderPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterEmailSender].
  static FlutterEmailSenderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterEmailSenderPlatform] when
  /// they register themselves.
  static set instance(FlutterEmailSenderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
