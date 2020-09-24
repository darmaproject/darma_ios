



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHOWProgressHUD : NSObject
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message afterDelayTime:(CGFloat)delayTime;

@end

NS_ASSUME_NONNULL_END
