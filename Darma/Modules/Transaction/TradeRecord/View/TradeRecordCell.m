




#import "TradeRecordCell.h"

@implementation TradeRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self.contentView addSubview:self.TradePairLabel];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.exchangeLabel];
        [self addLayout];
    }
    return self;
}


- (void)addLayout
{
    [_TradePairLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FitH(8));
        make.left.equalTo(self.contentView).offset(FitW(11));
        
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.TradePairLabel);
        make.right.equalTo(self.contentView).offset(FitW(-26));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TradePairLabel.mas_bottom).offset(FitH(7));
        make.left.equalTo(self.contentView).offset(FitW(11));
        make.bottom.equalTo(self.contentView).offset(FitH(-8));
        
    }];
    [_exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.contentView).offset(FitW(-26));
    }];
}

-(void)setModel:(TradeDetailsModel *)model{
    NSArray *arry=[model.pair componentsSeparatedByString:@"_"];
    
    _TradePairLabel.text=[NSString stringWithFormat:@"%@/%@",[[arry firstObject] uppercaseString],[[arry lastObject] uppercaseString]];
    _amountLabel.text=[NSString stringWithFormat:@"%@ %@",model.base_amount_total,[[arry firstObject] uppercaseString]];
    NSString *time=[NSString stringWithFormat:@"%@",model.created_at];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mmZ"];
    NSDate *date =[formatter1 dateFromString:time];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy/MM/dd"];
    NSString *Time = [formatter2 stringFromDate:date ];
    _timeLabel.text=Time;
    _exchangeLabel.text=[NSString stringWithFormat:@"≈%@ %@",model.quota_amount,[[arry lastObject] uppercaseString]];
}


- (UILabel *)TradePairLabel
{
    if (!_TradePairLabel)
    {
        _TradePairLabel = [[UILabel alloc] init];
        _TradePairLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _TradePairLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _TradePairLabel.text =@"XX/XX";
    }
    return _TradePairLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel)
    {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _amountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _amountLabel.text = @"-1.00 xx";
    }
    return _amountLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _timeLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.text =@"yyyy/mm/dd";
    }
    return _timeLabel;
}

- (UILabel *)exchangeLabel
{
    if (!_exchangeLabel)
    {
        _exchangeLabel = [[UILabel alloc] init];
        _exchangeLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _exchangeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _exchangeLabel.text = @"≈1.00 xx";
    }
    return _exchangeLabel;
}
@end
