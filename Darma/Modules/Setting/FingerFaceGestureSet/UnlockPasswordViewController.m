

#import "UnlockPasswordViewController.h"

#import "BITVerifyGestureViewController.h"
#import "LoginViewController.h"

@interface UnlockPasswordViewController ()<VerifyGesDelegate>{
    int currentNum;
}
@property(nonatomic, strong) UIImageView *headImageV;
@property(nonatomic, strong) UILabel *accountLabel;
@property (strong,nonatomic) LAContext* context;
@property (nonatomic,strong) BITVerifyGestureViewController *verifyVC;

@end

@implementation UnlockPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.hidden=YES;
    
    [self.view addSubview:self.headImageV];
    [self.view addSubview:self.accountLabel];
    [_headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(FitW(70));
        make.centerX.equalTo(self.view);

        make.height.mas_equalTo(FitH(64));
        make.width.mas_equalTo(FitW(190));
    }];
    
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageV.mas_bottom).offset(FitW(20));
        make.centerX.equalTo(self.view);
    }];
    [self FaceOrTouchID];
}

-(void)FaceOrTouchID{
    
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    self.context = [[LAContext alloc] init];
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        if (@available(iOS 11.0,*)) {
            NSError *error = nil;
            BOOL isSupport = [self.context canEvaluatePolicy:(deviceType) error:&error];
            if (isSupport) {
                [self touchID:self.context andLockOut:NO];
            }else{
                if (error.code==LAErrorPasscodeNotSet) { 
                    [SHOWProgressHUD showMessage:BITLocalizedCapString(@"you haven't set password", nil)];
                }else if (error.code==LAErrorTouchIDNotEnrolled) {
                    [SHOWProgressHUD showMessage:BITLocalizedCapString(@"you haven't set Touch/Face ID. Go to Settings > Touch/Face ID & Passcode to set your Touch/Face ID.", nil)];
                }else if (error.code==LAErrorTouchIDLockout) { 
                    [self touchID:self.context andLockOut:YES];
                }
            }
        }
    }else{
        
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Touch unlock or face recognition is not supported by your device.", nil)];
    }
    
}
-(void)touchID:(LAContext *)contxt andLockOut:(BOOL)lock{
    self.context.localizedFallbackTitle = lock?BITLocalizedCapString(@"password unlock", nil):BITLocalizedCapString(@"please try again", nil);
    self.context.localizedCancelTitle =BITLocalizedCapString(@"Cancel", nil);
    NSInteger deviceType =lock?LAPolicyDeviceOwnerAuthentication:LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    NSString * message;
    if (IS_IPHONE_X) {
        message = lock?BITLocalizedCapString(@"Errors. Your password is required to enable Face ID.", nil):BITLocalizedCapString(@"face ID", nil);
        
    }else{
        message = lock?BITLocalizedCapString(@"Errors. Your password is required to enable Touch ID.", nil):BITLocalizedCapString(@"verify fingerprint", nil);
    }
    [self.context evaluatePolicy:deviceType localizedReason:message reply:^(BOOL success, NSError *error) {
        if (success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                [_controller dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            switch (error.code) {
                case LAErrorSystemCancel:{
                    
                    break;
                }
                case LAErrorUserCancel:{
                    
                    [self touchIdAndFaceIdVerifyFail];
                    break;
                }
                case LAErrorAuthenticationFailed:{
                    
                    if ([error.localizedDescription isEqualToString:@"Application retry limit exceeded."]){
                        [self touchID:self.context andLockOut:NO];
                    }
                    break;
                }
                case LAErrorPasscodeNotSet:{
                    
                    break;
                }
                case LAErrorTouchIDNotAvailable:{
                    
                    [self touchIdAndFaceIdVerifyFail];
                    break;
                }
                case LAErrorUserFallback:{
                    
                    [self touchID:self.context andLockOut:NO];
                    break;
                }
                case LAErrorTouchIDLockout:{
                    if ([error.localizedDescription isEqualToString:@"Biometry is disabled for unlock."]){
                        [self touchID:self.context andLockOut:NO];
                    } else if ([error.localizedDescription isEqualToString:@"Biometry is locked out."]){
                        [self touchID:self.context andLockOut:YES];
                    }
                    break;
                }
                case LAErrorAppCancel:{
                    
                    break;
                }
                default:{
                    
                    
                    
                    [self touchIdAndFaceIdVerifyFail];
                    break;
                }
            }
            
        }
        
    }];
}
-(void)touchIdAndFaceIdVerifyFail{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString*  GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
        if (GesPass && GesPass.length != 0) {
            BOOL isOn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOnGesPass"];
            if(isOn){
                currentNum=0;
                self.context.localizedCancelTitle =@"";
                self.verifyVC = [[BITVerifyGestureViewController alloc]init];
                self.verifyVC.delegate = self;
                self.verifyVC.controller=_controller;
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:self.verifyVC];
                
                UIViewController* currentViewController=[self jsd_getCurrentViewController];
                [currentViewController presentViewController:nv animated:YES completion:nil];
                
            }else{
                [_controller dismissViewControllerAnimated:YES completion:nil];
                [MobileWalletSDKManger shareInstance].mobileWallet=[[AppwalletMobileWallet alloc] init];
                LoginViewController *logVCon=[[LoginViewController alloc] init];
                [logVCon.navigationController setNavigationBarHidden:YES];
                [_controller.navigationController pushViewController:logVCon animated:YES];
            }
            
        }else{
            [[MobileWalletSDKManger shareInstance] closeWallet];
            [MobileWalletSDKManger shareInstance].mobileWallet=[[AppwalletMobileWallet alloc] init];
            LoginViewController*LoginVC = [[LoginViewController alloc]init];
            [LoginVC.navigationController setNavigationBarHidden:YES];
            [_controller.navigationController pushViewController:LoginVC animated:YES];
        }
        
    });
}

-(UIViewController *)jsd_getCurrentViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController* currentViewController = window.rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}


- (void)verifyGesPass:(NSString *)pass{
    currentNum++;
    NSString* GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
    if (GesPass && GesPass.length != 0) {
        if ([GesPass isEqualToString:pass]) {
            
            [_controller dismissViewControllerAnimated:YES completion:nil];
            
            [self.verifyVC isSuccessGesPass:YES];
        }else{
            NSLog(@"Patterns do not match");
            [self.verifyVC isSuccessGesPass:NO];
            if (currentNum==3) {
                [_controller dismissViewControllerAnimated:YES completion:nil];
                [self.verifyVC dismiss:self];
                [[MobileWalletSDKManger shareInstance] closeWallet];
                [MobileWalletSDKManger shareInstance].mobileWallet=[[AppwalletMobileWallet alloc] init];
                LoginViewController *logVCon=[[LoginViewController alloc] init];
                [logVCon.navigationController setNavigationBarHidden:YES];
                [_controller.navigationController pushViewController:logVCon animated:YES];
            }
        }
    }
}

- (UIImageView *)headImageV
{
    if (!_headImageV)
    {
        _headImageV = [[UIImageView alloc] init];
    }
    return _headImageV;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel)
    {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        _accountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _accountLabel.numberOfLines=0;
        NSString *title= [[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
        if (title.length>4) {
            title=[title substringToIndex:4];
            title=[NSString stringWithFormat:@"%@...",title];
        }
        _accountLabel.text=title;
        
    }
    return _accountLabel;
}

@end
