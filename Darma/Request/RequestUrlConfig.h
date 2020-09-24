

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define URL_server @"http://darmacash.com:2328/api/v1/"

@interface RequestUrlConfig : NSObject

+ (NSString *)getRateURL;

+ (NSString *)getCreateOrderURL;

+ (NSString *)getQueryOrderURL;

+ (NSString *)getQueryPriceURL;

+ (NSString *)getExchangeStatusURL;
@end

NS_ASSUME_NONNULL_END
