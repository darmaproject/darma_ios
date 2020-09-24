


#import "AddressCell.h"

@interface AddressCell()

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIImageView *selectImageV;
@property(nonatomic, strong) UILabel *addressLabel;

@end


@implementation AddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.selectImageV];
        
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    [_selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(@(Fit(28)));
        make.right.equalTo(self.contentView).offset(FitW(-14));
        make.centerY.equalTo(self.contentView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FitW(8));
        make.left.equalTo(self.contentView).offset(FitW(17));
        make.right.equalTo(self.selectImageV.mas_left).offset(FitW(-30));
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(FitW(7));
        make.left.equalTo(self.contentView).offset(FitW(17));
        make.right.equalTo(self.selectImageV.mas_left).offset(FitW(-30));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(FitW(-8));
    }];
}
-(void)setDict:(NSDictionary *)dict{
    _nameLabel.text=dict[@"adressName"];
    _addressLabel.text=dict[@"walletAddress"];

}


- (UIImageView *)selectImageV
{
    if (!_selectImageV)
    {
        _selectImageV = [[UIImageView alloc] init];
        _selectImageV.image = [UIImage imageNamed:@"select"];
        _selectImageV.hidden=YES;
    }
    return _selectImageV;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _nameLabel.text = @"xxx";
    }
    return _nameLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel)
    {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _addressLabel.text = @"xxxxxxxxxxxxxxxx";
    }
    return _addressLabel;
}


@end
