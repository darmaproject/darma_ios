



#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^addNode)(void);

@interface AddNodeViewController : BaseViewController
@property (nonatomic ,strong)NSString *isState;
@property (nonatomic ,strong)NSDictionary *nodeInfo;
@property (nonatomic, strong) addNode addNodeBlock;

@end

NS_ASSUME_NONNULL_END
