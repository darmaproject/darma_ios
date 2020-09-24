



#import "CreateWalletInputView.h"

@implementation CreateWalletInputView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.PromptLable];
        [self addSubview:self.textfiled];
        [self addSubview:self.HidenBtn];
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
    [_textfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PromptLable);
        make.right.equalTo(self).offset(-54);
        make.top.equalTo(self.PromptLable.mas_bottom).offset(3);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    [_HidenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18);
        make.width.height.mas_equalTo(28);
        make.centerY.equalTo(self.textfiled);
    }];
    
    [_lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textfiled.mas_bottom).offset(9);
        make.left.equalTo(self).offset(18);
        make.right.equalTo(self).offset(-18);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
  
}
-(void)hiden:(UIButton *)sender{
    sender.selected=!sender.selected;
    _textfiled.secureTextEntry = !_textfiled.secureTextEntry;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
     self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * aStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if(aStr.length == 0){
        _PromptLable.hidden=YES;
    }else{
        _PromptLable.hidden=NO;
    }
     return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textfiled resignFirstResponder];
     self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
}


- (UILabel *)PromptLable
{
    if (!_PromptLable)
    {
        _PromptLable = [[UILabel alloc] init];
        _PromptLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _PromptLable.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        _PromptLable.text=@"Wallet name";
        _PromptLable.textAlignment=NSTextAlignmentLeft;
        _PromptLable.hidden=YES;
    }
    return _PromptLable;
}
- (UITextField *)textfiled
{
    if (!_textfiled)
    {
        _textfiled = [[UITextField alloc] init];
        _textfiled.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
        _textfiled.placeholder=@"Wallet name";
        _textfiled.delegate=self;
    }
    return _textfiled;
}
- (UIButton *)HidenBtn
{
    if (!_HidenBtn)
    {
        _HidenBtn = [[UIButton alloc] init];
        [_HidenBtn setImage:[UIImage imageNamed:@"hiden"] forState:UIControlStateNormal];
        [_HidenBtn setImage:[UIImage imageNamed:@"see"] forState:UIControlStateSelected];
        [_HidenBtn addTarget:self action:@selector(hiden:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _HidenBtn;
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
