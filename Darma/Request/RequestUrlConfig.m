

#import "RequestUrlConfig.h"

@implementation RequestUrlConfig

+ (NSString *)getRateURL{
    NSString *url=[NSString stringWithFormat:@"%@order_parameter_query",URL_server];
    return url;
}

+ (NSString *)getCreateOrderURL{
    NSString *url=[NSString stringWithFormat:@"%@order_create",URL_server];
    return url;
}

+ (NSString *)getQueryOrderURL{
    NSString *url=[NSString stringWithFormat:@"%@order_status_query",URL_server];
    return url;
}

+ (NSString *)getQueryPriceURL{
    NSString *url=[NSString stringWithFormat:@"%@order_check_price",URL_server];
    return url;
}
+ (NSString *)getExchangeStatusURL{
    NSString *url=[NSString stringWithFormat:@"%@exchange_status",URL_server];
    return url;
}
@end
