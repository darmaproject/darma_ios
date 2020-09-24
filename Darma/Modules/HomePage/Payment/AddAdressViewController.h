



#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^addAddress)(void);

@interface AddAdressViewController : BaseViewController
@property (nonatomic, strong) addAddress addBlock;
@property (nonatomic, strong) NSDictionary * scanInfo;
@property (nonatomic, strong)NSString * coinName;

@end

NS_ASSUME_NONNULL_END
