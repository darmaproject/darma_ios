
#import "GesBaseViewController.h"

@protocol SetGesDelegate<NSObject>

- (void)getGesPass:(NSString *)pass;

@end

@interface SetGesViewController : GesBaseViewController

@property (nonatomic,weak)id<SetGesDelegate> delegate;

@end
