



#import "ReceiptTopView.h"

#import "UITextField+PlaceHolder.h"
#import "UIImage+Category.h"
#import "YYText.h"

@interface ReceiptTopView()<UITextFieldDelegate>

@property(nonatomic, strong) UIImageView *qrImageView;

@property(nonatomic, strong) YYLabel *addressLabel;

@property(nonatomic, strong) UITextField *amountField;
@property(nonatomic, strong) UILabel *amountLine;

@property(nonatomic, strong) UILabel *TitleLabel;

@property(nonatomic, strong) UILabel  *paymentIdPromptLabel;
@property(nonatomic, strong) YYLabel  *paymentIdAddressLabel;
@property(nonatomic, strong) UIButton *paymentIdAddressCPButton;

@property(nonatomic ,strong) UILabel  *paymentIdAddressLine;

@property(nonatomic, strong) UILabel *paymentIdTitleLabel;
@property(nonatomic, strong) YYLabel *paymentIdLabel;
@property(nonatomic, strong) UIButton *paymentIdCPButton;

@property(nonatomic ,strong) UILabel  *paymentIdLine;

@property(nonatomic ,strong) NSString  *wallteAddress;

@property(nonatomic ,strong) NSDictionary  *dictInfo;
@property(nonatomic ,assign) BOOL isCreatePamentID;


