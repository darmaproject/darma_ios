



#import "PaymentFinishCell.h"

@interface PaymentFinishCell()

@end
@implementation PaymentFinishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];

        [self addLayout];
    }
    return self;
}


- (void)addLayout
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FitH(12));
        make.left.equalTo(self.contentView).offset(FitW(26));
        
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(FitH(5));
        make.left.equalTo(self.contentView).offset(FitW(26));
        make.right.equalTo(self.contentView).offset(FitW(-71));
        make.bottom.equalTo(self.contentView).offset(FitH(-12));
    }];
   
}
-(void)setDic:(NSDictionary *)dic{
    _titleLabel.text=dic[@"title"];
    _contentLabel.text=dic[@"content"];
    if (_contentLabel.text.length<=0) {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(FitH(5));
            make.left.equalTo(self.contentView).offset(FitW(26));
            make.right.equalTo(self.contentView).offset(FitW(-17));
            make.bottom.equalTo(self.contentView).offset(FitH(-12));
            make.height.mas_equalTo(18);
        }];
    }
}
- (UILabel *)titleLabel{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _titleLabel.text =@"";
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
        _contentLabel.text = @"";
        _contentLabel.numberOfLines=0;
    }
    return _contentLabel;
}

@end
