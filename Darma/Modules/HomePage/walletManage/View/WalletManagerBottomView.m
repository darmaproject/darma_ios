



#import "WalletManagerBottomView.h"

@interface WalletManagerBottomView()
@property(nonatomic, strong)UIButton  *createBtn;
@property(nonatomic, strong)UIButton  *reaginBtn;
@end
@implementation WalletManagerBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
        [self addSubview:self.createBtn];
        [self addSubview:self.reaginBtn];
        [self addLayout];
    }
    return self;
}
- (void)addLayout
{
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@44);
        make.width.equalTo(@160);
        
    }];
    
    [_reaginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self.createBtn);
        make.width.equalTo(self.createBtn.mas_width);
        make.height.equalTo(self.createBtn.mas_height);
        make.bottom.equalTo(self).offset(-10);
    }];
}
-(void)create:(UIButton *)sender{
   
    if (_delegate && [_delegate respondsToSelector:@selector(createWallet)]) {
        [_delegate createWallet];
    }
}
-(void)reagin:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(raginWallet)]) {
        [_delegate raginWallet];
    }
   
}

- (UIButton *)createBtn
{
    if (!_createBtn)
    {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setTitle:BITLocalizedCapString(@"Create Wallet",nil) forState:UIControlStateNormal];
        _createBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_createBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        _createBtn.layer.cornerRadius=8.0f;
        _createBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _createBtn.layer.borderWidth=1.0f;
        _createBtn.layer.masksToBounds=YES;
        [_createBtn addTarget:self action:@selector(create:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
- (UIButton *)reaginBtn
{
    if (!_reaginBtn)
    {
        _reaginBtn = [[UIButton alloc] init];
        [_reaginBtn setTitle:BITLocalizedCapString(@"Recover Wallet",nil) forState:UIControlStateNormal];
        _reaginBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_reaginBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_reaginBtn setBackgroundColor:[UIColor colorWithHexString:@"#F9F5FA"]];
        _reaginBtn.layer.cornerRadius=8.0f;
        _reaginBtn.layer.borderColor=[UIColor colorWithHexString:@"#AF7EC1"].CGColor;
        _reaginBtn.layer.borderWidth=1.0f;
        _reaginBtn.layer.masksToBounds=YES;
        
        [_reaginBtn addTarget:self action:@selector(reagin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reaginBtn;
}

@end
