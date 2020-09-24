



#import "SettingCell.h"

@interface SettingCell()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *rightView;
@property(nonatomic, strong) UILabel *contentLabel;

@end
@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.rightView];
        [self.contentView addSubview:self.isSwitch];
        [self.contentView addSubview:self.bottomLine];
        
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-FitW(8));
        make.width.height.equalTo(@28);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitW(18));
        make.centerY.equalTo(self.contentView);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_rightView.mas_left).offset(-FitW(5));
    }];
   
    [self.isSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-FitW(8));
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitW(12));
        make.right.equalTo(self).offset(FitW(-12));
        make.top.equalTo(self.contentView.mas_bottom).offset(FitH(-2));
        make.height.equalTo(@1);
    }];
}

- (void)setModel:(SettingModel *)model
{
    _model = model;
    _rightView.hidden = model.rightType == 0 ? YES : NO;
    _isSwitch.hidden = model.rightType == 0 ? NO : YES;
    _titleLabel.text = model.titleName;
    _contentLabel.text = model.desc;
}
- (UILabel *)titleLabel{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textAlignment=NSTextAlignmentRight;
    }
    return _contentLabel;
}

- (UIImageView *)rightView
{
    if (!_rightView)
    {
        _rightView = [[UIImageView alloc] init];
        _rightView.image = [UIImage imageNamed:@"jiantou_cell_setting"];
    }
    return _rightView;
}
- (UISwitch *)isSwitch
{
    if (!_isSwitch)
    {
        _isSwitch = [[UISwitch alloc] init];
        
    }
    return _isSwitch;
}

- (UILabel *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    }
    return _bottomLine;
}
@end
