



#import "GesBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VerifyGesDelegate<NSObject>

- (void)verifyGesPass:(NSString *)pass;
- (void)forgetPass;
- (void)faceLock;

@end
@interface BITVerifyGestureViewController : GesBaseViewController
@property (nonatomic,strong)UILabel *userAcc;

@property (nonatomic,strong)UIImageView *icon; 
@property(nonatomic,strong) NSString *className;
@property(nonatomic,strong) UIViewController *controller;

@property (nonatomic,weak)id<VerifyGesDelegate> delegate;

- (void)isSuccessGesPass:(BOOL)able; 
- (void)dismiss:(UIViewController*)controller; 

@end

NS_ASSUME_NONNULL_END
