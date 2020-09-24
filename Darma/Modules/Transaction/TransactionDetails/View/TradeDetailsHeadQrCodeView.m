



#import "TradeDetailsHeadQrCodeView.h"

#import "UIImage+Category.h"

@implementation TradeDetailsHeadQrCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.qrImageView];

        [self addSubview:self.amountLabel];
        [self addSubview:self.amountValueLabel];
        [self addSubview:self.amountLine];
        
        [self addSubview:self.statusLabel];
        [self addSubview:self.statusValueLabel];
        [self addSubview:self.statusLine];
        [self addLayout];
    }
    return self;
}
- (void)addLayout
{
    [_qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FitH(10));
        make.right.equalTo(self).offset(-FitW(18));
        make.width.height.equalTo(@(Fit(120)));
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FitH(25));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self).offset(-FitW(26));
        make.height.mas_equalTo(FitH(20));
    }];
    [_amountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).offset(FitH(5));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self.qrImageView.mas_left).offset(-FitW(40));
    }];
    
    [_amountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self.qrImageView.mas_left).offset(-FitW(30));
        make.top.equalTo(self.amountValueLabel.mas_bottom).offset(FitH(7));
        make.height.mas_equalTo(1);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLine.mas_bottom).offset(FitH(8));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self.qrImageView.mas_left).offset(-FitW(40));
        make.height.mas_equalTo(FitH(20));
    }];
    [_statusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(FitH(15));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self.qrImageView.mas_left).offset(-FitW(40));
    }];
    
    [_statusLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusValueLabel.mas_bottom).offset(FitH(7));
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(-FitW(18));
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
        
    }];
}
-(void)setModel:(TradeDetailsModel *)model{
    NSArray *arry=[model.pair componentsSeparatedByString:@"_"];
    _amountValueLabel.text=[NSString stringWithFormat:@"%@ %@",model.base_amount_total,[[arry firstObject] uppercaseString]];
    _statusValueLabel.text=[NSString stringWithFormat:@"%@",model.state_string];
    NSString * str_QrCode=[NSString stringWithFormat:@"%@",model.base_receiving_integrated_address];
    UIImage *image = [UIImage generateCustomQRCode:str_QrCode andSize:Fit(140) andColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    _qrImageView.image = image;
}


- (UIImageView *)qrImageView
{
    if (!_qrImageView)
    {
        _qrImageView = [[UIImageView alloc] init];
        _qrImageView.image = [UIImage imageNamed:@"QrCode"];
    }
    return _qrImageView;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel)
    {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _amountLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:11];
        _amountLabel.text =BITLocalizedCapString(@"Amount", nil);
        _amountLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _amountLabel;
}

- (UILabel *)amountValueLabel
{
    if (!_amountValueLabel)
    {
        _amountValueLabel = [[UILabel alloc] init];
        _amountValueLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _amountValueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:22];
        _amountValueLabel.text = @"0.00 USDT";
        _amountValueLabel.textAlignment=NSTextAlignmentLeft;
        _amountValueLabel.numberOfLines=0;
    }
    return _amountValueLabel;
}
-(UILabel*)amountLine{
    if (!_amountLine) {
        _amountLine=[[UILabel alloc] init];
        _amountLine.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _amountLine;
}
- (UILabel *)statusLabel
{
    if (!_statusLabel)
    {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _statusLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:11];
        _statusLabel.text =BITLocalizedCapString(@"Status", nil);
        _statusLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _statusLabel;
}

- (UILabel *)statusValueLabel
{
    if (!_statusValueLabel)
    {
        _statusValueLabel = [[UILabel alloc] init];
        _statusValueLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _statusValueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _statusValueLabel.text = @"";
        _statusValueLabel.textAlignment=NSTextAlignmentLeft;
        _statusValueLabel.numberOfLines=0;
    }
    return _statusValueLabel;
}
-(UILabel*)statusLine{
    if (!_statusLine) {
        _statusLine=[[UILabel alloc] init];
        _statusLine.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _statusLine;
}
@end
