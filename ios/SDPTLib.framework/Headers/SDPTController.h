//
//  SDPTController.h
//  PayFramework
//
//  Created by WGPawn on 3/8/21.
//  Copyright © 2021 ". All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import <WebKit/WebKit.h>


@class XHPayParameterModel;
@class SDPTController;

/* 支付方式枚举*/
/// 0 - 微信
/// 1 - 支付宝
/// 2 - 链接支付
/// 3 - 杉德宝
/// 4 - 银联
/// 5 - h5云吊起微信小程序
///   -
///   -
/// 8 - 杉德云账户
///100- 未知类型

typedef enum : NSUInteger {
    PyTypeWeiXP = 0,
    PyTypeZFBP = 1,
    PyTypeLinkP = 2,
    PyTypeSandBP = 3,
    PyTypeUnionP = 4,
    PyCloudWeiXAppletP = 5,
    PyDCEPP = 6,
    PyBOCEWalletP = 7,
    PySANDYUNACCP = 8,
    NoOne = 100
} ProductPyType;


NS_ASSUME_NONNULL_BEGIN
 

@interface SDPTController : NSObject


+(instancetype)shared;



/// 设置打印日志
///  isLogEnable YES 会打印日志
@property (nonatomic, assign) BOOL isLogEnable;


/// 报错信息 message   支付类型type
@property (nonatomic, copy) void(^payfailureBlock)(NSString *errorMessage,ProductPyType type);
 

/// 根据type  区分各种支付的类型 获取相应的支付参数返回
/// 对应关系如下 type
/// 8  --- 杉德云账户
/// 6  ---
/// 5  --- 微信 小程序支付云函数起吊  
/// 4  --- 银联 - - -TN             传给银联SDK
/// 3 --- 杉德宝 - - -TN             传给杉德宝SDK
/// 2--- 链接支付 - - -link string  直接在支付宝微信等好友发送打开
/// 1  --- 支付宝 - - - - tokenId             用来查询支付结果 必要参数
/// 0 ---  微信 - - -tokenId                  用来拼接在小程序路径后面

@property (nonatomic, copy) void(^payTypeBlock)(ProductPyType type,NSString *tokenID);
  


/// 吊起支付用控件方法
/// @param showVc 需要出现的ViewController
/// @param parameterModel 参数模型
/// 注意⚠️：
/// 可以根据业务多合一，包含银联支付，支付宝支付，微信支付，链接好友支付，杉德宝支付等。如果接入多合一支付  需要全部参数都要传。必要参数不可传""，例如接入微信支付但是没有传微信的参数,支付页面会显示微信支付方式但是无法吊起微信支付。
 
-(void)showSDPTDesktopIn:(UIViewController*)showVc model:(XHPayParameterModel*)parameterModel;
 
 

/* 粘贴板链接好友支付--不需要接入任何SDK，可在银联微信支付宝中打开即可支付
 @param model 参数模型 model.product_code = @"02000002"
 model.linkTips 粘贴成功提示语 不填默认 弹出 复制成功
 
 杉德宝支付 -- 需要接入杉德宝SDK。 注意⚠️需要把自己的app的bundle id 加在在url type中
 @param model 参数 model.product_code = @"02040001"

 银联支付--需要接入银联SDK，传入TN等
 @param model 参数 model.product_code = @"02030001"
 
 微信支付--需要接入微信SDK，并且配置universeLink等
 @param model 参数 model.product_code = @"02010005"
 
 支付宝支付--不需要接入支付宝SDK即可支付
 @param model 参数 model.product_code = @"02020004"

 h5云函数-吊起微信小程序支付-不需要接入微信SDK即可支付
 @param model 参数 model.product_code = @"02010007"
 

 杉德云账户-04010001-账户侧--开户并扣款，04010002-云账户支付-受理侧，支付成功SDK-void(^payTypeBlock)实时返回支付结果。
 @param model 参数 model.product_code = @"04010001"
  
 */
 
 

 

@end

NS_ASSUME_NONNULL_END
