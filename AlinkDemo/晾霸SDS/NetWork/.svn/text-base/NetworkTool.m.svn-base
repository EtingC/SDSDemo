//
//  NetworkTool.m
//  XHH_networkTool
//
//  Created by xiaohuihui on 2017/10/10.
//  Copyright ©  All rights reserved.
//

#import "NetworkTool.h"
#import "UsingHUD.h"
#define POWER_DOMAINNAME                @"bizappmanage.ibroadlink.com"

@implementation NetworkTool

+ (instancetype)sharedTool {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
        
    });
    
    return instance;
}
#pragma mark - 设置请求头
- (void)setHeaderWithAFHTTPSessionManager:(AFHTTPSessionManager *)manager header:(NSDictionary *)header {
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}
#pragma mark - 获取产品类型
-(void)getProductKindsuccess:(successBlockWithId)success failure:(failureBlockWithId)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //允许非安全访问
    //    NSArray *languages = [NSLocale preferredLanguages];
    //    NSString *currentLanguage = [languages objectAtIndex:0];
    //    NSString *preferredLang = [currentLanguage lowercaseString];
    //    NSLog(@"%@",preferredLang);
    //
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    //设置内容请求响应类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSDictionary *body = @{
                           @"pricategoryid":@"00000001",
                           @"queryinfo":@{
                                   @"locate":@"abroad",
                                   @"system":@"ios",
                                   @"language":@"en",
                                   @"licenseid":POWER_LID,
                                   }
                           };
    NSDictionary *header = @{
                             @"UserId":[DATACache objectForKey:USERID],
                             @"language":@"en",
                             @"licenseid":POWER_LID
                             };
    [self setHeaderWithAFHTTPSessionManager:manager header:header];
    NSString *urlString= [NSString stringWithFormat:@"https://%@%@%@",POWER_LID,POWER_DOMAINNAME,@"/ec4/v1/system/getcategorylist"];
    //@"https://d0f94faa04c63d9b7b0b034dcf895656bizappmanage.ibroadlink.com/ec4/v1/system/getcategorylist"
    [manager POST:urlString parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"reponse is %@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error.userInfo);
    }];
    
}
#pragma mark - 获取产品型号
-(void)getProductModelWithCategoryid:(NSString *)categoryid success:(successBlockWithId)success failure:(failureBlockWithId)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    NSArray *languages = [NSLocale preferredLanguages];
    //    NSString *currentLanguage = [languages objectAtIndex:0];
    //    NSString *preferredLang = [currentLanguage lowercaseString];
    //    NSLog(@"%@",preferredLang);
    
    //允许非安全访问
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    //设置内容请求响应类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary *body = @{
                           @"categoryid":categoryid,
                           @"queryinfo":@{
                                   @"locate":@"abroad",
                                   @"system":@"ios",
                                   @"language":@"en",
                                   @"licenseid":POWER_LID,
                                   }
                           };
    NSDictionary *header = @{
                             @"UserId":[DATACache objectForKey:USERID],
                             @"language":@"en",
                             @"licenseid":POWER_LID
                             };
    [self setHeaderWithAFHTTPSessionManager:manager header:header];
    NSString *urlString= [NSString stringWithFormat:@"https://%@%@%@",POWER_LID,POWER_DOMAINNAME,@"/ec4/v1/system/getproductlist"];
    //@"https://d0f94faa04c63d9b7b0b034dcf895656bizappmanage.ibroadlink.com/ec4/v1/system/getproductlist
    [manager POST:urlString parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"reponse is %@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
#pragma mark - 获取型号的详细信息
-(void)getProductDetailWithProductPid:(NSString *)productPid success:(successBlockWithId)success failure:(failureBlockWithId)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    NSArray *languages = [NSLocale preferredLanguages];
    //    NSString *currentLanguage = [languages objectAtIndex:0];
    //    NSString *preferredLang = [currentLanguage lowercaseString];
    //    NSLog(@"%@",preferredLang);
    //允许非安全访问
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    //设置内容请求响应类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary *body = @{
                           @"pid":productPid,
                           @"queryinfo":@{
                                   @"locate":@"abroad",
                                   @"system":@"ios",
                                   @"language":@"en",
                                   @"licenseid":POWER_LID,
                                   }
                           };
    NSDictionary *header = @{
                             @"UserId":[DATACache objectForKey:USERID],
                             @"language":@"en",
                             @"licenseid":POWER_LID
                             };
    [self setHeaderWithAFHTTPSessionManager:manager header:header];
    NSString *urlString= [NSString stringWithFormat:@"https://%@%@%@",POWER_LID,POWER_DOMAINNAME,@"/ec4/v1/system/getproductdetail"];
    //@"https://d0f94faa04c63d9b7b0b034dcf895656bizappmanage.ibroadlink.com/ec4/v1/system/getproductlist
    [manager POST:urlString parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"reponse is %@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }]; 
}

