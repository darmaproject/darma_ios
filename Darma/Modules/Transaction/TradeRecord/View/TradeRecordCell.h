


#import <UIKit/UIKit.h>

#import "TradeDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeRecordCell : UITableViewCell
@property(nonatomic, strong) UILabel *TradePairLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *exchangeLabel;

@property(nonatomic, strong) TradeDetailsModel *model;
@end

NS_ASSUME_NONNULL_END
