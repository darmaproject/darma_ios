

#import "RequestAPIManager.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation RequestAPIManager

-(void)GETRequestRate:(NSString *)coinName1 coinName2:(NSString *)coinName2 success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail{
    NSString *string=[NSString stringWithFormat:@"%@_%@",coinName1,coinName2];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:string forKey:@"pair"];
    
    [[RequestManager manager] GET:[RequestUrlConfig getRateURL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(task, error);
        }
    }];
}
-(void)POSTRequestCreateOrder:(NSDictionary *)params success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
            
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSString *timeSP=[self getCurrentTimestamp];
    NSString  *sign=[NSString stringWithFormat:@"%@POST%@",timeSP,mutStr];
    NSString *headString=[self hmacSHA256WithSecret:@"api_secret_key" content:sign];
    [[RequestManager manager].requestSerializer setValue:headString forHTTPHeaderField:@"BT-ACCESS-SIGN"];
    [[RequestManager manager].requestSerializer setValue:timeSP forHTTPHeaderField:@"BT-ACCESS-TIMESTAMP"];

    [[RequestManager manager] POST:[RequestUrlConfig getCreateOrderURL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(task, error);
        }
    }];
}
-(void)GETRequestQueryOrder:(NSString *)orderId success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:orderId forKey:@"order_id"];
    [[RequestManager manager] GET:[RequestUrlConfig getQueryOrderURL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(task, error);
        }
    }];
}
-(void)GETRequestQueryPrice:(NSString *)coinName1 coinName2:(NSString *)coinName2 amount:(NSString *)amount success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail{
    NSString *string=[NSString stringWithFormat:@"%@_%@",coinName1,coinName2];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:string forKey:@"pair"];
    [params setValue:amount forKey:@"amount"];

    [[RequestManager manager] GET:[RequestUrlConfig getQueryPriceURL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(task, error);
        }
    }];
}
-(void)GETExchangeStatusSuccess:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail{
    
    [[RequestManager manager] GET:[RequestUrlConfig getExchangeStatusURL] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(task, error);
        }
    }];
}


-(NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content
{
    const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [content cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

-(NSString *)getCurrentTimestamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *Date=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: Date];
    NSDate *currentDate = [Date  dateByAddingTimeInterval: interval];
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[currentDate timeIntervalSince1970]] integerValue];
    NSString *str_timeSp=[NSString stringWithFormat:@"%ld",timeSp];
    
    return str_timeSp;
}
@end
