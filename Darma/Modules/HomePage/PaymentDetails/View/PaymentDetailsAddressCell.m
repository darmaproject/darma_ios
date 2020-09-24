



#import "PaymentDetailsAddressCell.h"

@implementation PaymentDetailsAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.amountLabel];

        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(26);
        make.right.equalTo(self.contentView).offset(-26);
        make.top.equalTo(self.contentView).offset(12);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(26);
        make.right.equalTo(self.contentView).offset(-26);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(26);
        make.right.equalTo(self.contentView).offset(-26);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(7);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-7);
    }];
}
-(void)setDic:(NSDictionary *)dic{
    _nameLabel.text=BITLocalizedCapString(dic[@"title"], nil) ;
    _contentLabel.text=[Tool safeString:[NSString stringWithFormat:@"%@",dic[@"address"]]];
    if (_contentLabel.text.length<=0) {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(26);
            make.right.equalTo(self.contentView).offset(-26);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
            make.height.mas_equalTo(18);
        }];
    }
    _amountLabel.text=[NSString stringWithFormat:@"%@ DMC",dic[@"amount"]];
}


- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _nameLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:11];
        _nameLabel.text =BITLocalizedCapString(@"XXXXX", nil);
        _nameLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contentLabel.text = @"XXXXXXXXXXXXXXXX";
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.numberOfLines=0;
    }
    return _contentLabel;
}
- (UILabel *)amountLabel
{
    if (!_amountLabel)
    {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _amountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _amountLabel.text = @"XXXXXXXX";
        _amountLabel.textAlignment=NSTextAlignmentLeft;
        _amountLabel.numberOfLines=0;
    }
    return _amountLabel;
}


@end
