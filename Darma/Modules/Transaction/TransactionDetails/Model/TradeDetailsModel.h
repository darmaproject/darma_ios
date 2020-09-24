



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradeDetailsModel : NSObject
@property(nonatomic, strong) NSString *base_amount_remaining;

@property(nonatomic, strong) NSString *base_amount_total;
@property(nonatomic, strong) NSString * base_receiving_address; 
@property(nonatomic, strong) NSString * base_receiving_integrated_address; 

@property(nonatomic, strong) NSString * base_received_amount; 


@property(nonatomic, strong) NSString *  created_at;
@property(nonatomic, strong) NSString * expires_at;
@property(nonatomic, strong) NSString * final_price;


@property(nonatomic, strong) NSString *  order_id;
@property(nonatomic, strong) NSString * order_price;
@property(nonatomic, strong) NSString *  pair;
@property(nonatomic, strong) NSString * quota_amount;
@property(nonatomic, strong) NSString * payment_id;

@property(nonatomic, strong) NSString *  quota_dest_address;
@property(nonatomic, strong) NSString * seconds_till_timeout;

@property(nonatomic, strong) NSString * quota_real_amount;
@property(nonatomic, strong) NSString * quota_transaction_id;

@property(nonatomic, strong) NSString * state;
@property(nonatomic, strong) NSString * state_string;

@property(nonatomic, strong) NSString * refund_address;
@property(nonatomic, strong) NSString * refund_amount;
@property(nonatomic, strong) NSString * base_transaction_id;
@end

NS_ASSUME_NONNULL_END
