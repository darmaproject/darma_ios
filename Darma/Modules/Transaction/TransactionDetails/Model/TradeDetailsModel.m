



#import "TradeDetailsModel.h"

@implementation TradeDetailsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"payment_id"  : @"base_required_payment_id_long",
             };
}

@end
