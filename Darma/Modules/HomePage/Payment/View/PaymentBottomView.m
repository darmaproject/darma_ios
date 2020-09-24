



#import "PaymentBottomView.h"

#import "UITextField+PlaceHolder.h"
#import "UITextView+Placeholder.h"

@interface PaymentBottomView()<UITextViewDelegate>

@end
@implementation PaymentBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.addressField];
        [self addSubview:self.scanButton];
        [self addSubview:self.selectAddress];
        [self addSubview:self.addressLine];

        [self addSubview:self.paymentField];
        [self addSubview:self.paymentLine];
        
        [self addSubview:self.amountField];
        [self addSubview:self.AllButton];
        [self addSubview:self.amountLine];
        
        [self addSubview:self.notesField];
        [self addSubview:self.notesLine];
        [self addSubview:self.markLable];
       
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
   
    
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FitH(22));
        make.left.equalTo(self).offset(FitW(27));
        make.right.equalTo(self).offset(FitW(-102));
        make.height.equalTo(@(FitH(44)));

    }];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressField);
        make.left.equalTo(self.addressField.mas_right).offset(FitW(11));
        make.width.height.equalTo(@(FitW(28)));
    }];

    [_selectAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scanButton);
        make.right.equalTo(self).offset(FitW(-24));
        make.width.height.equalTo(@(FitW(28)));
    }];
    
    
    [_addressLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressField.mas_bottom);
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(FitW(-18));
        make.height.mas_equalTo(0.5);

    }];
    
    [_paymentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLine.mas_bottom).offset(FitH(18));
        make.left.equalTo(self).offset(FitW(27));
        make.right.equalTo(self).offset(FitW(-27));
        make.height.equalTo(@(FitH(44)));
    }];
    [_paymentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paymentField.mas_bottom);
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(FitW(-18));
        make.height.mas_equalTo(0.5);
    }];
    
    [_amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paymentLine.mas_bottom).offset(FitH(18));
        make.left.equalTo(self).offset(FitW(27));
        make.right.equalTo(self).offset(FitW(-27));
        make.height.equalTo(@(FitH(44)));
    }];
    [_AllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.amountField);
        make.right.equalTo(self).offset(FitW(-24));
        make.width.height.equalTo(@(FitH(28)));
    }];
    
    [_amountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountField.mas_bottom);
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(FitW(-18));
        make.height.mas_equalTo(0.5);
    }];
    
    [_notesField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountField.mas_bottom).offset(FitH(18));
        make.left.equalTo(self).offset(FitW(27));
        make.right.equalTo(self).offset(FitW(-27));
        make.height.equalTo(@(FitH(44)));
    }];
    [_notesLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.notesField.mas_bottom);
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(FitW(-18));
        make.height.mas_equalTo(0.5);
    }];
    
    [_markLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.notesLine.mas_bottom).offset(FitH(18));
        make.left.equalTo(self).offset(FitW(27));
        make.right.equalTo(self).offset(FitW(-27));
        make.bottom.equalTo(self).offset(FitH(-18));
    }];
    
}
-(void)setScanInfo:(NSDictionary *)scanInfo{
    _addressField.text=scanInfo[@"address"];
    _paymentField.text=scanInfo[@"tx_payment_id"];
    _amountField.text=scanInfo[@"tx_amount"];
    _notesField.text=scanInfo[@""];
    
    NSInteger numLines = _addressField.contentSize.height / _addressField.font.lineHeight;
    if (numLines >1) {
        CGSize constraintSize = CGSizeMake(_addressField.width, MAXFLOAT);
        CGSize size = [_addressField sizeThatFits:constraintSize];
        
        CGSize constraintSize2 = CGSizeMake(_paymentField.width, MAXFLOAT);
        CGSize size2 = [_paymentField sizeThatFits:constraintSize2];
        float paymentHeight=size2.height;
        if (paymentHeight<FitH(44)) {
            paymentHeight=FitH(44);
        }
        
        [_addressField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(size.height));

        }];
        
        [_paymentField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(paymentHeight));
        }];
       
    }
}
-(void)setSelectInfo:(NSDictionary *)selectInfo{
    _addressField.text=selectInfo[@"walletAddress"];
    _paymentField.text=selectInfo[@"paymentID"];
    _notesField.text=selectInfo[@"adressName"];
    
    NSInteger numLines = _addressField.contentSize.height / _addressField.font.lineHeight;
    if (numLines >1) {
        CGSize constraintSize = CGSizeMake(_addressField.width, MAXFLOAT);
        CGSize size = [_addressField sizeThatFits:constraintSize];
        
        CGSize constraintSize2 = CGSizeMake(_paymentField.width, MAXFLOAT);
        CGSize size2 = [_paymentField sizeThatFits:constraintSize2];
        float paymentHeight=size2.height;
        if (paymentHeight<FitH(44)) {
            paymentHeight=FitH(44);
        }
        
        [_addressField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(size.height));
            
        }];
        
        [_paymentField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(paymentHeight));
        }];
        
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    NSInteger numLines = textView.contentSize.height / textView.font.lineHeight;
    if (numLines >1) {
        if (textView==_addressField) {
           
            CGSize constraintSize = CGSizeMake(_addressField.width, MAXFLOAT);
            CGSize size = [_addressField sizeThatFits:constraintSize];
            
            CGSize constraintSize2 = CGSizeMake(_paymentField.width, MAXFLOAT);
            CGSize size2 = [_paymentField sizeThatFits:constraintSize2];
            float paymentHeight=size2.height;
            if (paymentHeight<FitH(44)) {
                paymentHeight=FitH(44);
            }
            
            [_addressField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(FitH(size.height)));
            }];
    
            [_paymentField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(paymentHeight));
            }];
            

        }else if(textView ==_paymentField){
            CGSize constraintSize = CGSizeMake(_paymentField.width, MAXFLOAT);
            CGSize size = [_paymentField sizeThatFits:constraintSize];
            
            [_paymentField mas_updateConstraints:^(MASConstraintMaker *make) {
              
                make.height.equalTo(@(size.height));
            }];
            

        }
    }else{
       
        [_addressField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(FitH(22));
            make.left.equalTo(self).offset(FitW(27));
            make.right.equalTo(self).offset(FitW(-102));
            make.height.equalTo(@(FitH(44)));
            
        }];
        [_scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addressField);
            make.left.equalTo(self.addressField.mas_right).offset(FitW(11));
            make.width.height.equalTo(@(FitW(28)));
        }];
        
        [_selectAddress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scanButton);
            make.right.equalTo(self).offset(FitW(-24));
            make.width.height.equalTo(@(FitW(28)));
        }];
        
        [_addressLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressField.mas_bottom);
            make.left.equalTo(self).offset(FitW(18));
            make.right.equalTo(self).offset(FitW(-18));
            make.height.mas_equalTo(0.5);
            
        }];
        
        [_paymentField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressLine.mas_bottom).offset(FitH(18));
            make.left.equalTo(self).offset(FitW(27));
            make.right.equalTo(self).offset(FitW(-27));
            make.height.equalTo(@(FitH(44)));
        }];

        [_paymentLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymentField.mas_bottom);
            make.left.equalTo(self).offset(FitW(18));
            make.right.equalTo(self).offset(FitW(-18));
            make.height.mas_equalTo(0.5);
        }];
        
        [_amountField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymentLine.mas_bottom).offset(FitH(18));
            make.left.equalTo(self).offset(FitW(27));
            make.right.equalTo(self).offset(FitW(-27));
            make.height.equalTo(@(FitH(44)));
        }];
        [_AllButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.amountField);
            make.right.equalTo(self).offset(FitW(-24));
            make.width.height.equalTo(@(FitH(28)));
        }];
        
        [_amountLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.amountField.mas_bottom);
            make.left.equalTo(self).offset(FitW(18));
            make.right.equalTo(self).offset(FitW(-18));
            make.height.mas_equalTo(0.5);
        }];
        
        [_notesField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.amountField.mas_bottom).offset(FitH(18));
            make.left.equalTo(self).offset(FitW(27));
            make.right.equalTo(self).offset(FitW(-27));
            make.height.equalTo(@(FitH(44)));
        }];
        [_notesLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.notesField.mas_bottom);
            make.left.equalTo(self).offset(FitW(18));
            make.right.equalTo(self).offset(FitW(-18));
            make.height.mas_equalTo(0.5);
        }];
        
        [_markLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.notesLine.mas_bottom).offset(FitH(18));
            make.left.equalTo(self).offset(FitW(27));
            make.right.equalTo(self).offset(FitW(-27));
            make.height.equalTo(@(20));
            make.bottom.equalTo(self).offset(FitH(-18));
        }];
    }
}


