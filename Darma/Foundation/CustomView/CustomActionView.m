

#import "CustomActionView.h"
#import "UITextField+PlaceHolder.h"

@interface CustomActionView()<UITextFieldDelegate>

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UITextField *textfield;
@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UIView *lineViewA;
@property(nonatomic, strong) UIView *lineViewB;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *sureButton;

@end
@implementation CustomActionView

-(void)show
{
    CustomActionView *view = [[CustomActionView alloc] init];
    view.frame = CGRectMake(0, 0, Width, Height);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.textfield];
        [self.contentView addSubview:self.lineView];
        
        [self.contentView addSubview:self.lineViewA];
        [self.contentView addSubview:self.lineViewB];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.sureButton];
        
        [self addLayout];
    }
    return self;
}
- (void)addLayout
{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitW(40));
        make.right.equalTo(self).offset(FitW(-40));
        make.center.equalTo(self);
        make.height.equalTo(@(FitH(180)));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(Fit(17));
        make.left.equalTo(_contentView).offset(FitW(10));
        make.right.equalTo(_contentView).offset(FitW(-10));
        make.height.equalTo(@(FitH(21)));
    }];
    
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(Fit(34));
        make.left.equalTo(_contentView).offset(FitW(28));
        make.right.equalTo(_contentView).offset(FitW(-28));
        make.height.equalTo(@(FitH(30)));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textfield.mas_bottom);
        make.left.equalTo(_contentView).offset(Fit(20));
        make.right.equalTo(_contentView).offset(Fit(-20));
        make.height.equalTo(@(FitH(0.5)));
    }];
    
    [_lineViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(FitH(37));
        make.left.right.equalTo(_contentView);
        make.height.equalTo(@(FitH(0.5)));
    }];
    [_lineViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineViewA.mas_bottom);
        make.centerX.equalTo(_contentView);
        make.width.equalTo(@(FitW(0.5)));
        make.height.equalTo(@(FitH(49)));
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineViewA.mas_bottom);
        make.left.equalTo(_contentView);
        make.right.equalTo(_lineViewB.mas_left);
        make.height.equalTo(@(FitH(49)));
    }];
   
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineViewA.mas_bottom);
        make.left.equalTo(_lineViewB.mas_right);
        make.right.equalTo(_contentView);
        make.height.equalTo(@(FitH(49)));
    }];
    
}
-(void)setTitle:(NSString *)title{
    _title=title;
    if (_title.length<=0) {
        _title=@"";
    }
    _titleLabel.text=_title;
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder=placeholder;

    if (_placeholder.length<=0) {
        _placeholder=@"";
    }
    _textfield.placeholder=_placeholder;
}
-(void)cancel:(UIButton *)sender{
  
    if (_cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}
-(void)sureClick:(UIButton *)sender{
  
    if (_determineBlock) {
        self.determineBlock(_textfield.text);
    }
    [self removeFromSuperview];
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor =[UIColor whiteColor];
        _contentView.layer.cornerRadius=8;
        _contentView.layer.masksToBounds=YES;
    }
    return _contentView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = BITLocalizedCapString(@"", nil);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextField *)textfield;
{
    if (!_textfield)
    {
        _textfield = [[UITextField alloc] init];
        _textfield.placeholder = BITLocalizedCapString(@"", nil);
        _textfield.placeholderColor = [UIColor colorWithHexString:@"#D2D6DC"];
        _textfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textfield.secureTextEntry = YES;
        _textfield.delegate = self;
        _textfield.returnKeyType = UIReturnKeySend;
    }
    return _textfield;
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _lineView;
}
- (UIView *)lineViewA
{
    if (!_lineViewA)
    {
        _lineViewA = [[UIView alloc] init];
        _lineViewA.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _lineViewA;
}
- (UIView *)lineViewB
{
    if (!_lineViewB)
    {
        _lineViewB = [[UIView alloc] init];
        _lineViewB.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _lineViewB;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:BITLocalizedCapString(@"Cancel", nil) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:BITLocalizedCapString(@"Confirm", nil) forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor colorWithHexString:@"#3EB7BA"] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_sureButton addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
