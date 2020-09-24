



#import "BaseViewController.h"

#import "ContentView.h"
#import "TipLable.h"
@interface GesBaseViewController : BaseViewController

@property (nonatomic,strong)ContentView *gesView;
@property (nonatomic,strong)TipLable *tipText;
@property (nonatomic,strong)NSString *passStr; 

- (void)nextRequest;

@end
