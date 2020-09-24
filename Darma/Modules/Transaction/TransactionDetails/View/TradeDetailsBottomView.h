


#import <UIKit/UIKit.h>

#import "TradeDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TradeDetailsBottomView;
@protocol  TradeDetailsBottomViewDelegate<NSObject>
-(void)Timeout:(TradeDetailsBottomView *)bottomView;
@end

@interface TradeDetailsBottomView : UIView
@property(nonatomic, strong) UILabel *orderIDLabel;
@property(nonatomic, strong) UILabel *orderIDValueLabel;
@property(nonatomic, strong) UIButton *orderIDCopyBtn;
@property (nonatomic,strong)UILabel *orderIDLine;


@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UILabel *addressValueLabel;
@property(nonatomic, strong) UIButton *addressCopyBtn;
@property (nonatomic,strong)UILabel *addressLine;

@property (nonatomic,strong)UILabel *tipInfoLable;
@property (nonatomic,strong)UILabel *tipLable;

@property (nonatomic,strong)UIImageView *timeImageV;
@property (nonatomic,strong)UILabel *timeLable;
@property(nonatomic, strong) TradeDetailsModel *model;

@property(nonatomic,assign)id<TradeDetailsBottomViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
