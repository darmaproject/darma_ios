


#import "FingerFaceGestureSetViewCon.h"

#import "SetGesViewController.h"
#import "BITVerifyGestureViewController.h"

@interface FingerFaceGestureSetViewCon ()<SetGesDelegate,VerifyGesDelegate>{
    int currentNum;
}
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *bottomLine;

@property(nonatomic, strong) UILabel *titleLabelA;
@property(nonatomic, strong) UISwitch *isSwitchA;
@property(nonatomic, strong) UILabel *bottomLineA;

@property(nonatomic, strong) UILabel *titleLabelB;
@property(nonatomic, strong) UISwitch *isSwitchB;
@property(nonatomic, strong) UILabel *bottomLineB;

@property (strong,nonatomic) LAContext* context;
@property (nonatomic,strong) SetGesViewController *setGesVC;
@property (nonatomic,strong) BITVerifyGestureViewController *verifyVC;
@property (nonatomic,strong)NSString *GesPass;


@end

@implementation FingerFaceGestureSetViewCon
-(void)viewWillAppear:(BOOL)animated{
    BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
    if (isTouchID) {
        [_isSwitchA  setOn:YES animated:NO];
    }else{
        [_isSwitchA  setOn:NO animated:NO];
    }
    self.GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
    if (self.GesPass && self.GesPass.length != 0) {
        BOOL isOn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOnGesPass"];
        if(isOn){
            [_isSwitchB  setOn:YES animated:NO];
        }else{
            [_isSwitchB  setOn:NO animated:NO];
        }
    }else{
        [_isSwitchB  setOn:NO animated:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *title = BITLocalizedCapString(@"set unlock password", nil);
    self.navigateView.title = title;
    [self addlayout];
    
}
-(void)addlayout{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.bottomLine];
    
    [self.view addSubview:self.isSwitchA];
    [self.view addSubview:self.titleLabelA];
    [self.view addSubview:self.bottomLineA];
    
    [self.view addSubview:self.isSwitchB];
    [self.view addSubview:self.titleLabelB];
    [self.view addSubview:self.bottomLineB];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(FitH(16));
        make.left.equalTo(self.view).offset(FitW(12));
        make.right.equalTo(self.view).offset(FitW(-12));
    }];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(FitH(14));
        make.left.equalTo(self.view).offset(FitW(12));
        make.right.equalTo(self.view).offset(FitW(-12));
        make.height.equalTo(@(FitH(1)));
    }];
    
    
    [_isSwitchA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomLine).offset(FitH(8));
        make.right.equalTo(self.view).offset(-FitW(12));
        make.width.equalTo(@(FitW(50)));
        make.height.equalTo(@(FitH(30)));
    }];
    [_titleLabelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isSwitchA);
        make.left.equalTo(_bottomLine).offset(FitW(10));
        make.right.equalTo(_isSwitchA.mas_left).offset(FitW(-12));
    }];
    [_bottomLineA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_isSwitchA.mas_bottom).offset(FitH(8));
        make.left.equalTo(self.view).offset(FitW(12));
        make.right.equalTo(self.view).offset(FitW(-12));
        make.height.equalTo(@(FitH(1)));
    }];
    
    [_isSwitchB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomLineA.mas_bottom).offset(FitH(8));
        make.right.equalTo(self.view).offset(-FitW(12));
        make.width.equalTo(@(FitW(50)));
        make.height.equalTo(@(FitH(30)));
    }];
    [_titleLabelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isSwitchB);
        make.left.equalTo(_bottomLineA).offset(FitW(10));
        make.right.equalTo(_isSwitchB.mas_left).offset(FitW(-12));
    }];
    [_bottomLineB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_isSwitchB.mas_bottom).offset(FitH(8));
        make.left.equalTo(self.view).offset(FitW(12));
        make.right.equalTo(self.view).offset(FitW(-12));
        make.height.equalTo(@(FitH(1)));
    }];
    
}

-(void)FaceOrTouchID:(UISwitch *)isSwitch{
    
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    self.context = [[LAContext alloc] init];
    self.context.localizedCancelTitle =BITLocalizedCapString(@"Cancel", nil);
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        if (@available(iOS 11.0,*)) {
            NSError *error = nil;
            BOOL isSupport = [self.context canEvaluatePolicy:(deviceType) error:&error];
            if (isSupport) {
                [self touchID:self.context andLockOut:NO];
            }else{
                
                
                if (error.code==LAErrorPasscodeNotSet) { 
                    [SHOWProgressHUD showMessage:BITLocalizedCapString(@"you haven't set password", nil)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
                        if (isTouchID) {
                            [_isSwitchA  setOn:YES animated:NO];
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpenUnlock"];
                            
                        }else{
                            [_isSwitchA  setOn:NO animated:NO];
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpenUnlock"];
                        }
                    });
                }else if (error.code==LAErrorTouchIDNotEnrolled) {
                    [SHOWProgressHUD showMessage:BITLocalizedCapString(@"you haven't set Touch/Face ID. Go to Settings > Touch/Face ID & Passcode to set your Touch/Face ID.", nil)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
                        if (isTouchID) {
                            [_isSwitchA  setOn:YES animated:NO];
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpenUnlock"];
                            
                        }else{
                            [_isSwitchA  setOn:NO animated:NO];
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpenUnlock"];
                        }
                    });
                }else if (error.code==LAErrorTouchIDLockout) { 
                    [self touchID:self.context andLockOut:YES];
                }
                
            }
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_isSwitchA  setOn:NO animated:NO];
            [[NSUserDefaults standardUserDefaults] setBool:_isSwitchA.isOn forKey:@"isOpenUnlock"];
        });
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
                BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
                if (isTouchID) {
                    [_isSwitchA  setOn:NO animated:NO];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpenUnlock"];
                    
                }else{
                    [_isSwitchA  setOn:YES animated:NO];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpenUnlock"];
                }
            });
        }else{
            switch (error.code) {
                case LAErrorSystemCancel:{
                    
                    break;
                }
                case LAErrorUserCancel:{
                    
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
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                    }];
                    break;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
                if (isTouchID) {
                    [_isSwitchA  setOn:YES animated:NO];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpenUnlock"];
                    
                }else{
                    [_isSwitchA  setOn:NO animated:NO];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpenUnlock"];
                }
            });
        }
        
    }];
}

