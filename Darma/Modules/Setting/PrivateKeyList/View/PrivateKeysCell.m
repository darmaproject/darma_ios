




#import "PrivateKeysCell.h"

@interface PrivateKeysCell()

@end

@implementation PrivateKeysCell

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
        make.right.equalTo(self.contentView).offset(-26-22);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-7);
    }];
}
-(void)setDict:(NSDictionary *)dict{
    _nameLabel.text=BITLocalizedCapString( dict[@"title"], nil);
    _contentLabel.text=[NSString stringWithFormat:@"%@",dict[@"content"]];
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
        _contentLabel.text = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.numberOfLines=0;
    }
    return _contentLabel;
}

@end
