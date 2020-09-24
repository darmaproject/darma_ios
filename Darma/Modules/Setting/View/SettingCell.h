



#import <UIKit/UIKit.h>

#import "SettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell
@property(nonatomic, strong) UISwitch *isSwitch;

@property(nonatomic, strong) UILabel *bottomLine;

@property(nonatomic, strong) SettingModel *model;
@end

NS_ASSUME_NONNULL_END
