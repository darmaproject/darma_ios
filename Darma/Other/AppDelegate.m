


#import "AppDelegate.h"

#import "BaseTabBarController.h"
#import "BaseNavController.h"
#import "ChooseTypeViewController.h"

#import "LoginViewController.h"
#import "RestoreBackupWalletViewController.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [NSThread sleepForTimeInterval:3];
    UIWindow *window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    [[MobileWalletSDKManger shareInstance] saveDefaultNodeList];
    NSMutableArray *dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:addressNameKey]];

    if (dataArray.count>0) {
        LoginViewController*LoginVC = [[LoginViewController alloc]init];
        BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:LoginVC];
        [LoginVC.navigationController setNavigationBarHidden:YES];
        self.window.rootViewController = navigationController;
        
    }else{
        ChooseTypeViewController*noWallteVC = [[ChooseTypeViewController alloc]init];
        BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:noWallteVC];
        [noWallteVC.navigationController setNavigationBarHidden:YES];
        self.window.rootViewController = navigationController;
    }
    
    [self.window makeKeyAndVisible];
    
    [self initKeyBoard];
    return YES;
}

-(void)initKeyBoard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; 
    
    keyboardManager.enable = YES; 
    
    keyboardManager.shouldResignOnTouchOutside = YES; 
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; 
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; 
    
    keyboardManager.enableAutoToolbar = YES; 
    
    keyboardManager.shouldShowToolbarPlaceholder = YES; 
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; 
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; 
    
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    NSLog(@"app=====%@ \n  url=======%@ \n  options======%@", app, url,options);
    NSString *path = [url absoluteString];
   
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)path, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSLog(@"decodedString = %@",decodedString);
    
    
    path = decodedString;
    NSMutableString *string = [[NSMutableString alloc] initWithString:path];
    if ([path hasPrefix:@"file://"]) {
        [string replaceOccurrencesOfString:@"file://" withString:@"" options:NSCaseInsensitiveSearch  range:NSMakeRange(0, path.length)];
    }

    RestoreBackupWalletViewController*backup = [[RestoreBackupWalletViewController alloc]init];
    backup.fileUrl=[NSString stringWithFormat:@"%@",string];
    BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:backup];
    [backup.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}


@end


