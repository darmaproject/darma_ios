


#import "PaymentViewController.h"

#import "PaymentTopView.h"
#import "PaymentBottomView.h"

#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import "PaymentVerifyViewController.h"
#import "AddressListViewController.h"
#import "NSString+BITTool.h"

#import "CustomActionView.h"
#import "PaymentManager.h"

@interface PaymentViewController ()<UITextFieldDelegate>
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic,strong)PaymentTopView *topView;
@property(nonatomic, strong) PaymentBottomView *bottomView;
@property(nonatomic, strong) UIButton *sureButton;
@property(nonatomic, assign) BOOL isAll;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Send", nil) ;
    self.navigateView.backgroundImage.hidden=YES;
    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(Fit(12));
        make.right.equalTo(self.view).offset(Fit(-12));
        make.height.equalTo(@(FitH(48)));
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(FitH(-20));
    }];
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentView];
    _contentView.backgroundColor = [UIColor whiteColor];

    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(1);
        make.bottom.equalTo(self.sureButton.mas_top).offset(Fit(-12));
    }];

    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.mainScrollView);
        make.centerX.equalTo(self.mainScrollView);
        make.height.mas_equalTo(Height);

    }];
    
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.bottomView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
    }];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (_isAll) {
         return NO;
    }else{
         return YES;
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
-(void)setAddressInput:(NSString *)addressInput{

}
-(void)setScanInfo:(NSDictionary *)scanInfo{
   
    
    _bottomView.scanInfo=scanInfo;
}
- (void)selectAddress:(UIButton *)sender
{
    AddressListViewController*controller = [[AddressListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.info = ^(NSDictionary * _Nonnull dict) {
         _bottomView.selectInfo=dict;
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)allAmount:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
        _bottomView.amountField.text=@"";
        _bottomView.markLable.hidden=NO;
        _isAll=YES;
    }else{
        _bottomView.markLable.hidden=YES;
        _isAll=NO;
    }
   
}
- (void)send:(UIButton *)sender
{

    NSString *address=_bottomView.addressField.text;
   
    if (address.length<=0) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Please enter receiving address", nil)];
        return;
    }
    NSString *paymenID=_bottomView.paymentField.text;


    
   
    NSString *amount=_bottomView.amountField.text;
    PaymentManager *manager=[[PaymentManager alloc] init];
    [manager transfer:address amountstr:amount unlock_time_str:@"0" payment_id:paymenID mixin:0 sendtx:NO password:@"" isAll:_isAll success:^(NSDictionary * _Nonnull transferInfo) {
            PaymentVerifyViewController*controller = [[PaymentVerifyViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.dicInfo=transferInfo;
            controller.address=address;
            controller.paymentID=paymenID;
            [self.navigationController pushViewController:controller animated:YES];
        
    } fail:^(NSDictionary * _Nonnull error) {
        NSString *errCode=[NSString  stringWithFormat:@"%@",error[@"errCode"]];
        if ([errCode intValue]==1007) {
            CustomActionView *actionV = [[CustomActionView alloc] init];
            actionV.frame = CGRectMake(0, 0, Width, Height);
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:actionV];
            
            actionV.title=BITLocalizedCapString(@"Enter the password",nil);
            actionV.placeholder=BITLocalizedCapString(@"Please enter password",nil);
            actionV.determineBlock = ^(NSString * _Nonnull string) {
                [manager transfer:address amountstr:amount unlock_time_str:@"0" payment_id:paymenID mixin:0 sendtx:NO password:string isAll:_isAll success:^(NSDictionary * _Nonnull transferInfo) {
                    PaymentVerifyViewController*controller = [[PaymentVerifyViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.dicInfo=transferInfo;
                    controller.address=address;
                    controller.paymentID=paymenID;
                    [self.navigationController pushViewController:controller animated:YES];
                    
                } fail:^(NSDictionary * _Nonnull error) {
                    [SHOWProgressHUD showMessage:error[@"errMsg"]];
                }];
            };
        }else{
            [SHOWProgressHUD showMessage:error[@"errMsg"]];
        }
    }];
    
    
}
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView)
    {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.alwaysBounceVertical = YES;
        
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _mainScrollView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}
- (PaymentTopView *)topView
{
    if (!_topView)
    {
        _topView = [[PaymentTopView alloc] init];
        _topView.backgroundColor=[UIColor whiteColor];
        _topView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;


        _topView.layer.shadowOpacity = 0.02;
        _topView.layer.masksToBounds = NO;
        UIBezierPath *path=[UIBezierPath bezierPathWithRect:CGRectMake(0,70, Width, 20)];
        _topView.layer.shadowPath=path.CGPath;
        _topView.walletName=[[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
        _topView.kyAmount=[[NSString stringWithFormat:@"%@",_infoDict[@"unlocked_balance"] ]removeEndZero] ;
    }
    return _topView;
}
- (PaymentBottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[PaymentBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.markLable.hidden=YES;
        [_bottomView.scanButton addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.selectAddress addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.AllButton addTarget:self action:@selector(allAmount:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.amountField.delegate=self;
    }
    return _bottomView;
}
- (UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:BITLocalizedCapString(@"Send", nil)forState:UIControlStateNormal];
        _sureButton.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_sureButton setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        
        _sureButton.layer.cornerRadius=8.0f;
        _sureButton.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _sureButton.layer.borderWidth=1.0f;
        _sureButton.layer.masksToBounds=YES;
        [_sureButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
@end
