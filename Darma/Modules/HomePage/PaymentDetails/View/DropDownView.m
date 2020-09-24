


#import "DropDownView.h"

@implementation DropDownView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.backgroundImage];
      
         [self addLayout];
    }
    return self;
}
-(void)addLayout{
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.buttonArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:10 tailSpacing:10];
    [self.buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);

    }];
}

- (void)buttonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(dropDownSelectView:clickIndex:)]) {
        self.hidden=YES;
        [self.delegate dropDownSelectView:self clickIndex:sender.tag];
    }
    
}
- (NSMutableArray *)buttonArray{
    if (!_buttonArray)
    {
        _buttonArray = [NSMutableArray array];
        buttonView *button0 = [[buttonView alloc] init];
        button0.backgroundColor = [UIColor whiteColor];
        button0.iconView.image = [UIImage imageNamed:@"nav_drop_blockBrowser"];
        button0.titleLabel.text = BITLocalizedCapString(@"Block explorer", nil);
        button0.tag = 0;
        button0.selectBtn.tag=0;
        [button0.selectBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button0];
        [_buttonArray addObject:button0];
        
        
        buttonView *button1 = [[buttonView alloc] init];
        button1.backgroundColor = [UIColor whiteColor];
        
        button1.iconView.image = [UIImage imageNamed:@"nav_drop_key"];
        button1.titleLabel.text = BITLocalizedCapString(@"Tx key", nil);
        button1.tag = 1;
        button1.selectBtn.tag=1;
        [button1.selectBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        [_buttonArray addObject:button1];
        
        buttonView *button2 = [[buttonView alloc] init];
        button2.backgroundColor = [UIColor whiteColor];
        
        button2.iconView.image = [UIImage imageNamed:@"nav_drop_share"];
        button2.titleLabel.text = BITLocalizedCapString(@"Share", nil);
        button2.tag = 2;
        button2.selectBtn.tag=2;
        [button2.selectBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        [_buttonArray addObject:button2];
     
    }
    return _buttonArray;
}


- (UIImageView *)backgroundImage
{
    if (!_backgroundImage)
    {
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.image = [UIImage imageNamed:@"nav_dropDown_image"];
    }
    return _backgroundImage;
}
@end

@interface buttonView()

@end
@implementation buttonView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.selectBtn];
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(22);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconView.mas_right).offset(11);
        make.right.equalTo(self).offset(-5);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (UIImageView *)iconView{
    if (!_iconView)
    {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"shibai"];
    }
    return _iconView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1F253F"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn)
    {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setBackgroundColor:[UIColor clearColor]];
    }
    return _selectBtn;
}


@end
