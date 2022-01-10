//
//  XHPayParameterModel.h
//  PayFramework
//
//  Created by WGPawn on 2020/11/27.
//  Copyright © 2020 ". All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
 

/// 支付扩展域参数 pay_extraJson 说明如下

/**
        根据具体的支付方式传不同的支付扩展域 pay_extraJson参数的顺序与签名时顺序一致,pay_extraJson中签名时有转义传参数时也要转义
 微信公众号 ------ 传
 {@"mer_app_id":@"公众号的mer_app_id",@"openid":@"使用微信公众号的mer_app_id获取每个用户的openid"}
 
 支付宝生活号 / 支付宝H5建议不传/也可以传空  ------ 传 @{@"buyer_id":@"此处可以传你的生活号id"}。 或者传 nil时签名时pay_extra不参与签名。
 
 微信小程序 ------ 必传参数
 {@"wx_app_id":"移动应用Appid（微信开放平台获取，wx开头",@"gh_ori_id":"小程序原始id（微信公众平台获取，gh_开头）",@"path_url":"拉起小程序页面的可带参路径，不填默认拉起小程序首页",@"miniProgramType":""开发时根据小程序是开发版、体验版或正式版自行选择。正式版:0; 开发版:1; 体验版:2""}
 
 杉德云账户 ------ 必传参数
 {@"userId":"用户在商户系统中的唯一编号",@"nickName":"会员昵称",@"masterAccount":"会员开户时返回，（杉德云账户受理侧必填参数）"}
 
 */


/*
 注意：如果是多种支付方式共存 需要上面的参数都有且正确。pay_extraJson的参数的顺序与签名时pay_extra参数字符串一致。
 */

/*
/// 微信公众号 appid 没有可以传 "" 必填
NSString *mer_app_id;
/// 微信公众号 openid 没有可以传 "" 必填
 NSString *openid;
/// 支付宝生活号 没有可以传 "" 必填
 NSString *buyer_id;
/// 小程序原始id（微信公众平台获取，gh_开头  没有可以传 "" 必填
 NSString *gh_ori_id;
///  拉起小程序页面的可带参路径，不填默认拉起小程序首页 建议 pages/zf/index? 没有可以传 "" 必填
 NSString *path_url;
/// 开发时根据小程序是开发版、体验版或正式版自行选择。正式版:0; 开发版:1; 体验版:2" 建议默认2 没有可以传 "" 必填
 NSString *miniProgramType;
///  移动应用Appid（微信开放平台获取，wx开头 没有可以传 "" 必填
 NSString *wx_app_id;
 
/// 协议号 
 NSString *agreementNo;
/// --手机号
 NSString *phoneNo;

/// 杉德云账户 - - 用户在商户系统中的唯一编号
 NSString *userId;

///  -- 业务类型
NSString *tradeCategoryCode;


/// 杉德云账户 --  会员昵称
 NSString *nickName;

/// 杉德云账户 --  会员开户时返回，（杉德云账户受理侧必填参数）
 NSString *masterAccount;

*/



 




///  支付参数
@interface XHPayParameterModel : NSObject



/// 当前接口版本号 必填
@property (nonatomic, copy) NSString *version;

/// 商户编号 必填
@property (nonatomic, copy) NSString *mer_no;

/// 商户订单号（最小长度12位） 必填
@property (nonatomic, copy) NSString *mer_order_no;

/// 用户所在客户端的真实ip其中的“.”替换为“_” 。如 192_168_0_1。 如出现多个ip，只传最外层 必填
@property (nonatomic, copy) NSString *create_ip;

/// 门店号 没有填默认值 000000 必填
@property (nonatomic, copy) NSString *store_id;

/// 商品名称 必填
@property (nonatomic, copy) NSString *goods_name;

/// 支付扩展域 具体参数见上面说明  
@property (nonatomic, copy) NSString *pay_extraJson;



/// 订单创建时间 yyyyMMddHHmmss 必填
@property (nonatomic, copy) NSString *create_time;

