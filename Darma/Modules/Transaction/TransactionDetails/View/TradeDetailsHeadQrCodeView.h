



#import <UIKit/UIKit.h>

#import "TradeDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeDetailsHeadQrCodeView : UIView

@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UILabel *amountValueLabel;
@property (nonatomic,strong)UILabel *amountLine;

@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, strong) UILabel *statusValueLabel;
@property (nonatomic,strong)UILabel *statusLine;

@property(nonatomic, strong) UIImageView *qrImageView;
@property(nonatomic, strong) TradeDetailsModel *model;

@end

NS_ASSUME_NONNULL_END
