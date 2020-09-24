



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WalletManagerBottomView;
@protocol WalletManagerBottomViewDelegate<NSObject>
- (void)createWallet;
- (void)raginWallet;
@end
@interface WalletManagerBottomView : UIView
@property(nonatomic, weak) id<WalletManagerBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
