



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderView : UIView
@property(nonatomic, strong)UIView  *sendView;
@property(nonatomic, strong) UIImageView *sendImage;
@property(nonatomic, strong) UILabel *sendLabel;
@property(nonatomic, strong)UIView  *receiveView;

@property(nonatomic, strong)UIButton  *receiveBtn;
@property(nonatomic, strong)UIButton  *sendBtn;
- (void)showContentView:(NSString *)unlocked_balance Locked_balance:(NSString *)locked_balance  wallet_topo_height:(NSUInteger)wallet_topo_height Daemon_topo_height:(NSUInteger)Daemon_topo_height Wallet_online:(BOOL)Wallet_online Wallet_network:(BOOL)wallet_network;
@property(nonatomic, assign) BOOL connect;

@end

NS_ASSUME_NONNULL_END
