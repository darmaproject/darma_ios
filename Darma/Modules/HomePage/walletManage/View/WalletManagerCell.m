



#import "WalletManagerCell.h"

@interface WalletManagerCell()
@end
@implementation WalletManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.typeImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.addressLabel];

        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(17);
    }];
  
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
        make.centerX.equalTo(self.contentView);
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.left.equalTo(self.contentView).offset(17);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-14);
    }];
}
-(void)setDict:(NSDictionary *)dict{
    _nameLabel.text=dict[@"name"];
    _addressLabel.text=dict[@"address"];
    _timeLabel.text=dict[@"time"];
    NSString  *status=dict[@"status"];
    if ([status isEqualToString:@"1"]) {
        _typeImage.hidden=NO;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
    }else{
        _typeImage.hidden=YES;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
    }
}


- (UIImageView *)typeImage
{
    if (!_typeImage)
    {
        _typeImage = [[UIImageView alloc] init];
        _typeImage.image = [UIImage imageNamed:@"select"];
        _typeImage.hidden=NO;
    }
    return _typeImage;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _nameLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.text =BITLocalizedCapString(@"XXXX", nil);
    }
    return _nameLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel)
    {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _addressLabel.text = @"xxxxxxx";
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.text = @"2019/09/20";
    }
    return _timeLabel;
}


@end