- (UITextView *)addressField
{
    if (!_addressField)
    {
        _addressField = [[UITextView alloc] init];
        _addressField.placeholder =BITLocalizedCapString(@"Darma address", nil) ;
        _addressField.placeholderColor = [UIColor colorWithHexString:@"#D2D6DC"];
        _addressField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _addressField.backgroundColor = [UIColor whiteColor];
        _addressField.textColor = [UIColor colorWithHexString:@"#202640"];
        _addressField.delegate=self;
        _addressField.scrollEnabled = NO;
    }
    return _addressField;
}
- (UIButton *)scanButton
{
    if (!_scanButton)
    {
        _scanButton = [[UIButton alloc] init];
        [_scanButton setImage: [UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
    }
    return _scanButton;
}
- (UIButton *)selectAddress
{
    if (!_selectAddress)
    {
        _selectAddress = [[UIButton alloc] init];
        [_selectAddress setImage: [UIImage imageNamed:@"walletAddress"] forState:UIControlStateNormal];
    }
    return _selectAddress;
}
- (UILabel *)addressLine
{
    if (!_addressLine)
    {
        _addressLine = [[UILabel alloc] init];
        
        _addressLine.backgroundColor = [UIColor colorWithHexString:@"#E8EAED"];
    }
    return _addressLine;
}
- (UITextView *)paymentField
{
    if (!_paymentField)
    {
        _paymentField = [[UITextView alloc] init];
        
        _paymentField.placeholder =BITLocalizedCapString(@"Payment ID(optional)", nil);
        _paymentField.placeholderColor = [UIColor colorWithHexString:@"#D2D6DC"];
        _paymentField.backgroundColor = [UIColor whiteColor];
        _paymentField.textColor = [UIColor colorWithHexString:@"#202640"];
        _paymentField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _paymentField.delegate=self;
        _paymentField.scrollEnabled = NO;

        
      
    }
    return _paymentField;
}
- (UILabel *)paymentLine
{
    if (!_paymentLine)
    {
        _paymentLine = [[UILabel alloc] init];
        
        _paymentLine.backgroundColor = [UIColor colorWithHexString:@"#E8EAED"];
    }
    return _paymentLine;
}
- (UITextField *)amountField
{
    if (!_amountField)
    {
        _amountField = [[UITextField alloc] init];
        _amountField.placeholder =BITLocalizedCapString(@"Amount", nil);
        _amountField.placeholderColor = [UIColor colorWithHexString:@"#D2D6DC"];
        _amountField.font =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _amountField.backgroundColor = [UIColor whiteColor];
        _amountField.textColor = [UIColor colorWithHexString:@"#202640"];
        _amountField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _amountField;
}
-(UIButton *)AllButton{
    if (!_AllButton)
    {
        _AllButton = [[UIButton alloc] init];
        [_AllButton setImage:[UIImage imageNamed:@"exchange"]forState:UIControlStateNormal];
        _AllButton.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_AllButton setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
    }
    return _AllButton;
}
- (UILabel *)amountLine
{
    if (!_amountLine)
    {
        _amountLine = [[UILabel alloc] init];
        
        _amountLine.backgroundColor = [UIColor colorWithHexString:@"#E8EAED"];
    }
    return _amountLine;
}
- (UITextField *)notesField
{
    if (!_notesField)
    {
        _notesField = [[UITextField alloc] init];
        _notesField.placeholder =BITLocalizedCapString(@"Remark", nil);
        _notesField.placeholderColor = [UIColor colorWithHexString:@"#D2D6DC"];
        _notesField.font =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _notesField.backgroundColor = [UIColor whiteColor];
        _notesField.textColor = [UIColor colorWithHexString:@"#202640"];
    }
    return _notesField;
}
- (UILabel *)notesLine
{
    if (!_notesLine)
    {
        _notesLine = [[UILabel alloc] init];
     
        _notesLine.backgroundColor = [UIColor colorWithHexString:@"#E8EAED"];
    }
    return _notesLine;
}
- (UILabel *)markLable
{
    if (!_markLable)
    {
        _markLable = [[UILabel alloc] init];
        _markLable.text = BITLocalizedCapString(@"Send All", nil);
        _markLable.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _markLable.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
    }
    return _markLable;
}
@end
