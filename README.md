# 爱互动杉德收银sdk集成Flutter插件

## 简介
  ahd_pay_flutter集成了杉德收银H5收银台sdk，主要为合作商户的手机客户端提供安全、便捷的支付服务。

## 官方文档
[杉德新收银台接入指引](https://www.yuque.com/docs/share/e098fee0-0830-4555-ba92-56d2ea0bce73#HtpFS)

[SDK下载地址](https://open.sandpay.com.cn/product/detail/43310/43781/)

## 集成步骤
#### 1、pubspec.yaml
```Dart
ad_center_flutter:
  git: https://github.com/Guardiany/ahd_pay_flutter.git
```

#### 2、IOS
Info.plist中添加：
```
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>weixin</string>
    <string>weixinULAPI</string>
    <string>alipay</string>
    <string>alipays</string>
</array>
```

#### 3、Android

AndroidManifest.xml里面添加：
```
<activity
    android:launchMode="singleTop">

<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="sandcash"
        android:host="scpay"/>
</intent-filter>
```
请解压提供的SDK，在压缩包中找到paytypelibrary2.0.5.aar

找到您的App⼯程下的libs⽂件夹，将上⾯的aar拷⻉到该⽬录下

在app的build.gradle⽂件中添加如下依赖:
```
allprojects {
    repositories {
        //本地⽂件仓库依赖
        flatDir { dirs 'libs'}
    }
}

dependencies {
    implementation files('libs/paytypelibrary2.0.5.aar')
}
```

## 使用

#### 1、调起支付宝
```Dart
await AhdPayFlutter.alipay(options: options);
```