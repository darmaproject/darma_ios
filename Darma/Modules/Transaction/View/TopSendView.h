


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopSendView : UIView
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UILabel *titleLable;

@property (nonatomic,strong)UILabel *coinNameLable;
@property (nonatomic,strong)UILabel *walletNameLable;
@property (nonatomic,strong)UITextField *amountField;
@property (nonatomic,strong)UILabel *amountLine;
@property (nonatomic,strong)UILabel *tipLable;
@property (nonatomic,strong)UILabel *tip2Lable;

@property (nonatomic,strong)UITextField *addressField;
@property (nonatomic,strong)UIButton *scanButton;
@property (nonatomic,strong)UIButton *selectAddress;
@property (nonatomic,strong)UILabel *addressLine;

@property (nonatomic,strong)NSString *isChange;

@end

NS_ASSUME_NONNULL_END
