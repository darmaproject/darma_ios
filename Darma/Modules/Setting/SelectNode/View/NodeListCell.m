



#import "NodeListCell.h"

@interface NodeListCell()
@property(nonatomic, strong) UILabel *nodeLabel;
@property(nonatomic, strong) UILabel *nodeTag;
@property(nonatomic, strong) UIImageView *selectImageV;

@end
@implementation NodeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.nodeLabel];
        [self.contentView addSubview:self.nodeTag];
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
    
    [_nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FitW(8));
        make.left.equalTo(self.contentView).offset(FitW(17));
        make.right.equalTo(self.selectImageV.mas_left).offset(FitW(-30));
    }];
    
    [_nodeTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nodeLabel.mas_bottom).offset(FitW(7));
        make.left.equalTo(self.contentView).offset(FitW(17));
        make.right.equalTo(self.selectImageV.mas_left).offset(FitW(-30));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(FitW(-8));
    }];
}
-(void)setDict:(NSDictionary *)dict{

    NSArray *nodes=[dict[@"node"] componentsSeparatedByString:@","];
    if (nodes.count>1) {
        _nodeLabel.text=BITLocalizedCapString(@"Auto", nil);
    }else{
        _nodeLabel.text=dict[@"node"];
    }
    
    NSString  *str_isDefault=[NSString stringWithFormat:@"%@",dict[@"isDefault"]];
    NSString  *nodeNum=[NSString stringWithFormat:@"%@",dict[@"nodeNum"]];

    if ([str_isDefault intValue]==1) {
        if (nodes.count>1) {
            _nodeTag.text=[NSString stringWithFormat:@"%@",BITLocalizedCapString(dict[@"tip"], nil)];
        }
        else{
            _nodeTag.text=[NSString stringWithFormat:@"%@,%@",BITLocalizedCapString(dict[@"tip"], nil),nodeNum];
        }
    }else{
        _nodeTag.text=[NSString stringWithFormat:@"%@",dict[@"tip"]];
    }
    NSString *isSelect=[NSString stringWithFormat:@"%@",dict[@"isSelect"]];
    if ([isSelect intValue]==1) {
        _selectImageV.hidden=NO;
        _nodeLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _nodeTag.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
    }else{
        _selectImageV.hidden=YES;
        _nodeLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _nodeTag.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
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
- (UILabel *)nodeLabel
{
    if (!_nodeLabel)
    {
        _nodeLabel = [[UILabel alloc] init];
        _nodeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nodeLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _nodeLabel.text = @"xxx";
    }
    return _nodeLabel;
}
- (UILabel *)nodeTag
{
    if (!_nodeTag)
    {
        _nodeTag = [[UILabel alloc] init];
        _nodeTag.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _nodeTag.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _nodeTag.text = @"xxxxxxxxxxxxxxxx";
    }
    return _nodeTag;
}

@end
