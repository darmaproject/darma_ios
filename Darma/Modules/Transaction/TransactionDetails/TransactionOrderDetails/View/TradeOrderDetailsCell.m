

#import "TradeOrderDetailsCell.h"

@interface TradeOrderDetailsCell()
@property(nonatomic, strong) UILabel *titleLabel;

@end
@implementation TradeOrderDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.cpButton];
        [self addLayout];
    }
    return self;
}


- (void)addLayout
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FitH(12));
        make.left.equalTo(self.contentView).offset(FitW(26));
        make.right.equalTo(self.contentView).offset(FitW(-17));
        
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(FitH(5));
        make.left.equalTo(self.contentView).offset(FitW(26));
        make.right.equalTo(self.contentView).offset(FitW(-17-22));
        make.bottom.equalTo(self.contentView).offset(FitH(-12));
    }];
    
    [_cpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(FitW(-17));
        make.width.mas_equalTo(Fit(22));
        make.height.mas_equalTo(Fit(22));
    }];
}

-(void)setInfoDict:(NSDictionary *)infoDict{
    _titleLabel.text=BITLocalizedCapString(infoDict[@"title"], nil);
    _contentLabel.text=infoDict[@"content"];
    if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Order Amount", nil)]) {
        _contentLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];

    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Sent Amount", nil)]) {
        _contentLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];

    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Total Transaction Amount", nil)]) {
        _contentLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];

    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Amount to be Returned", nil)]||[infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Returned Amount", nil)]) {
        _contentLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    }else{
        _contentLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    
    if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"ID", nil)]) {
        _cpButton.hidden=NO;
    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Send Address", nil)]) {
        _cpButton.hidden=NO;
    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Receive Address", nil)]) {
        _cpButton.hidden=NO;
    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Send TXID", nil)]) {
        _cpButton.hidden=NO;
    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Receive TXID", nil)]) {
        _cpButton.hidden=NO;
    }else if ([infoDict[@"title"] isEqualToString:BITLocalizedCapString(@"Refund Address", nil)]) {
        _cpButton.hidden=NO;
    }else{
        _cpButton.hidden=YES;
    }
    
}


- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _titleLabel.text =@"xxxx";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contentLabel.text = @"xxxx";
        _contentLabel.numberOfLines=0;
    }
    return _contentLabel;
}
- (UIButton *)cpButton
{
    if (!_cpButton)
    {
        _cpButton = [[UIButton alloc] init];
        [_cpButton setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
        _cpButton.hidden=YES;
    }
    return _cpButton;
}
@end
