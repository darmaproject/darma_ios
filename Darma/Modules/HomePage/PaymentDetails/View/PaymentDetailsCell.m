


#import "PaymentDetailsCell.h"

@interface PaymentDetailsCell()

@end
@implementation PaymentDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contentLabel];
     
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
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-7);
    }];
}
-(void)setDic:(NSDictionary *)dic{
    _nameLabel.text=BITLocalizedCapString(dic[@"title"], nil) ;
    _contentLabel.text=[Tool safeString:[NSString stringWithFormat:@"%@",dic[@"content"]]];
    if (_contentLabel.text.length<=0) {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(26);
            make.right.equalTo(self.contentView).offset(-26);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-7);
            make.height.mas_equalTo(18);
        }];
    }
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
        _contentLabel.text = @"XXXXXXXX";
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.numberOfLines=0;
    }
    return _contentLabel;
}

@end