-(void)gesturesID:(UISwitch *)isSwitch{
    self.GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
    if (self.GesPass && self.GesPass.length != 0) {
        self.verifyVC = [[BITVerifyGestureViewController alloc]init];
        self.verifyVC.delegate = self;
        self.verifyVC.className=@"Switch gesture unlock";
        currentNum=0;
        self.verifyVC.controller=self;
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:self.verifyVC];
        [self presentViewController:nv animated:YES completion:nil];
    }else{
        self.setGesVC=[[SetGesViewController alloc] init];
        self.setGesVC.delegate = self;
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:self.setGesVC];
        [self presentViewController:nv animated:YES completion:nil];
    }
}

- (void)getGesPass:(NSString *)pass{
    
    self.GesPass = [NSString stringWithFormat:@"%@",pass];
    [[NSUserDefaults standardUserDefaults] setObject:self.GesPass forKey:@"isSetGesPass"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOnGesPass"];
    
}


- (void)verifyGesPass:(NSString *)pass{
    currentNum++;
    self.GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
    if (self.GesPass && self.GesPass.length != 0) {
        if ([self.GesPass isEqualToString:pass]) {
            
            [self.verifyVC isSuccessGesPass:YES];
            BOOL isOn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOnGesPass"];
            if(isOn){
                [_isSwitchB  setOn:NO animated:NO];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOnGesPass"];
            }else{
                [_isSwitchB  setOn:YES animated:NO];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOnGesPass"];
                
            }
            
        }else{
            NSLog(@"Patterns do not match");
            [self.verifyVC isSuccessGesPass:NO];
            if (currentNum>=5) {
                [self.verifyVC dismiss:self];
            }
            
            
            
            
            
            
            
            
        }
    }
}


- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = BITLocalizedCapString(@"password unlock", nil);
    }
    return _titleLabel;
}
- (UILabel *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    }
    return _bottomLine;
}
- (UILabel *)titleLabelA
{
    if (!_titleLabelA)
    {
        _titleLabelA = [[UILabel alloc] init];
        _titleLabelA.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabelA.textAlignment = NSTextAlignmentLeft;
        _titleLabelA.font = [UIFont systemFontOfSize:14];
        _titleLabelA.text = BITLocalizedCapString(@"face recongnition/touch unlock", nil);
    }
    return _titleLabelA;
}
- (UISwitch *)isSwitchA
{
    if (!_isSwitchA)
    {
        _isSwitchA = [[UISwitch alloc] init];
        BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
        if (isTouchID) {
            [_isSwitchA  setOn:YES animated:NO];
        }else{
            [_isSwitchA  setOn:NO animated:NO];
        }
        [_isSwitchA addTarget:self action:@selector(FaceOrTouchID:) forControlEvents:UIControlEventValueChanged];
    }
    return _isSwitchA;
}
- (UILabel *)bottomLineA
{
    if (!_bottomLineA)
    {
        _bottomLineA = [[UILabel alloc] init];
        _bottomLineA.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    }
    return _bottomLineA;
}
- (UILabel *)titleLabelB
{
    if (!_titleLabelB)
    {
        _titleLabelB = [[UILabel alloc] init];
        _titleLabelB.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabelB.textAlignment = NSTextAlignmentLeft;
        _titleLabelB.font = [UIFont systemFontOfSize:14];
        _titleLabelB.numberOfLines=0;
        _titleLabelB.text = BITLocalizedCapString(@"gesture code unlock", nil);
    }
    return _titleLabelB;
}
- (UISwitch *)isSwitchB
{
    if (!_isSwitchB)
    {
        _isSwitchB = [[UISwitch alloc] init];
        BOOL isGesPass=[[NSUserDefaults standardUserDefaults] boolForKey:@"isSetGesPass"];
        if (isGesPass) {
            [_isSwitchB  setOn:YES animated:NO];
        }else{
            [_isSwitchB  setOn:NO animated:YES];
        }
        [_isSwitchB addTarget:self action:@selector(gesturesID:) forControlEvents:UIControlEventValueChanged];
    }
    return _isSwitchB;
}
- (UILabel *)bottomLineB
{
    if (!_bottomLineB)
    {
        _bottomLineB = [[UILabel alloc] init];
        _bottomLineB.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    }
    return _bottomLineB;
}


@end
