



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentManager : NSObject


-(void)transfer:(NSString* _Nonnull)walletAddress amountstr:(NSString* _Nonnull)amountstr unlock_time_str:(NSString* _Nonnull)unlock_time_str payment_id:(NSString* _Nonnull)payment_id mixin:(long)mixin sendtx:(BOOL)sendtx password:(NSString* _Nonnull)password isAll:(BOOL)isAll success:(void(^)(NSDictionary *transferInfo))success fail:(void(^)(NSDictionary *error))fail;
@end

NS_ASSUME_NONNULL_END
