

#import "InputAutoChangeHeightView.h"
#import "UITextView+Placeholder.h"

@implementation InputAutoChangeHeightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.PromptLable];
        [self addSubview:self.textView];
        [self addSubview:self.lineLable];
        [self addLayout];
    }
    return self;
}
- (void)addLayout
{
    [_PromptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(26);
        make.right.equalTo(self).offset(-26);
        make.top.equalTo(self).offset(11);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.PromptLable);
        make.top.equalTo(self.PromptLable.mas_bottom).offset(3);
        make.height.mas_equalTo(40);
    }];

    
    [_lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(0);
        make.left.equalTo(self).offset(18);
        make.right.equalTo(self).offset(-18);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * aStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if(aStr.length == 0){
        _PromptLable.hidden=YES;
    }else{
        _PromptLable.hidden=NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    NSInteger numLines = textView.contentSize.height / textView.font.lineHeight;
    if (numLines >1) {
        CGSize constraintSize = CGSizeMake(self.textView.width, MAXFLOAT);
        CGSize size = [self.textView sizeThatFits:constraintSize];
        [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.PromptLable);
            make.top.equalTo(self.PromptLable.mas_bottom).offset(3);
            make.height.mas_equalTo(size.height);
        }];
        [_lineLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(0);
            make.left.equalTo(self).offset(18);
            make.right.equalTo(self).offset(-18);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        if (_delegate && [_delegate respondsToSelector:@selector(onTextViewLineCountChangeTo:)]) {
            [_delegate onTextViewLineCountChangeTo:numLines];
        }
    }else{
        [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.PromptLable);
            make.top.equalTo(self.PromptLable.mas_bottom).offset(3);
            make.height.mas_equalTo(40);
        }];
        
        
        [_lineLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(0);
            make.left.equalTo(self).offset(18);
            make.right.equalTo(self).offset(-18);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
}


- (UILabel *)PromptLable
{
    if (!_PromptLable)
    {
        _PromptLable = [[UILabel alloc] init];
        _PromptLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _PromptLable.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        _PromptLable.text=BITLocalizedCapString(@"Wallet name",nil);
        _PromptLable.textAlignment=NSTextAlignmentLeft;
        _PromptLable.hidden=YES;
    }
    return _PromptLable;
}
- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] init];
        _textView.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.textColor=[UIColor colorWithHexString:@"#202640"];
        _textView.delegate=self;
        _textView.placeholderLabel.text=BITLocalizedCapString(@"Please enter content",nil);;
    }
    return _textView;
}

- (UILabel *)lineLable
{
    if (!_lineLable)
    {
        _lineLable = [[UILabel alloc] init];
        _lineLable.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _lineLable;
}

@end
