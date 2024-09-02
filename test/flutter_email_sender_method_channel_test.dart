import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_email_sender/flutter_email_sender_method_channel.dart';

void main() {
  MethodChannelFlutterEmailSender platform = MethodChannelFlutterEmailSender();
  const MethodChannel channel = MethodChannel('flutter_email_sender');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
