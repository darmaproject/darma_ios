



#import "SHOWProgressHUD.h"

#import "MBProgressHUD.h"

@implementation SHOWProgressHUD
+ (void)showMessage:(NSString *)message
{
    [SHOWProgressHUD showMessage:message afterDelayTime:3];
}

+ (void)showMessage:(NSString *)message afterDelayTime:(CGFloat)delayTime
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:YES];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:delayTime];
    });
}

+ (void)hideHUD
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (MBProgressHUD* )createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow
{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message ? message:@"Loading.....";
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


@end
