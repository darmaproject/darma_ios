



#import "BaseTabBarController.h"

#import "HomeViewController.h"
#import "TradeViewController.h"
#import "SettingViewController.h"

#import "UnlockPasswordViewController.h"
#import "BITVerifyGestureViewController.h"
#import "LoginViewController.h"
#import "RequestAPIManager.h"

@interface BaseTabBarController ()<VerifyGesDelegate>{
    int currentNum;
    NSString *isqidong;
}
@property(nonatomic,strong)NSDate * date;
@property (nonatomic,strong) BITVerifyGestureViewController *verifyVC;

@end

@implementation BaseTabBarController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:@"changeLanguage" object:nil];
    [self getRequestIsShowExchange];
    self.selectedIndex = 0;
}
-(void)changeLanguage:(NSNotification *)info{
    [self getRequestIsShowExchange];
    self.selectedIndex = 0;
}


- (void)setupSubviews:(NSString *)status
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#C7C7CB"];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#3EB7BA"];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [UITabBar appearance].translucent = NO;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    
    HomeViewController*HomeCon = [[HomeViewController alloc]init];
  
    HomeCon.tabBarItem.title = BITLocalizedCapString(@"Wallet", nil) ;
    HomeCon.tabBarItem.tag = 1;
    HomeCon.tabBarItem.image = [UIImage imageNamed:@"qianbao-normal"];
    HomeCon.tabBarItem.selectedImage = [[UIImage imageNamed:@"qianbao-select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    TradeViewController*TradeCon = [[TradeViewController alloc]init];
    TradeCon.tabBarItem.title = BITLocalizedCapString(@"str_transfer", nil);
    TradeCon.tabBarItem.tag = 2;
    TradeCon.tabBarItem.image = [UIImage imageNamed:@"jiaoyi-normal"];
    TradeCon.tabBarItem.selectedImage = [[UIImage imageNamed:@"jiaoyi-select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    SettingViewController*MyCenterCon = [[SettingViewController alloc]init];
    MyCenterCon.tabBarItem.title = BITLocalizedCapString(@"Settings", nil);
    MyCenterCon.tabBarItem.tag = 3;
    MyCenterCon.tabBarItem.image = [UIImage imageNamed:@"set-normal"];
    MyCenterCon.tabBarItem.selectedImage = [[UIImage imageNamed:@"set-select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    self.viewControllers=[[NSArray alloc]init];
    if ([status intValue]==0) {
        self.viewControllers = @[HomeCon,MyCenterCon];
    }else{
        self.viewControllers = @[HomeCon,TradeCon,MyCenterCon];
    }

}

-(void)getRequestIsShowExchange{
    RequestAPIManager *manager=[[RequestAPIManager alloc] init];
    [manager GETExchangeStatusSuccess:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
        NSString *status=[[NSString alloc] initWithFormat:@"%@",dic[@"status"]];
        [self setupSubviews:status];
    } fail:^(NSURLSessionDataTask * task, NSError * error) {
        [self setupSubviews:@"0"];
    }];
    
}
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    NSDate * datee = [NSDate date];
    NSTimeInterval start = [self.date timeIntervalSince1970]*1;
    NSTimeInterval end = [datee timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    
    BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
    if (isTouchID) {
        
        if(value >10 &&self.date){
            [self addLockView];
        }
    }else{
        NSString* GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
        if (GesPass && GesPass.length != 0) {
            BOOL isOn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOnGesPass"];
            if(isOn){
                if(value >1 &&self.date){
                    [self addGestureLockView];
                }
            }
        }
    }
}
- (void)applicationBecomeActive:(NSNotification *)notification
{
    isqidong=[[NSUserDefaults standardUserDefaults] objectForKey:@"qidong"];
    if ([isqidong isEqualToString:@"StartAPP"]) {
        BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
        if (isTouchID) {
            [self addLockView];
        }else{
            NSString* GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
            if (GesPass && GesPass.length != 0) {
                BOOL isOn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOnGesPass"];
                if(isOn){
                    [self addGestureLockView];
                }
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"APP has already started" forKey:@"qidong"];
    }
}
- (void)applicationEnterBackground:(NSNotification *)notification
{
    self.date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:@"APP has already started" forKey:@"qidong"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}


-(void)addLockView{
    UnlockPasswordViewController *loginVC= [[UnlockPasswordViewController alloc] init];

    loginVC.controller=(UINavigationController *)self.selectedViewController;

    [self presentViewController:loginVC animated:YES completion:nil];
}


-(void)addGestureLockView{
    currentNum=0;
    self.verifyVC = [[BITVerifyGestureViewController alloc]init];
    self.verifyVC.delegate = self;

    self.verifyVC.controller=(UINavigationController *)self.selectedViewController;
    [self presentViewController:self.verifyVC animated:YES completion:nil];
}


- (void)verifyGesPass:(NSString *)pass{
    currentNum++;
    NSString* GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
    if (GesPass && GesPass.length != 0) {
        if ([GesPass isEqualToString:pass]) {
            
            [self.verifyVC isSuccessGesPass:YES];
            [self.verifyVC dismiss:self];
        }else{
            NSLog(@"Patterns do not match");
            [self.verifyVC isSuccessGesPass:NO];
            if (currentNum>=3) {
                [self.verifyVC dismiss:self];
                
                [[MobileWalletSDKManger shareInstance] closeWallet];
                [MobileWalletSDKManger shareInstance].mobileWallet=[[AppwalletMobileWallet alloc] init];
                LoginViewController*loginVC= [[LoginViewController alloc] init];
                [loginVC setHidesBottomBarWhenPushed:YES];
                UINavigationController *navC=(UINavigationController *)self.selectedViewController.navigationController;
                [navC pushViewController:loginVC animated:YES];
            }
        }
    }
}
@end