- (void)getServerDeviceFirmwareVersionWithDeviceType:(NSInteger)deviceType localVersion:(NSInteger)localVersion success:(successBlockWithId)success failure:(failureBlockWithId)failure
{    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    self.requestSerializer= [AFHTTPRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%zd", BL_GET_FIRMWARE_VERSION_FROM_SRV, deviceType];
//
//    {
//        44 =     {
//            versions =         (
//                                {
//                                    changelog =                 {
//                                        cn = "\U66f4\U65b0\U5185\U5bb9\Uff1a\n\U7248\U672c\U66f4\U65b0";
//                                        en = "updating:\nversion update";
//                                    };
//                                    date = "2017-12-15";
//                                    url = "http://cn-fwversions.ibroadlink.com/firmware/download/20445/KV-BL-SDS-1931-16.7z.upd.bin";
//                                    version = 16;
//                                }
//                                );
//        };
//    }
    
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"44"];
        NSArray *versions = [dict objectForKey:@"versions"];
        NSDictionary *infoDict = [versions objectAtIndex:0];
        success(infoDict);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
- (void)requestWithURLparameters:(NSDictionary *)parameters
                      method: (NSString *)method
                        View:(UIView*)view
        sessionExpiredOption:(NSInteger)sessionExpiredOption
                   needLogin:(BOOL)needLogin
                    callBack: (void(^)(AlinkResponse* responseObject))callBack  errorBack: (void(^)(id error))errorBack{
    if (view != nil) {
         [UsingHUD showInView:view];
    }
    
     AlinkRequest *request = [[AlinkRequest alloc] init];
     request.method = method;
     request.params = parameters;
     request.needLogin = needLogin; //YES or NO
     request.sessionExpiredOption = sessionExpiredOption;
     [AlinkSDK.sharedManager invokeWithRequest:request completionHandler:^(AlinkResponse * _Nonnull response) {
        NSError *outError = nil;
        if (response.successed) {
            NSLog(@"--------------------------------------%@",response);
            
                 [UsingHUD hideInView:view];
            
          
            callBack(response);
            
        }
        else {
        
           
            outError = response.responseError;
         
            [UsingHUD hideInView:view];
            if (outError.code == LKDCErrCodeIllegalToken) {
                //账号登录超过一个时期，账号token失效，此时需要调起登录页面重新登录一下账号。这个错误必须处理。否则重试还会失败
                if ([CommonUtil isLoginExpired:outError.code]) {
                    
                    NSLog(@"session过期了 需要重新登录");
                }
            }else{
               [CommonUtil setTip:[self backErrorCode:[NSString stringWithFormat:@"%ld",outError.code]]];
            }
            errorBack(outError);
//
          NSLog(@"outErroroutErroroutErroroutErroroutError=======%@",outError );
        }
    }];
}
-(NSString *)backErrorCode:(NSString *)code{
    
    if ([code isEqualToString:@"1000"]) {          
        return @"服务端请求成功";
    }
    if ([code isEqualToString:@"2001"]) {
        return @"系统未知错误";
    }
    if ([code isEqualToString:@"3001"]) {
        return @" 设备未登入wsf";
    }
    if ([code isEqualToString:@"3002"]) {
        return @" app 为登入wsf";
    }
    if ([code isEqualToString:@"3009"]) {
        return @"缺少必要的参数";
    }
    if ([code isEqualToString:@"3010"]) {
        return @" 请求方法不正确";
    }
    if ([code isEqualToString:@"3011"]) {
        return @" cid不正确";
    }
    if ([code isEqualToString:@"3012"]) {
        return @"cid不正确";
    }
    if ([code isEqualToString:@"3015"]) {
        return @"请求节点不正确";
    }
    if ([code isEqualToString:@"3019"]) {
        return @"设备不存在";
    }
    if ([code isEqualToString:@"3020"]) {
        return @"设备型号为空";
    }
    if ([code isEqualToString:@"3021"]) {
        return @"MAC为空";
    }
    if ([code isEqualToString:@"3023"]) {
        return @"请求参数过长";
    }
    if ([code isEqualToString:@"3024"]) {
        return @"reqdata为空";
    }if ([code isEqualToString:@"3025"]) {
        return @" 请求方法不正确";
    }if ([code isEqualToString:@"3026"]) {
        return @" 请求参数为空";
    }if ([code isEqualToString:@"3027"]) {
        return @"请求参数错误";
    }
    if ([code isEqualToString:@"3028"]) {
        return @"设备已注册";
    }
    if ([code isEqualToString:@"3029"]) {
        return @" 注册uuid失败";
    }
    if ([code isEqualToString:@"3030"]) {
        return @"添加设备信息失败";
    }
    if ([code isEqualToString:@"3031"]) {
        return @"初始化UUID私钥失败";
    }
    if ([code isEqualToString:@"3032"]) {
        return @"私钥签名失败";
    }
    if ([code isEqualToString:@"3033"]) {
        return @"ACTUUID HMAC失败";
    }
    if ([code isEqualToString:@"3034"]) {
        return @"UUID添加失败";
    }
    if ([code isEqualToString:@"3035"]) {
        return @"UUID激活失败";
    }
    if ([code isEqualToString:@"3036"]) {
        return @"UUID没有注册";
    }
    if ([code isEqualToString:@"3037"]) {
        return @"无效UUID";
    }
    if ([code isEqualToString:@"3038"]) {
        return @"无效子设备UUID";
    }if ([code isEqualToString:@"3039"]) {
        return @"无效service";
    }
    if ([code isEqualToString:@"3040"]) {
        return @"当注册表不匹配uuidgen时";
    }
    if ([code isEqualToString:@"3041"]) {
        return @"注册sn长度太小，需要6个字节";
    }
    if ([code isEqualToString:@"3042"]) {
        return @"注册mac长度太小，需要6个字节";
    }
    if ([code isEqualToString:@"3043"]) {
        return @"注册sn的长度超过128";
    }
    if ([code isEqualToString:@"3044"]) {
        return @"uuid gen只支持mac或sn";
    }
    if ([code isEqualToString:@"3045"]) {
        return @"sn包含非法字符";
    }
    if ([code isEqualToString:@"3046"]) {
        return @"操作设备token失败";
    }
    if ([code isEqualToString:@"3047"]) {
        return @"找不到设备token";
    }
    if ([code isEqualToString:@"3048"]) {
        return @"设备身份未找到";
    }
    if ([code isEqualToString:@"3049"]) {
        return @"设备产品未找到";
    }
    if ([code isEqualToString:@"3050"]) {
        return @"上报空数据";
    }
    if ([code isEqualToString:@"3060"]) {
        return @"设备token不匹配";
    }
    if ([code isEqualToString:@"3061"]) {
        return @"alink版本在当前请求中是非法的";
    }
    if ([code isEqualToString:@"3062"]) {
        return @"未找到设备功能解析器";
    }
    if ([code isEqualToString:@"3063"]) {
        return @"设备功能库未找到";
    }
    if ([code isEqualToString:@"3064"]) {
        return @"mac或sn白名单没有注册";
    }
    //--
    if ([code isEqualToString:@"3065"]) {
        return @"子设备关系不存在";
    }
    if ([code isEqualToString:@"3066"]) {
        return @"子设备未注册";
    }
    if ([code isEqualToString:@"3071"]) {
        return @"时间戳不在有效范围内";
    }
    if ([code isEqualToString:@"3072"]) {
        return @"请求无访问key错误";
    }
    if ([code isEqualToString:@"3073"]) {
        return @"请求无访问secret错误";
    }
    
    if ([code isEqualToString:@"3074"]) {
        return @"签名不一致";
    }
    if ([code isEqualToString:@"3075"]) {
        return @"签名认证模块认证参数失败";
    }
    if ([code isEqualToString:@"3076"]) {
        return @"解绑所需包含参数为空";
    }
    if ([code isEqualToString:@"3077"]) {
        return @"解绑账号不存在";
    }if ([code isEqualToString:@"3078"]) {
        return @"解绑设备不存在";
    }
    if ([code isEqualToString:@"3079"]) {
        return @"企业云账号不存在";
    }if ([code isEqualToString:@"3080"]) {
        return @"物联网云账号不存在";
    }
    //---
    if ([code isEqualToString:@"3081"]) {
        return @"设备型号不存在";
    }
    if ([code isEqualToString:@"3082"]) {
        return @"无绑定关系";
    }
    if ([code isEqualToString:@"3083"]) {
        return @"token非法";
    }
    if ([code isEqualToString:@"3084"]) {
        return @"登录的Token非法";
    }
    if ([code isEqualToString:@"3085"]) {
        return @"找不到 key-secret";
    }
    if ([code isEqualToString:@"3086"]) {
        return @"已经被授权绑定";
    }
    if ([code isEqualToString:@"3090"]) {
        return @"绑定该设备的账号太多";
    }
    if ([code isEqualToString:@"3091"]) {
        return @"账号绑定太多设备";
    }
    if ([code isEqualToString:@"3095"]) {
        return @"解除帐户设备关系错误";
    }
    if ([code isEqualToString:@"3096"]) {
        return @"key为空";
    }
    if ([code isEqualToString:@"3097"]) {
        return @"解密请求失败";
    }
    if ([code isEqualToString:@"3099"]) {
        return @"SN为空";
    }if ([code isEqualToString:@"3100"]) {
        return @"lua脚本准备异常";
    }
    if ([code isEqualToString:@"3101"]) {
        return @"lua脚本执行异常";
    }
    
    if ([code isEqualToString:@"3201"]) {
        return @"非法账号";
    }
    if ([code isEqualToString:@"3202"]) {
        return @"参数过长";
    }
    if ([code isEqualToString:@"3203"]) {
        return @"账户已经绑定";
    }
    if ([code isEqualToString:@"3606"]) {
        return @"产品型号与设备型号没有关联";
    }
    if ([code isEqualToString:@"3049"]) {
        return @"设备uuid无效";
    }
    if ([code isEqualToString:@"3061"]) {
        return @"设备udid版本不匹配";
    }
    if ([code isEqualToString:@"3608"]) {
        return @"设备正在绑定授权中";
    }
    if ([code isEqualToString:@"3601"]) {
        return @"授权码不存在";
    }
    if ([code isEqualToString:@"3609"]) {
        return @"授权码非法";
    }
    if ([code isEqualToString:@"3207"]) {
        return @"未完成绑定授权";
    }
    if ([code isEqualToString:@"3204"]) {
        return @"设备已经存在管理员";
    }
    
    if ([code isEqualToString:@"3205"]) {
        return @"账号不是管理员";
    }
    if ([code isEqualToString:@"3206"]) {
        return @"二维码过期";
    }
    if ([code isEqualToString:@"3208"]) {
        return @"二维码不存在";
    }
    if ([code isEqualToString:@"3212"]) {
        return @"二维码无效";
    }
    if ([code isEqualToString:@"5107"]) {
        return @"场景时区设置错误";
    }
    if ([code isEqualToString:@"5110"]) {
        return @"场景无效的时间设置";
    }
    if ([code isEqualToString:@"5115"]) {
        return @"场景数量已达上限";
    }
    if ([code isEqualToString:@"12104"]) {
        return @"设备没有联网";
    }
    
    if ([code isEqualToString:@"19007"]) {
        return @"非法的设备uuid,不是当前品牌商的";
    }
    if ([code isEqualToString:@"19008"]) {
        return @"非法的设备model,不是当前品牌商的";
    }
   
    return @"请求失败";
}
@end
