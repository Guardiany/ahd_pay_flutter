
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
    required PaymentOptions options,
  }) async {
    if (Platform.isIOS) {
      final result = await _channel.invokeMethod('alipay', {
        'mer_order_no': options.mer_order_no,
        'mer_key': options.mer_key,
        'sign_type': options.sign_type,
        'order_amt': options.order_amt,
        'clear_cycle': options.clear_cycle,
        'return_url': options.return_url,
        'accsplit_flag': options.accsplit_flag,
        'product_code': options.product_code,
        'notify_url': options.notify_url,
        'create_time': options.create_time,
        'expire_time': options.expire_time,
        'goods_name': options.goods_name,
        'store_id': options.store_id,
        'create_ip': options.create_ip,
        'mer_no': options.mer_no,
        'version': options.version,
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

class PaymentOptions {
  String mer_order_no = '';
  String mer_key = '';
  String sign_type = '';
  String order_amt = '';
  String clear_cycle = '';
  String return_url = '';
  String accsplit_flag = '';
  String product_code = '';
  String notify_url = '';
  String create_time = '';
  String expire_time = '';
  String goods_name = '';
  String store_id = '';
  String create_ip = '';
  String mer_no = '';
  String version = '';
}