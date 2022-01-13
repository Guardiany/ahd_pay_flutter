package com.ahd.ahd_pay_flutter;

import android.app.Activity;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.pay.paytypelibrary.base.PayUtil;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AhdPayFlutterPlugin */
public class AhdPayFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  public MethodChannel.Result _result;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ahd_pay_flutter");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("alipay")) {
      cashierPay("02020002",call,result);
    } else {
      result.notImplemented();
    }
  }

  private void cashierPay(String productCode,MethodCall call, MethodChannel.Result result) {
    _result = result;
    JSONObject orderJson = new JSONObject();
    try {
      orderJson.put("version", call.argument("version"));
      orderJson.put("sign_type", call.argument("sign_type"));
      orderJson.put("mer_no", call.argument("mer_no")); // 商户编号
      orderJson.put("mer_key", call.argument("mer_key"));
      orderJson.put("mer_order_no", call.argument("mer_order_no")); // 商户订单号
      orderJson.put("create_time", call.argument("create_time")); // 订单创建时间
      orderJson.put("expire_time", call.argument("expire_time")); // 订单失效时间
      orderJson.put("order_amt", call.argument("order_amt")); // 订单金额
      orderJson.put("notify_url", call.argument("notify_url")); // 回调地址
      orderJson.put("return_url", call.argument("return_url"));//"http://www.baidu.com"); // 支付后返回的商户显示页面
      orderJson.put("create_ip", call.argument("create_ip")); // 客户端的真实IP
      orderJson.put("goods_name", call.argument("goods_name")); // 商品名称
      orderJson.put("store_id", call.argument("store_id")); // 门店号
      orderJson.put("product_code", productCode); // 支付产品编码
      orderJson.put("clear_cycle", call.argument("clear_cycle")); // 清算模式

      JSONObject payExtraJson = new JSONObject();
      payExtraJson.put("mer_app_id", ""); // 微信公众号Appid
      payExtraJson.put("openid", ""); // 微信公众号Openid
      payExtraJson.put("buyer_id", ""); // 支付宝生活号
      payExtraJson.put("miniProgramType", "0"); // 正式版:0、开发版:1、体验版:2
      orderJson.put("pay_extra", payExtraJson.toString());

      orderJson.put("accsplit_flag", "NO"); // 分账标识 NO无分账，YES有分账
      orderJson.put("jump_scheme", "sandcash://scpay"); // 支付宝返回app所配置的域名
      orderJson.put("activity_no", ""); //营销活动编码
      orderJson.put("benefit_amount", ""); //优惠金额
      orderJson.put("extend", "123"); //扩展字段，非必传
      orderJson.put("limit_pay", "5"); //微信传1屏蔽信用卡，支付宝传5屏蔽部分信用卡以及花呗，支付宝传4屏蔽花呗，支付宝传1屏蔽部分信用卡，银联不支持屏蔽   不参与签名

      String signKey = call.argument("key");

      //计算签名
      Map<String, String> signMap = new HashMap<String, String>();
      signMap.put("version", orderJson.getString("version"));
      signMap.put("mer_no", orderJson.getString("mer_no"));
      signMap.put("mer_key", orderJson.getString("mer_key"));
      signMap.put("mer_order_no", orderJson.getString("mer_order_no"));
      signMap.put("create_time", orderJson.getString("create_time"));
      signMap.put("order_amt", orderJson.getString("order_amt"));
      signMap.put("notify_url", orderJson.getString("notify_url"));
//            signMap.put("return_url", orderJson.getString("return_url"));
      signMap.put("create_ip", orderJson.getString("create_ip"));
      signMap.put("store_id", orderJson.getString("store_id"));
      signMap.put("pay_extra", orderJson.getString("pay_extra"));
      signMap.put("accsplit_flag", orderJson.getString("accsplit_flag"));
      signMap.put("sign_type", orderJson.getString("sign_type"));

      if (!TextUtils.isEmpty(orderJson.optString("activity_no"))) {
        signMap.put("activity_no", orderJson.getString("activity_no"));
      }
      if (!TextUtils.isEmpty(orderJson.optString("benefit_amount"))) {
        signMap.put("benefit_amount", orderJson.getString("benefit_amount"));
      }
      if (!TextUtils.isEmpty(orderJson.optString("extend"))) {
        signMap.put("extend", orderJson.getString("extend"));
      }

      List<Map.Entry<String, String>> list = MD5Utils.sortMap(signMap);
      StringBuilder signBuilder = new StringBuilder();
      for (Map.Entry<String, String> m : list) {
        signBuilder.append(m.getKey());
        signBuilder.append("=");
        signBuilder.append(m.getValue());
        signBuilder.append("&");
      }

      signBuilder.append("key");
      signBuilder.append("=");
      signBuilder.append(signKey);

      orderJson.put("sign", MD5Utils.getMD5(signBuilder.toString()).toUpperCase()); // MD5签名结果
    } catch (Exception e) {
      e.getStackTrace();
    }
    PayUtil.CashierPay(activity, orderJson.toString());
    Map<String, Object> resultMap = new HashMap<>();
    resultMap.put("result", "success");
    _result.success(resultMap);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }
}
