




#import "HomeListCell.h"

@interface HomeListCell()

@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *numberLabel;
@property(nonatomic, strong) UILabel *exchangeNumberLabel;
@property(nonatomic, strong) UIView *lineView;

@end
@implementation HomeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.exchangeNumberLabel];
        [self.contentView addSubview:self.lineView];
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(28));
        make.left.equalTo(self.contentView).offset(17);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(11);
        make.left.equalTo(self.iconView.mas_right).offset(8);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(7);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeLabel);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    
    [_exchangeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.numberLabel);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self.contentView);
    }];
}
-(void)setDic:(NSDictionary *)dic{
    
    NSString *time=[NSString stringWithFormat:@"%@", dic[@"time"]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSDate *date =[formatter1 dateFromString:time];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *Time = [formatter2 stringFromDate:date ];
    _timeLabel.text=[NSString stringWithFormat:@"%@",Time];
    NSString *status=[NSString stringWithFormat:@"%@",dic[@"status"]];
    if ([status intValue]==0) {
        _iconView.image = [UIImage imageNamed:@"type_rec"];
        _typeLabel.text =BITLocalizedCapString(@"Receive", nil);
    }else  if ([status intValue]==1){
        _typeLabel.text =BITLocalizedCapString(@"Send", nil);
         _iconView.image = [UIImage imageNamed:@"type_send"];
    }else{
        _typeLabel.text =BITLocalizedCapString(@"", nil);
    }
    NSString *amount=[NSString stringWithFormat:@"%@",dic[@"amount"]];
    
    _numberLabel.text=[NSString stringWithFormat:@"%@ DMC",AppwalletFormat_Money(amount)];
}

- (UIImageView *)iconView
{
    if (!_iconView)
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"type_send"];
    }
    return _iconView;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel)
    {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _typeLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _typeLabel.text =BITLocalizedCapString(@"Receive", nil);
    }
    return _typeLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.text = @"2019/09/20/14:20:12";
    }
    return _timeLabel;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel)
    {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _numberLabel.text = @"0.0 DARMA";
        _numberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberLabel;
}

- (UILabel *)exchangeNumberLabel
{
    if (!_exchangeNumberLabel)
    {
        _exchangeNumberLabel = [[UILabel alloc] init];
        _exchangeNumberLabel.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
        _exchangeNumberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _exchangeNumberLabel.text =BITLocalizedCapString( @"Completed", nil);
        _exchangeNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _exchangeNumberLabel;
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    }
    return _lineView;
}


@end
