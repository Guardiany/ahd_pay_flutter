
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class AhdPayFlutter {
  static const MethodChannel _channel =
      const MethodChannel('ahd_pay_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> alipay({
    required String orderId,
  }) async {
    if (Platform.isIOS) {
      final result = await _channel.invokeMethod('alipay', {
        'orderId': orderId,
      });
      if (result['result'] == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
