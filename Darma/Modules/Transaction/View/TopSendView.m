



#import "TopSendView.h"

@implementation TopSendView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleView];
        [self.titleView addSubview:self.titleLable];
        
        [self.contentView addSubview:self.coinNameLable];
        [self.contentView addSubview:self.walletNameLable];
        [self.contentView addSubview:self.amountField];
        [self.contentView addSubview:self.amountLine];
        [self.contentView addSubview:self.tipLable];
        [self.contentView addSubview:self.tip2Lable];

        [self.contentView addSubview:self.addressField];
        [self.contentView addSubview:self.scanButton];
        [self.contentView addSubview:self.selectAddress];
        [self.contentView addSubview:self.addressLine];
        
        
        [self addLayout];
    }
    return self;
}
-(void)addLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.bottom.equalTo(self);
    }];
  
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(17);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(30);
    }];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.titleView);
        make.centerY.equalTo(self.titleView);
    }];


    
    [_coinNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.titleView.mas_bottom).offset(23);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(28);
    }];
    [_amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-30);
        make.left.equalTo(self.coinNameLable.mas_right).offset(20);
        make.centerY.equalTo(self.coinNameLable);
        make.height.mas_equalTo(28);
    }];
  
    
    [_walletNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coinNameLable.mas_right);
        make.left.equalTo(self.coinNameLable.mas_left);
        make.top.equalTo(self.coinNameLable.mas_bottom);
        make.height.mas_equalTo(18);
    }];
    
    [_amountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountField.mas_left).offset(-10);
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.walletNameLable);
        make.height.mas_equalTo(1);
    }];
    
    [_tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountLine.mas_left);
        make.top.equalTo(self.amountLine.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    [_tip2Lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountLine.mas_right);
        make.top.equalTo(self.amountLine.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    [_addressField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLable.mas_bottom).offset(7);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-102);
        make.height.equalTo(@(38));
        
    }];
    [_scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressField);
        make.left.equalTo(self.addressField.mas_right).offset(10);
        make.width.height.equalTo(@(28));
    }];
    
    [_selectAddress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scanButton);
        make.right.equalTo(self.contentView).offset(-30);
        make.width.height.equalTo(@(28));
    }];
    
    [_addressLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressField.mas_bottom);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(1);
        make.bottom.equalTo((self.contentView)).offset(-30).with.priorityLow();
    }];
}

-(void)setScanInfo:(NSDictionary *)scanInfo{
    _addressField.text=scanInfo[@"address"];
  
}
-(void)setSelectInfo:(NSDictionary *)selectInfo{
    _addressField.text=selectInfo[@"walletAddress"];

}

-(UIView*)contentView{
    if (!_contentView) {
        _contentView=[[UIView alloc] init];
        _contentView.backgroundColor=[UIColor colorWithHexString:@"#F9FAFD"];
        _contentView.layer.cornerRadius=12;
        _contentView.layer.masksToBounds=YES;
    }
    return _contentView;
}
-(UIView*)titleView{
    if (!_titleView) {
        _titleView=[[UIView alloc] init];
        _titleView.backgroundColor=[UIColor colorWithHexString:@"#F9FAFD"];
    }
    return _titleView;
}
-(UILabel*)titleLable{
    if (!_titleLable) {
        _titleLable=[[UILabel alloc] init];
        _titleLable.textColor=[UIColor colorWithHexString:@"#202640"];
        _titleLable.font = [UIFont systemFontOfSize:16];
        _titleLable.text=BITLocalizedCapString(@"You will send", nil);
    }
    return _titleLable;
}
-(UILabel*)coinNameLable{
    if (!_coinNameLable) {
        _coinNameLable=[[UILabel alloc] init];
        _coinNameLable.textColor=[UIColor colorWithHexString:@"#202640"];
        _coinNameLable.font = [UIFont systemFontOfSize:20];
        _coinNameLable.text=@"DMC";
    }
    return _coinNameLable;
}
-(UILabel*)walletNameLable{
    if (!_walletNameLable) {
        _walletNameLable=[[UILabel alloc] init];
        _walletNameLable.textColor=[UIColor colorWithHexString:@"#9CA8B3"];
        _walletNameLable.font = [UIFont systemFontOfSize:11];
        _walletNameLable.text=@"ABC";
    }
    return _walletNameLable;
}
-(UITextField*)amountField{
    if (!_amountField) {
        _amountField=[[UITextField alloc] init];
        _amountField.textColor=[UIColor colorWithHexString:@"#9CA8B3"];
        _amountField.font = [UIFont systemFontOfSize:16];
        _amountField.text=@"";
        _amountField.placeholder=@"0.00";
        _amountField.textAlignment=NSTextAlignmentRight;
    }
    return _amountField;
}
-(UILabel*)amountLine{
    if (!_amountLine) {
        _amountLine=[[UILabel alloc] init];
        _amountLine.backgroundColor=[UIColor colorWithHexString:@"#E5E7EC"];
    }
    return _amountLine;
}
-(UILabel*)tipLable{
    if (!_tipLable) {
        _tipLable=[[UILabel alloc] init];
        _tipLable.textColor=[UIColor colorWithHexString:@"#9CA8B3"];
        _tipLable.font = [UIFont systemFontOfSize:11];
        _tipLable.text=@"min：0.00 DMC";
    }
    return _tipLable;
}
-(UILabel*)tip2Lable{
    if (!_tip2Lable) {
        _tip2Lable=[[UILabel alloc] init];
        _tip2Lable.textColor=[UIColor colorWithHexString:@"#9CA8B3"];
        _tip2Lable.font = [UIFont systemFontOfSize:11];
        _tip2Lable.text=@"max：0.00 USDT";
    }
    return _tip2Lable;
}

- (UITextField *)addressField
{
    if (!_addressField)
    {
        _addressField = [[UITextField alloc] init];
        _addressField.placeholder =@"Address";

        _addressField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _addressField.textColor = [UIColor colorWithHexString:@"#202640"];
    }
    return _addressField;
}
- (UIButton *)scanButton
{
    if (!_scanButton)
    {
        _scanButton = [[UIButton alloc] init];
        [_scanButton setImage: [UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
    }
    return _scanButton;
}
- (UIButton *)selectAddress
{
    if (!_selectAddress)
    {
        _selectAddress = [[UIButton alloc] init];
        [_selectAddress setImage: [UIImage imageNamed:@"walletAddress"] forState:UIControlStateNormal];
    }
    return _selectAddress;
}
- (UILabel *)addressLine
{
    if (!_addressLine)
    {
        _addressLine = [[UILabel alloc] init];
        
        _addressLine.backgroundColor = [UIColor colorWithHexString:@"#E8EAED"];
    }
    return _addressLine;
}
@end
