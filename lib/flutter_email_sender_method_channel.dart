import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_email_sender_platform_interface.dart';

/// An implementation of [FlutterEmailSenderPlatform] that uses method channels.
class MethodChannelFlutterEmailSender extends FlutterEmailSenderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_email_sender');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
