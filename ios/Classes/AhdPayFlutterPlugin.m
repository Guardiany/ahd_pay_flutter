#import "AhdPayFlutterPlugin.h"
#import <SDPTLib/SDPTFramework.h>
#import <CommonCrypto/CommonDigest.h>

@implementation AhdPayFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ahd_pay_flutter"
            binaryMessenger:[registrar messenger]];
  AhdPayFlutterPlugin* instance = [[AhdPayFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else if ([@"wxPay" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:true]);
    }
    else if ([@"alipay" isEqualToString:call.method]) {
        [self alipay:call result:result];
        result([NSNumber numberWithBool:true]);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)alipay:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]]) {
        NSLog(@"未安装支付宝APP");
        NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"error", @"result", @"未安装支付宝APP", @"message", nil];
        result(resultDic);
        return;
    }
    
    NSDictionary *dic = call.arguments;
    NSString *mer_order_no = [dic valueForKey:@"mer_order_no"];
    NSString *mer_key = [dic valueForKey:@"mer_key"];
    NSString *sign_type = [dic valueForKey:@"sign_type"];
    NSString *order_amt = [dic valueForKey:@"order_amt"];
    NSString *clear_cycle = [dic valueForKey:@"clear_cycle"];
    NSString *return_url = [dic valueForKey:@"return_url"];
    NSString *accsplit_flag = [dic valueForKey:@"accsplit_flag"];
    NSString *product_code = [dic valueForKey:@"product_code"];
    NSString *notify_url = [dic valueForKey:@"notify_url"];
    NSString *create_time = [dic valueForKey:@"create_time"];
    NSString *expire_time = [dic valueForKey:@"expire_time"];
    NSString *goods_name = [dic valueForKey:@"goods_name"];
    NSString *store_id = [dic valueForKey:@"store_id"];
    NSString *create_ip = [dic valueForKey:@"create_ip"];
    NSString *mer_no = [dic valueForKey:@"mer_no"];
    NSString *version = [dic valueForKey:@"version"];
    
    XHPayParameterModel *model = [XHPayParameterModel new];
    model.sign_type = sign_type;
    model.jump_scheme = @"sandcash://scpay";
    model.order_amt = order_amt;
    model.clear_cycle = clear_cycle;
    model.return_url = return_url;
    model.accsplit_flag = accsplit_flag;
    /// 只有支付宝
    model.product_code = product_code;
    model.notify_url = notify_url;
    /// 不可为空
    model.create_time = create_time;
    model.expire_time = expire_time;
    model.mer_key = mer_key;
    model.goods_name = goods_name;
    model.store_id = store_id;
    model.create_ip = create_ip;
    // 单号
    model.mer_order_no = mer_order_no;
    model.mer_no = mer_no;
    model.version = version;
    
    /// 签名时加了转义字符 传入时也要加转义字符
    model.pay_extraJson = @"{\"buyer_id\":\"\"}";
    ///  开始签名
    model.sign = [self signWithModel:model withMD5KeyString:mer_key];
    
    /// 单个的 调用支付宝
    /// 展示收银台
    [[SDPTController shared]showSDPTDesktopIn:[[UIApplication sharedApplication] keyWindow].rootViewController model:model];
    
    /// 点击支付报错
    [SDPTController shared].payfailureBlock = ^(NSString * messageStr,ProductPyType typeStr){
        
        NSLog(@"调取支付宝支付 下单 提示 信息 %@",messageStr);
    };
    [SDPTController shared].payTypeBlock = ^(ProductPyType  type,NSString * tokenid){
        
        if (type == PyTypeZFBP) {
            NSLog(@"调取 支付tokenid=%@",tokenid);
        }
    };
    NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"success", @"result", @"", @"message", nil];
    result(resultDic);
}

/// 订单创建时间
- (NSString*)getOrderTimming{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateTime = [formatter stringFromDate:date];
    NSLog(@"%@============年-月-日  时：分：秒",dateTime);
    return  dateTime;
}

/// 订单过期时间
-(NSString*)getExpireTimming{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    
    NSString *dateTime = [formatter stringFromDate:date];
    NSLog(@"%@============年-月-日  时：分：秒",dateTime);
    
    NSDate * erxDate =  [[NSCalendar currentCalendar] dateByAddingUnit:(NSCalendarUnitDay) value:30 toDate:date options:NSCalendarSearchBackwards];
    //    let date1 = Calendar.current.date(byAdding: .day, value: -2, to: Date())
    NSString *erxDateTimng = [formatter stringFromDate:erxDate];
    
    return  erxDateTimng;
}

-(NSString *)signWithModel:(XHPayParameterModel*)model withMD5KeyString
                          :(NSString*) md5key {
    NSMutableDictionary * beforSignDic = [NSMutableDictionary dictionary];
    beforSignDic[@"version"] = model.version;
    beforSignDic[@"mer_no"] = model.mer_no;
    beforSignDic[@"mer_order_no"] = model.mer_order_no;
    beforSignDic[@"order_amt"] = model.order_amt;
    beforSignDic[@"create_time"] = model.create_time;
    beforSignDic[@"notify_url"] = model.notify_url;
    beforSignDic[@"create_ip"] = model.create_ip;
    beforSignDic[@"store_id"] = model.store_id;
    
    // pay_extra为空时不参与签名
    if (![self isBlankString:model.pay_extraJson]) {
        
        // 字典里面的内容转成json字符串
        beforSignDic[@"pay_extra"] = model.pay_extraJson;
    }
    
     
    
    beforSignDic[@"accsplit_flag"] = model.accsplit_flag;
    beforSignDic[@"sign_type"] = model.sign_type;
    beforSignDic[@"mer_key"] = model.mer_key;
 

    /// return_url 和activity_no 和 benefit_amount 有值就参与签名 其他的非必须参与签名的参数 都是有值就参与签名 无值不参与签名

    if (model.return_url.length > 0 && ![model.return_url isEqualToString:@""]) {
        beforSignDic[@"return_url"] = model.return_url;
    }

    if (model.benefit_amount.length > 0 && ![model.benefit_amount isEqualToString:@""]) {
        beforSignDic[@"benefit_amount"] = model.benefit_amount;
    }
    if (model.activity_no.length > 0 && ![model.activity_no isEqualToString:@""]) {
        beforSignDic[@"activity_no"] = model.activity_no;
    }
    if (model.extend.length > 0 && ![model.extend isEqualToString:@""]) {
        beforSignDic[@"extend"] = model.extend;
    }

    /// MD5 Key 只在后台
    NSMutableArray *arrayStr = [NSMutableArray array];
    
    NSLog(@" - - -beforSignDic -= - %@",beforSignDic);
    /// 组合
    [beforSignDic enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString *obj, BOOL * _Nonnull stop) {
        [arrayStr addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];

    }];
    
    /// 排序
    NSArray *keyValueArray = [arrayStr sortedArrayUsingSelector:@selector(compare:)];

    NSString *strArr = [keyValueArray componentsJoinedByString:@"&"]; // &为分隔符
    
    
    NSLog(@" - - key Array  -= - %@",strArr);
    
    
    /// 将 MD5 key 拼接在后面 此处代码在后台完成 这里是演示
    
    NSString *    str = [NSString stringWithFormat:@"%@%@",strArr,[NSString stringWithFormat:@"&key=%@",md5key]];
    
    
    NSLog(@"all str -- %@",str);
    
    return [self  MD5_32BIT:str];
}

//md5加密方式 参考。
- (NSString *)MD5_32BIT:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)input.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02X", digest[i]];
    return result;
}

- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

@end
