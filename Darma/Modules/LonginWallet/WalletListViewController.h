




#import "BaseViewController.h"

typedef void(^selectAddress)(NSDictionary * dict);


NS_ASSUME_NONNULL_BEGIN

@interface WalletListViewController : BaseViewController
@property (nonatomic, strong) selectAddress info;

@end

NS_ASSUME_NONNULL_END
