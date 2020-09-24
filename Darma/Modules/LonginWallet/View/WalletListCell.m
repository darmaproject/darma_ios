



#import "WalletListCell.h"

@interface WalletListCell()

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;

@end

@implementation WalletListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
  
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(FitW(17));
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(_nameLabel.mas_right).offset(FitW(5));
        make.right.equalTo(self.contentView).offset(FitW(-19));
    }];
}

-(void)setDict:(NSDictionary *)dict{
    _nameLabel.text=dict[@"name"];
    _timeLabel.text=dict[@"time"];
}


- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _nameLabel.text = @"XXX";
    }
    return _nameLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        _timeLabel.text = @"XXXX/XX/XX";
    }
    return _timeLabel;
}

@end