@end
@implementation ReceiptTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.qrImageView];
        [self addSubview:self.addressLabel];
        
        [self addSubview:self.amountField];
        [self addSubview:self.amountLine];
        
        [self addSubview:self.TitleLabel];
        [self addSubview:self.createPaymentIdButton];
        
        [self addSubview:self.paymentIdPromptLabel];
        [self addSubview:self.paymentIdAddressLabel];
        [self addSubview:self.paymentIdAddressCPButton];
        [self addSubview:self.paymentIdAddressLine];

        
        [self addSubview:self.paymentIdTitleLabel];
        [self addSubview:self.paymentIdLabel];
        [self addSubview:self.paymentIdCPButton];
        [self addSubview:self.paymentIdLine];
        
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    [_qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(FitW(182)));
        make.top.equalTo(self).offset(FitH(30));
        make.centerX.equalTo(self);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitW(22));
        make.right.equalTo(self).offset(FitW(-22));
        make.top.equalTo(_qrImageView.mas_bottom).offset(FitH(14));
    }];
    
    [_amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressLabel);
        make.right.equalTo(self).offset(FitW(-22));
        make.top.equalTo(_addressLabel.mas_bottom).offset(FitH(22));
    }];
    
    [_amountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_amountField.mas_bottom).offset(FitH(5));
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(FitW(-18));
        make.height.mas_equalTo(1);
    }];
    
    [_TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_amountLine.mas_bottom).offset(FitH(22));
        make.left.equalTo(self).offset(FitW(22));
        make.bottom.equalTo(self).offset(FitH(-22));
    }];
    
    [_createPaymentIdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_TitleLabel);
        make.right.equalTo(self).offset(FitW(-29));
        make.height.width.mas_equalTo(28);
    }];
    
   
}
-(void)createPamentID:(NSDictionary *__nullable)dict walletaAddress:(NSString *)walletaAddress isCreat:(BOOL)isCrate{
    _dictInfo=dict;
    _wallteAddress=walletaAddress;
    _isCreatePamentID=isCrate;
    if (isCrate) {
    
        NSString * str_QrCode=[NSString stringWithFormat:@"darma:%@?tx_payment_id=%@&tx_amount=%@",walletaAddress,dict[@"paymentID"],_amountField.text];
        
        UIImage *image = [UIImage generateCustomQRCode:str_QrCode andSize:Fit(182) andColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        _qrImageView.image = image;
        
        NSString *address = walletaAddress;
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:address];
        attribute.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        attribute.yy_color = [UIColor colorWithHexString:@"#202640"];
        UIButton *cpButton = [[UIButton alloc] init];
        [cpButton setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
        
        NSMutableAttributedString *payIDAttr = [NSMutableAttributedString yy_attachmentStringWithContent:cpButton contentMode:UIViewContentModeCenter width:Fit(28) ascent:Fit(5) descent:0];
        cpButton.frame = CGRectMake(0, 0, Fit(28), Fit(28));
        [cpButton addTarget:self action:@selector(addressCopy) forControlEvents:UIControlEventTouchUpInside];
        cpButton.tag = 10;
        [attribute yy_appendString:@" "];
        [attribute appendAttributedString:payIDAttr];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(Width - FitW(44), CGFLOAT_MAX) text:attribute];
        _addressLabel.textLayout = layout;
        
        _paymentIdAddressLabel.text=dict[@"address"];
        _paymentIdLabel.text=dict[@"paymentID"];
        
        [_TitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_amountLine.mas_bottom).offset(FitH(22));
            make.left.equalTo(self).offset(FitW(22));
        }];
        [_createPaymentIdButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_TitleLabel);
            make.right.equalTo(self).offset(FitW(-29));
            make.height.width.mas_equalTo(28);
        }];
        [_paymentIdPromptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_createPaymentIdButton.mas_bottom).offset(FitH(11));
            make.left.equalTo(_TitleLabel);
            make.right.equalTo(self.mas_right).offset(FitW(-26));
        }];

        [_paymentIdAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_paymentIdPromptLabel.mas_bottom).offset(FitH(11));
            make.left.equalTo(_paymentIdPromptLabel);
            make.right.equalTo(self.mas_right).offset(FitW(-102));
        }];
        
        [_paymentIdAddressCPButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_paymentIdAddressLabel.mas_bottom);
            make.right.equalTo(self).offset(FitW(-29));
            make.height.width.mas_equalTo(28);
        }];
        
        [_paymentIdAddressLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_paymentIdAddressCPButton.mas_bottom).offset(FitH(12));
            make.left.equalTo(self).offset(FitW(18));
            make.right.equalTo(self).offset(FitW(-18));
            make.height.mas_equalTo(1);
        }];
        
        
        [_paymentIdTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_paymentIdAddressLine.mas_bottom).offset(FitH(11));
            make.left.equalTo(_paymentIdAddressLabel);
            make.right.equalTo(self.mas_right).offset(FitW(-26));
        }];
        
        [_paymentIdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_paymentIdTitleLabel.mas_bottom).offset(FitH(11));
            make.left.equalTo(_paymentIdTitleLabel);
            make.right.equalTo(self.mas_right).offset(FitW(-102));
        }];
        
        [_paymentIdCPButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_paymentIdLabel.mas_bottom);
            make.right.equalTo(self).offset(FitW(-29));
            make.height.width.mas_equalTo(28);
        }];
        
        
        
        [_paymentIdLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_paymentIdCPButton.mas_bottom).offset(FitH(12));
            make.left.equalTo(self).offset(FitW(18));
            make.right.equalTo(self).offset(FitW(-18));
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self).offset(FitH(-51));
        }];
    }else{
        NSString * str_QrCode=[NSString stringWithFormat:@"darma:%@?tx_payment_id=%@&tx_amount=%@",walletaAddress,@"",_amountField.text];
        
        UIImage *image = [UIImage generateCustomQRCode:str_QrCode andSize:Fit(182) andColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        _qrImageView.image = image;
        
        NSString *address = walletaAddress;
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:address];
        attribute.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        attribute.yy_color = [UIColor colorWithHexString:@"#202640"];
        UIButton *cpButton = [[UIButton alloc] init];
        [cpButton setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
        
        NSMutableAttributedString *payIDAttr = [NSMutableAttributedString yy_attachmentStringWithContent:cpButton contentMode:UIViewContentModeCenter width:Fit(28) ascent:Fit(5) descent:0];
        cpButton.frame = CGRectMake(0, 0, Fit(28), Fit(28));
        [cpButton addTarget:self action:@selector(addressCopy) forControlEvents:UIControlEventTouchUpInside];
        cpButton.tag = 10;
        [attribute yy_appendString:@" "];
        [attribute appendAttributedString:payIDAttr];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(Width - FitW(44), CGFLOAT_MAX) text:attribute];
        _addressLabel.textLayout = layout;
    }
}

