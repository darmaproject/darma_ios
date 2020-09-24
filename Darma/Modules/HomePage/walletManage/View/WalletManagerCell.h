



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletManagerCell : UITableViewCell
@property(nonatomic, strong) UIImageView *typeImage;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *addressLabel;
@property (nonatomic,strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
