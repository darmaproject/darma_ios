


#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AddressInfo)(NSDictionary *dict);

@interface AddressListViewController : BaseViewController
@property (nonatomic, strong) AddressInfo info;
@property (nonatomic, strong)NSString * coinName;

@end

NS_ASSUME_NONNULL_END