/// 商户密钥  手机APK工具 生成的key1 必填
@property (nonatomic, copy) NSString *mer_key;

/// 订单失效时间 yyyyMMddHHmmss 必填
@property (nonatomic, copy) NSString *expire_time;

/// 回调地址  填 http://sandcash/notify 必填
@property (nonatomic, copy) NSString *notify_url;

/// 支付产品,多个以英文逗号分隔，具体产品见产品编码文档 必填
@property (nonatomic, copy) NSString *product_code;

///  分账标识 NO无分账，YES有分账 必填
@property (nonatomic, copy) NSString *accsplit_flag;

/// 支付后返回的商户显示页面 没有就填 "" 必填
@property (nonatomic, copy) NSString *return_url;

/// 清算模式 0-T1(默认); 1-T0; 2-D0; 3-D1  建议默认 0 必填
@property (nonatomic, copy) NSString *clear_cycle;

/// 订单金额（单位:元，1分=0.01元） 必填
@property (nonatomic, copy) NSString *order_amt;

/// 安卓用  iOS直接传  "" 必填
@property (nonatomic, copy) NSString *jump_scheme;

/// 签名类型，默认MD5 必填
@property (nonatomic, copy) NSString *sign_type;

/// MD5签名结果  安全起见，建议商户私钥存放在服务端，整个加签过程在服务端完成 必填
@property (nonatomic, copy) NSString *sign;

/// 链接支付 弹出文字 非必填 可传 可空或者nil
@property (nonatomic, strong) NSString *linkTips;

/// 营销或者优惠活动编码
@property (nonatomic, strong) NSString *activity_no;
/// 优惠金额 本单需要优惠的金额，12位数字，精确到分
@property (nonatomic, strong) NSString *benefit_amount;

/// H5跳转小程序支付云静态网站url 在02010007场景下必填 例:https://yishan-x846q-1302106789.tcloudbaseapp.com/jump_mp.html
@property (nonatomic, strong) NSString *static_wexUrl;
///  扩充字段 可以为空 最大256字节
@property (nonatomic, strong) NSString *extend;
/// limit_pay-不参与签名 微信，1屏蔽所有信用卡。 支付宝5屏蔽部分信用卡和花呗，支付宝4屏蔽花呗，支付宝1屏蔽部分信用卡。 银联暂时都没有屏蔽的
@property (nonatomic, strong) NSString *limit_pay;



//"activityNo": "MP20201228132838216",
//    "benefitAmount": "本单需要优惠的金额，12位数字精确到分",


//@"version":@"1.0",
//@"mer_no":@"16938552",
//@"mer_order_no":timeStr,
//@"create_ip":@"172_12_12_12",
//@"store_id":@"100001",
//@"goods_name":@"测试商品",
//@"pay_extra":@"{\"mer_app_id\":\"\",\"openid\":\"\",\"buyer_id\":\"\",\"gh_ori_id\":\"gh_8f69bbed2867\",\"path_url\":\"pages/zf/index?\",\"miniProgramType\":\"2\",\"wx_app_id\":\"wx24932e45899137eb\"}",
//@"create_time":DateTime,
//@"mer_key":@"Xx52CDtWRH1etGu4IfFEB4OeRrnbr+EUd5VO7cBQFCqxfDl5FJcJaUjKJbHapVsyxSODBEbssNk=",
//@"expire_time":@"",
//@"create_time":@"",
//@"notify_url":@"http://sandcash/notify",
//@"product_code":@"02030001",
//@"accsplit_flag":@"NO",
//@"return_url":@"",
//@"clear_cycle":@"0",
//@"order_amt":@"0.01",
//@"jump_scheme":@"sandcash://scpay",
//@"meta_option":@"[{\"sc\":\"testapp://\",\"s\":\"iOS\",\"id\":\"com.pay.paytypetest\",\"n\":\"testdome\"}]",
//@"sign_type":@"MD5",
//@"sign":@"45D3DCC8D5168076B1673CED223CAD90",

@end

NS_ASSUME_NONNULL_END
