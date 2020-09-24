



#import "AddAdressViewController.h"

#import "InputAutoChangeHeightView.h"

#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import "UITextView+Placeholder.h"

@interface AddAdressViewController ()<UITextViewDelegate>
@property(nonatomic, strong)InputAutoChangeHeightView *addressName;
@property(nonatomic, strong)InputAutoChangeHeightView *walletAddress;
@property(nonatomic, strong)InputAutoChangeHeightView *paymentIDView;

@property(nonatomic, strong)UIButton  *scanButton;

@property(nonatomic, strong)UIButton  *createBtn;

@end

@implementation AddAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=BITLocalizedCapString(@"Address book", nil) ;
    self.navigateView.title = title;
    self.view.backgroundColor = [UIColor whiteColor];

    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.addressName];
    [self.view addSubview:self.walletAddress];
    [self.view addSubview:self.paymentIDView];
    [self.view addSubview:self.scanButton];

    [self.view addSubview:self.createBtn];
    [_addressName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressName.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
   
    
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_walletAddress.textView);
        make.right.equalTo(_walletAddress).offset(FitW(-24));
        make.width.height.equalTo(@(FitH(28)));
    }];
    
    [_walletAddress.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scanButton.mas_left).offset(3);
    }];
    
    [_paymentIDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_walletAddress.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    
    
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-53);
        make.height.mas_equalTo(48);
    }];
}
- (void)scan:(UIButton *)sender
{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                } else {
                    
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized)
        { 
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { 
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Warm remind", nil) message:BITLocalizedCapString(@"Please go to [settings-privacy-camera-DARMA] to turn on the access switch", nil) preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Warm remind", nil) message:BITLocalizedCapString(@"Your camera is not detected", nil) preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

-(void)setScanInfo:(NSDictionary *)scanInfo{
    _walletAddress.textView.text=scanInfo[@"address"];
    _paymentIDView.textView.text=scanInfo[@"tx_payment_id"];

    if(_walletAddress.textView.text.length == 0){
        _walletAddress.PromptLable.hidden=YES;
    }else{
        _walletAddress.PromptLable.hidden=NO;
        NSInteger numLines = _walletAddress.textView.contentSize.height / _walletAddress.textView.font.lineHeight;
        if (numLines >1) {
            CGSize constraintSize = CGSizeMake(_walletAddress.textView.width, MAXFLOAT);
            CGSize size = [_walletAddress.textView sizeThatFits:constraintSize];
            [_walletAddress.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height);
            }];
        }
    }
    if(_paymentIDView.textView.text.length == 0){
        _paymentIDView.PromptLable.hidden=YES;
    }else{
        _paymentIDView.PromptLable.hidden=NO;
        NSInteger numLines = _paymentIDView.textView.contentSize.height / _paymentIDView.textView.font.lineHeight;
        if (numLines >1) {
            CGSize constraintSize = CGSizeMake(_paymentIDView.textView.width, MAXFLOAT);
            CGSize size = [_paymentIDView.textView sizeThatFits:constraintSize];
           
            [_paymentIDView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height);
            }];
           
        }
    }
   
    
    
}

