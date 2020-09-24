



#import "LanguageListCell.h"

@interface LanguageListCell()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *selectImageV;

@end
@implementation LanguageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.titleLabel];
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
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FitW(8));
        make.left.equalTo(self.contentView).offset(FitW(17));
        make.right.equalTo(self.selectImageV.mas_left).offset(FitW(-30));
    }];
    
   
}
-(void)setDict:(NSDictionary *)dict{
     _titleLabel.text=dict[@"title"];
    NSString *isSelect=[NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([isSelect intValue]==1) {
        _selectImageV.hidden=NO;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
    }else{
        _selectImageV.hidden=YES;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
    }
}
- (UIImageView *)selectImageV
{
    if (!_selectImageV)
    {
        _selectImageV = [[UIImageView alloc] init];
        _selectImageV.image = [UIImage imageNamed:@"select"];
    }
    return _selectImageV;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabel.text = @"xxx";
    }
    return _titleLabel;
}

@end