-(void)addressCopy{
    NSString *address = _wallteAddress;
    if (address.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = address;
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copied", nil)];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
    
}
- (void)PaymentIdAddressCopy
{
    NSString *PaymentIdAddress = _paymentIdAddressLabel.text;
    if (PaymentIdAddress.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = PaymentIdAddress;
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copied", nil)];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
}

- (void)paymentIDCopy
{

    NSString *paymentID =_paymentIdLabel.text;
    if (paymentID.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = paymentID;
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copied", nil)];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
    
    
    
    
    BOOL isHaveDian = YES;    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isHaveDian = NO;
    }
    
    if ([string length] > 0)
    {
        
        unichar single = [string characterAtIndex:0];
        if ((single >= '0' && single <= '9') || single == '.')
        {
            
            if([textField.text length] == 0)
            {
                if(single == '.') {
                    [SHOWProgressHUD   showMessage:@"Data format error"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            
            if (single == '.')
            {
                if(!isHaveDian)
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [SHOWProgressHUD   showMessage:@"Data format error"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else
            {
                if (isHaveDian)
                {
                    
                    
                    NSRange ran = [textField.text rangeOfString:@"."];
                    
                    if (range.location - ran.location <= 8)
                    {
                        return YES;
                    }
                    else
                    {
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{
            [SHOWProgressHUD   showMessage:@"Data format error"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
   [self createPamentID:_dictInfo walletaAddress:_wallteAddress isCreat:_isCreatePamentID];
    
    return YES;
}


- (UIImageView *)qrImageView
{
    if (!_qrImageView)
    {
        _qrImageView = [[UIImageView alloc] init];
        _qrImageView.image = [UIImage imageNamed:@"QrCode"];
    }
    return _qrImageView;
}

- (YYLabel *)addressLabel
{
    if (!_addressLabel)
    {
        _addressLabel = [[YYLabel alloc] init];
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _addressLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _addressLabel.preferredMaxLayoutWidth = Width - FitW(44);
        _addressLabel.text =@"xxxxxxxxxxxxxxxxxxxxxx";
    }
    return _addressLabel;
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
        _amountField.delegate = self;
    }
    return _amountField;
}

- (UILabel *)amountLine
{
    if (!_amountLine)
    {
        _amountLine = [[UILabel alloc] init];
        
        _amountLine.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _amountLine;
}
-(UIButton *)createPaymentIdButton{
    if (!_createPaymentIdButton)
    {
        _createPaymentIdButton = [[UIButton alloc] init];
        [_createPaymentIdButton setImage:[UIImage imageNamed:@"create_button_receipt"]forState:UIControlStateNormal];
    }
    return _createPaymentIdButton;
}

- (UILabel *)TitleLabel
{
    if (!_TitleLabel)
    {
        _TitleLabel = [[UILabel alloc] init];
        _TitleLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _TitleLabel.text = @"Payment ID";
        _TitleLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _TitleLabel;
}
- (UILabel *)paymentIdPromptLabel
{
    if (!_paymentIdPromptLabel)
    {
        _paymentIdPromptLabel = [[UILabel alloc] init];
        _paymentIdPromptLabel.text = BITLocalizedCapString(@"Integrated_address", nil);
        _paymentIdPromptLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _paymentIdPromptLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
    }
    return _paymentIdPromptLabel;
}
- (YYLabel *)paymentIdAddressLabel
{
    if (!_paymentIdAddressLabel)
    {
        _paymentIdAddressLabel = [[YYLabel alloc] init];
        _paymentIdAddressLabel.numberOfLines = 0;
        _paymentIdAddressLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _paymentIdAddressLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _paymentIdAddressLabel.preferredMaxLayoutWidth = Width - Fit(129);
        _paymentIdAddressLabel.text = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    }
    return _paymentIdAddressLabel;
}
-(UIButton *)paymentIdAddressCPButton{
    if (!_paymentIdAddressCPButton)
    {
        _paymentIdAddressCPButton = [[UIButton alloc] init];
        [_paymentIdAddressCPButton setImage:[UIImage imageNamed:@"copy_button_image"]forState:UIControlStateNormal];
        [_paymentIdAddressCPButton addTarget:self action:@selector(PaymentIdAddressCopy) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentIdAddressCPButton;
}
- (UILabel *)paymentIdAddressLine
{
    if (!_paymentIdAddressLine)
    {
        _paymentIdAddressLine = [[UILabel alloc] init];
        
        _paymentIdAddressLine.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _paymentIdAddressLine;
}

- (UILabel *)paymentIdTitleLabel
{
    if (!_paymentIdTitleLabel)
    {
        _paymentIdTitleLabel = [[UILabel alloc] init];
        _paymentIdTitleLabel.text = BITLocalizedCapString(@"Payment ID(optional)", nil);
        _paymentIdTitleLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _paymentIdTitleLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
    }
    return _paymentIdTitleLabel;
}
- (YYLabel *)paymentIdLabel
{
    if (!_paymentIdLabel)
    {
        _paymentIdLabel = [[YYLabel alloc] init];
        _paymentIdLabel.numberOfLines = 0;
        _paymentIdLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _paymentIdLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _paymentIdLabel.preferredMaxLayoutWidth = Width - FitW(129);
        _paymentIdLabel.text = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    }
    return _paymentIdLabel;
}
-(UIButton *)paymentIdCPButton{
    if (!_paymentIdCPButton)
    {
        _paymentIdCPButton = [[UIButton alloc] init];
        [_paymentIdCPButton setImage:[UIImage imageNamed:@"copy_button_image"]forState:UIControlStateNormal];
        [_paymentIdCPButton addTarget:self action:@selector(paymentIDCopy) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentIdCPButton;
}
- (UILabel *)paymentIdLine
{
    if (!_paymentIdLine)
    {
        _paymentIdLine = [[UILabel alloc] init];
        
        _paymentIdLine.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _paymentIdLine;
}

@end
