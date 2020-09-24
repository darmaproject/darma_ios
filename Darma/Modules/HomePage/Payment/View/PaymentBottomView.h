



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentBottomView : UIView
@property(nonatomic, strong) UITextView *addressField;
@property(nonatomic, strong) UIButton *scanButton;
@property(nonatomic, strong)  UIButton *selectAddress;
@property(nonatomic, strong) UILabel *addressLine;

@property(nonatomic, strong) UITextView *paymentField;
@property(nonatomic, strong) UILabel *paymentLine;

@property(nonatomic, strong) UITextField *amountField;
@property(nonatomic, strong)UIButton *AllButton;
@property(nonatomic, strong) UILabel *amountLine;

@property(nonatomic, strong) UITextField *notesField;
@property(nonatomic, strong) UILabel *notesLine;

@property(nonatomic, strong) UILabel *markLable;

@property (nonatomic, strong) NSDictionary * scanInfo;
@property (nonatomic, strong) NSDictionary * selectInfo;

@end

NS_ASSUME_NONNULL_END
