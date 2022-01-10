import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ahd_pay_flutter/ahd_pay_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('ahd_pay_flutter');

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
    expect(await AhdPayFlutter.platformVersion, '42');
  });
}
