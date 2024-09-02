import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_email_sender/flutter_email_sender_platform_interface.dart';
import 'package:flutter_email_sender/flutter_email_sender_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEmailSenderPlatform
    with MockPlatformInterfaceMixin
    implements FlutterEmailSenderPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterEmailSenderPlatform initialPlatform = FlutterEmailSenderPlatform.instance;

  test('$MethodChannelFlutterEmailSender is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterEmailSender>());
  });

  test('getPlatformVersion', () async {
    FlutterEmailSender flutterEmailSenderPlugin = FlutterEmailSender();
    MockFlutterEmailSenderPlatform fakePlatform = MockFlutterEmailSenderPlatform();
    FlutterEmailSenderPlatform.instance = fakePlatform;

    expect(await flutterEmailSenderPlugin.getPlatformVersion(), '42');
  });
}
