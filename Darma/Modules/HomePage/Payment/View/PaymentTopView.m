


#import "PaymentTopView.h"

@interface PaymentTopView()
@property(nonatomic ,strong) UILabel *nameLable;
@property(nonatomic ,strong) UILabel *nameValueLable;
@property(nonatomic ,strong) UILabel *balanceLable;
@property(nonatomic ,strong) UILabel *balanceValueLable;
@end
@implementation PaymentTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.nameLable];
        [self addSubview:self.nameValueLable];
        [self addSubview:self.balanceLable];
        [self addSubview:self.balanceValueLable];
        [self addLayout];
    }
    return self;
}
-(void)addLayout{
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(11);
        make.left.equalTo(self).offset(12);
    }];
    [_nameValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(19);
        make.left.equalTo(self.nameLable);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [_balanceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLable);
        make.right.equalTo(self).offset(-12);
    }];
    [_balanceValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameValueLable);
        make.right.equalTo(self.balanceLable);
        make.width.equalTo(self).multipliedBy(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-11);
    }];
}
-(void)setWalletName:(NSString *)walletName{
    
     _nameValueLable.text=walletName;
}
-(void)setKyAmount:(NSString *)kyAmount{
    if ([kyAmount isEqualToString:@"0"]) {
        kyAmount=@"0.0";
    }
     _balanceValueLable.text= AppwalletFormat_Money(kyAmount);
}


- (UILabel *)nameLable
{
    if (!_nameLable)
    {
        _nameLable = [[UILabel alloc] init];
        _nameLable.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _nameLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _nameLable.text=BITLocalizedCapString(@"Your wallet", nil) ;
        _nameLable.textAlignment=NSTextAlignmentLeft;
    }
    return _nameLable;
}
- (UILabel *)nameValueLable
{
    if (!_nameValueLable)
    {
        _nameValueLable = [[UILabel alloc] init];
        _nameValueLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _nameValueLable.font = [UIFont fontWithName:@"SFDisplay-Compact" size:16];
        _nameValueLable.text=@"xxx";
        _nameValueLable.textAlignment=NSTextAlignmentLeft;
    }
    return _nameValueLable;
}
- (UILabel *)balanceLable
{
    if (!_balanceLable)
    {
        _balanceLable = [[UILabel alloc] init];
        _balanceLable.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _balanceLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _balanceLable.text=BITLocalizedCapString(@"DARMA Available", nil);
    }
    return _balanceLable;
}
- (UILabel *)balanceValueLable
{
    if (!_balanceValueLable)
    {
        _balanceValueLable = [[UILabel alloc] init];
        _balanceValueLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _balanceValueLable.font = [UIFont fontWithName:@"SFDisplay-Compact" size:16];
        _balanceValueLable.text=@"0.00";
        _balanceValueLable.textAlignment=NSTextAlignmentRight;
    }
    return _balanceValueLable;
}
@end