-(void)create:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected) {
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#BCE6E7"]];
    }else{
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
    }
    NSString *name=[NSString stringWithFormat:@"%@", _addressName.textView.text];
    NSString *walletAddress=[NSString stringWithFormat:@"%@",_walletAddress.textView.text];
    NSString *paymentID=[NSString stringWithFormat:@"%@",_paymentIDView.textView.text];

    if (name.length<=0) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Please enter remarks", nil)];
         return ;
    }
    if (walletAddress.length<=0) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Please enter receiving address", nil)];
        return ;
    }
    NSDictionary  *dic=[[NSDictionary alloc] init];
    dic=@{@"adressName":name,@"walletAddress":walletAddress,@"paymentID":paymentID};
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (_coinName.length<=0) {
        _coinName=@"dmc";
    }
    NSMutableDictionary* addressSDic = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:walletAddressKey]];
    NSMutableArray* addressArray = [[NSMutableArray alloc] initWithArray:addressSDic[_coinName]];
    [addressArray addObject:dic];
  
    [addressSDic setValue:addressArray forKey:_coinName];
    
    [defaults setObject:addressSDic forKey:walletAddressKey];
    [defaults synchronize];
    
    self.addBlock();
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _walletAddress.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    _walletAddress.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * aStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
   
    if(aStr.length == 0){
        if (textView==_walletAddress.textView) {
            _walletAddress.PromptLable.hidden=YES;
        }else{
            _paymentIDView.PromptLable.hidden=YES;
        }
     
    }else{
        if (textView==_walletAddress.textView) {
            _walletAddress.PromptLable.hidden=NO;
        }else{
            _paymentIDView.PromptLable.hidden=NO;
        }
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView==_walletAddress.textView) {
        
        NSInteger numLines = textView.contentSize.height / textView.font.lineHeight;
        if (numLines >1) {
            CGSize constraintSize = CGSizeMake(_walletAddress.textView.width, MAXFLOAT);
            CGSize size = [_walletAddress.textView sizeThatFits:constraintSize];
            [_walletAddress.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height);
            }];
           
        }else{
            [_walletAddress.textView mas_updateConstraints:^(MASConstraintMaker *make) {
             
                make.height.mas_equalTo(40);
            }];
            
        }
    }
    if (textView==_paymentIDView.textView) {
        
        NSInteger numLines = textView.contentSize.height / textView.font.lineHeight;
        if (numLines >1) {
            CGSize constraintSize = CGSizeMake(_paymentIDView.textView.width, MAXFLOAT);
            CGSize size = [_paymentIDView.textView sizeThatFits:constraintSize];
            [_paymentIDView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height);
            }];
            
        }else{
            [_paymentIDView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(40);
            }];
            
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_walletAddress.textView resignFirstResponder];
    _walletAddress.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
}
- (InputAutoChangeHeightView *)addressName
{
    if (!_addressName)
    {
        _addressName = [[InputAutoChangeHeightView alloc] init];
        _addressName.PromptLable.text=BITLocalizedCapString(@"Remark", nil);
        _addressName.textView.placeholderLabel.text=BITLocalizedCapString(@"Remark", nil);
    }
    return _addressName;
}
- (InputAutoChangeHeightView *)walletAddress
{
    if (!_walletAddress)
    {
        _walletAddress = [[InputAutoChangeHeightView alloc] init];
        _walletAddress.PromptLable.text=BITLocalizedCapString(@"Address", nil);
        _walletAddress.textView.placeholderLabel.text=BITLocalizedCapString(@"Address", nil);
        _walletAddress.textView.delegate=self;
        _walletAddress.textView.scrollEnabled=NO;
    }
    return _walletAddress;
}
- (InputAutoChangeHeightView *)paymentIDView
{
    if (!_paymentIDView)
    {
        _paymentIDView = [[InputAutoChangeHeightView alloc] init];
        _paymentIDView.PromptLable.text=BITLocalizedCapString(@"Payment ID(optional)", nil);
        _paymentIDView.textView.placeholderLabel.text=BITLocalizedCapString(@"Payment ID(optional)", nil);
        _paymentIDView.textView.delegate=self;
        _paymentIDView.textView.scrollEnabled=NO;

    }
    return _paymentIDView;
}

- (UIButton *)scanButton
{
    if (!_scanButton)
    {
        _scanButton = [[UIButton alloc] init];
        [_scanButton setImage: [UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}
- (UIButton *)createBtn
{
    if (!_createBtn)
    {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setTitle:BITLocalizedCapString(@"Confirm", nil) forState:UIControlStateNormal];
        _createBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_createBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        
        _createBtn.layer.cornerRadius=8.0f;
        _createBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _createBtn.layer.borderWidth=1.0f;
        _createBtn.layer.masksToBounds=YES;
        [_createBtn addTarget:self action:@selector(create:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
@end
