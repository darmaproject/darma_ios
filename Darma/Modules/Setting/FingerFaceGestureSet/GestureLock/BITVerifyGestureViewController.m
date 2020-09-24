



#import "BITVerifyGestureViewController.h"

#import "Define.h"
#import "ContentView.h"
#import "UnlockPasswordViewController.h"
#import "LoginViewController.h"

@interface BITVerifyGestureViewController ()
@property(nonatomic,strong) UIImageView *faceImageV;
@property(nonatomic,strong) UIButton *faceIDBtn;
@property(nonatomic,strong) UIButton *forgetBtn;
@end

@implementation BITVerifyGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    if ([_className isEqualToString: @"Switch gesture unlock"]) {
        self.navigateView.hidden=NO;
        self.faceImageV.hidden=YES;
        self.faceIDBtn.hidden=YES;
        self.forgetBtn.hidden=YES;
    }else{
        self.navigateView.hidden=YES;
        BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
        if (isTouchID) {
            self.faceImageV.hidden=NO;
            self.faceIDBtn.hidden=NO;
        }else{
            self.faceImageV.hidden=YES;
            self.faceIDBtn.hidden=YES;
        }
    }
}
- (void)addUI{
    
    [self.view addSubview:self.icon];
    [self.view addSubview:self.userAcc];
    
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.faceImageV];
    [self.view addSubview:self.faceIDBtn];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FitW(26));
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(FitW(-40));
        make.height.equalTo(@40);
    }];
    [_faceIDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(FitW(-26));
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(FitW(-40));
        make.height.equalTo(@40);
    }];
    [_faceImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_faceIDBtn.mas_left).offset(FitW(-2));
        make.width.height.equalTo(@22);
        make.centerY.equalTo(_faceIDBtn);
    }];

}
-(void)forgetBtn:(UIButton *)sender{

    
    [_controller dismissViewControllerAnimated:YES completion:nil];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSetGesPass"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isOnGesPass"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isOpenUnlock"];
    [[MobileWalletSDKManger shareInstance] closeWallet];
    [MobileWalletSDKManger shareInstance].mobileWallet=[[AppwalletMobileWallet alloc] init];
    LoginViewController *logVCon=[[LoginViewController alloc] init];
    [logVCon.navigationController setNavigationBarHidden:YES];
    [_controller.navigationController pushViewController:logVCon animated:YES];
}
-(void)faceIDBtn:(UIButton *)sender{

    UnlockPasswordViewController *loginVC= [[UnlockPasswordViewController alloc] init];
    loginVC.controller=_controller;
    [self presentViewController:loginVC animated:YES completion:nil];
}


- (void)nextRequest{
    
    self.tipText.text = @"";
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(verifyGesPass:)]) {
        [self.delegate verifyGesPass:self.passStr];
    }
}

- (void)isSuccessGesPass:(BOOL)able{
    if (able) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [_controller dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.tipText setFaildWithNSString:BITLocalizedCapString( @"Patterns do not match", nil)];
    }
}
-(void)dismiss:(UIViewController*)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];

}

- (UILabel *)userAcc{
    if (!_userAcc) {

        _userAcc = [[UILabel alloc]initWithFrame:CGRectMake(0, self.tipText.frame.origin.y-FitH(30), S_WIDTH, FitH(30))];

        _userAcc.font = [UIFont systemFontOfSize:14];
        _userAcc.textColor = [UIColor colorWithHexString:@"#202640"];
        _userAcc.textAlignment = NSTextAlignmentCenter;
        NSString *title= [[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
        if (title.length>4) {
            title=[title substringToIndex:4];
            title=[NSString stringWithFormat:@"%@...",title];
        }
        _userAcc.text = title;
    }
    return _userAcc;
}

- (UIImageView *)icon{
    if (!_icon) {
    

        CGFloat w = FitW(190);

        CGFloat y = self.userAcc.frame.origin.y-FitH(30);

        CGFloat h =FitW(64);
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, w, h)];
        _icon.center = CGPointMake(self.view.center.x, y);

            _icon.image = [UIImage imageNamed:@"logo"];


    }
    return _icon;
}

- (UIButton *)forgetBtn
{
    if (!_forgetBtn)
    {
        _forgetBtn = [[UIButton alloc] init];
        [_forgetBtn setTitle:BITLocalizedCapString(@"Forget gesture?", nil) forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_forgetBtn setTitleColor:[UIColor colorWithHexString:@"#E1C303"] forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(forgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

- (UIImageView *)faceImageV
{
    if (!_faceImageV)
    {
        _faceImageV = [[UIImageView alloc] init];
        _faceImageV.image = [UIImage imageNamed:@"faceIdImage"];
    }
    return _faceImageV;
}
- (UIButton *)faceIDBtn
{
    if (!_faceIDBtn)
    {
        _faceIDBtn = [[UIButton alloc] init];
        [_faceIDBtn setTitle:BITLocalizedCapString(@"face recongnition/touch unlock", nil) forState:UIControlStateNormal];
        _faceIDBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_faceIDBtn setTitleColor:[UIColor colorWithHexString:@"#E1C303"] forState:UIControlStateNormal];
        [_faceIDBtn addTarget:self action:@selector(faceIDBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceIDBtn;
}
@end
