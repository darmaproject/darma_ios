

#import "CunstomMessageView.h"
#import "YYText.h"
@interface CunstomMessageView()<UITextFieldDelegate>

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) YYLabel *messageLabel;

@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UIButton *cancelButton;

@end
@implementation CunstomMessageView

-(void)show
{
    CunstomMessageView *view = [[CunstomMessageView alloc] init];
    view.frame = CGRectMake(0, 0, Width, Height);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
}
+ (void)showCustomViewTitle:(NSString *)title message:(NSString *)message isHaveCopy:(BOOL)isHaveCopy cancelClick:(cancel)cancel{
    CunstomMessageView *view = [[CunstomMessageView alloc] init];
    view.frame = CGRectMake(0, 0, Width, Height);
    view.titleLabel.text=title;
    if (isHaveCopy) {
        NSString *string = BITLocalizedCapString(message, nil);
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
        attribute.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        attribute.yy_color = [UIColor colorWithHexString:@"#202640"];
        UIButton *cpButton = [[UIButton alloc] init];
        [cpButton setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
        
        NSMutableAttributedString *payIDAttr = [NSMutableAttributedString yy_attachmentStringWithContent:cpButton contentMode:UIViewContentModeCenter width:Fit(28) ascent:Fit(5) descent:0];
        cpButton.frame = CGRectMake(0, 0, Fit(28), Fit(28));
        [cpButton addTarget:view action:@selector(messageCopy) forControlEvents:UIControlEventTouchUpInside];
        cpButton.tag = 10;
        [attribute yy_appendString:@" "];
        [attribute appendAttributedString:payIDAttr];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(Width - FitW(44), CGFLOAT_MAX) text:attribute];
        view.messageLabel.textLayout = layout;
    }else{
        view.messageLabel.text=message;
    }
    view.cancelBlock=cancel;
   
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
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.cancelButton];
        
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
   
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(_contentView);
        make.height.equalTo(@(FitH(49)));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.height.equalTo(@(FitH(0.5)));
        make.bottom.equalTo(_cancelButton.mas_top);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(FitH(20));
        make.left.equalTo(_contentView).offset(FitW(10));
        make.right.equalTo(_contentView).offset(FitW(-10));
        make.bottom.equalTo(_lineView.mas_top).offset(FitH(-20));
    }];
    
}

-(void)messageCopy{
    NSString *str_txid=self.messageLabel.text;
    if (str_txid.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str_txid;
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copied", nil)];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
}
-(void)cancel:(UIButton *)sender{
    
    if (_cancelBlock) {
        self.cancelBlock();
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

- (YYLabel *)messageLabel
{
    if (!_messageLabel)
    {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.text = BITLocalizedCapString(@"XXXXXXXXXXXXX", nil);
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _messageLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _messageLabel.textAlignment=NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
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


- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:BITLocalizedCapString(@"Cancel", nil) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#3EB7BA"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


@end
