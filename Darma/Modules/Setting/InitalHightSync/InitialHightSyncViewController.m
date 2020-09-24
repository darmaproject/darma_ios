




#import "InitialHightSyncViewController.h"

#import "BaseTabBarController.h"
#import "BaseNavController.h"
@interface InitialHightSyncViewController ()
@property(nonatomic ,strong) UILabel *Prompt_enLable;

@property(nonatomic ,strong) UILabel *PromptLable;

@property(nonatomic, strong)UIButton  *sureBtn;

@end

@implementation InitialHightSyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Rescan Blockchain", nil) ;
   
    [self addLayoutUI];
}
- (void)addLayoutUI
{
    [self.view addSubview:self.Prompt_enLable];
    [self.view addSubview:self.PromptLable];
    [self.view addSubview:self.sureBtn];

    [_Prompt_enLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(Fit(20));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(FitW(10));
        make.right.equalTo(self.view).offset(-FitW(10));
    }];
    [_PromptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Prompt_enLable.mas_bottom).offset(Fit(10));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(FitW(10));
        make.right.equalTo(self.view).offset(-FitW(10));
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-53);
        make.height.mas_equalTo(48);
    }];
}
-(void)sure:(UIButton *)sender{
    [[MobileWalletSDKManger shareInstance].mobileWallet rescan_From_Height];
    UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] init];
    activity.color=[UIColor colorWithHexString:@"#3EB7BA"];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    activity.transform=transform;
    [_sureBtn addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(activity.superview);
        make.width.height.mas_equalTo(Fit(20));
    }];
    [activity startAnimating];
    
    __block int timeout = 3;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); 
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ 
            
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                NSLog(@"~~~~~~~~~~~~~~~~%d", timeout);
                [activity stopAnimating];
                [activity hidesWhenStopped];
                [_sureBtn setTitle:BITLocalizedCapString(@"Confirm", nil) forState:UIControlStateNormal];
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                BaseTabBarController *loginVC = [[BaseTabBarController alloc]init];
                BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:loginVC];
                [loginVC.navigationController setNavigationBarHidden:YES];
                window.rootViewController = navigationController;
            });
          
            
        }
        else{
            
            timeout--;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                NSLog(@"~~~~~~~~~~~~~~~~%d", timeout);
                [_sureBtn setTitle:@"" forState:UIControlStateNormal];

            });
        }
    });
    
    
    dispatch_resume(_timer);

}

- (UILabel *)Prompt_enLable
{
    if (!_Prompt_enLable)
    {
        _Prompt_enLable = [[UILabel alloc] init];
        _Prompt_enLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _Prompt_enLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _Prompt_enLable.text=BITLocalizedCapString(@"Wallet may be restored from Topo Height:0", nil);
        _Prompt_enLable.numberOfLines=0;
        _Prompt_enLable.textAlignment=NSTextAlignmentCenter;
    }
    return _Prompt_enLable;
}
- (UILabel *)PromptLable
{
    if (!_PromptLable)
    {
        _PromptLable = [[UILabel alloc] init];
        _PromptLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _PromptLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _PromptLable.text=BITLocalizedCapString(@"Never or Rarely required. Wallet gets busy for 20-30 minutes", nil);
        _PromptLable.numberOfLines=0;
        _PromptLable.textAlignment=NSTextAlignmentCenter;
    }
    return _PromptLable;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn)
    {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:BITLocalizedCapString(@"Confirm", nil) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        _sureBtn.layer.cornerRadius=8.0f;
        _sureBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _sureBtn.layer.borderWidth=1.0f;
        _sureBtn.layer.masksToBounds=YES;
        [_sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
