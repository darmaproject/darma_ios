


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DropDownView;
@protocol SelectDelegate<NSObject>

- (void)dropDownSelectView:(DropDownView *)view clickIndex:(NSInteger)index;

@end
@interface DropDownView : UIView
@property(nonatomic, strong) UIImageView *backgroundImage;


@property (nonatomic, strong) NSMutableArray *buttonArray;
@property(nonatomic, weak) id<SelectDelegate> delegate;

@end

@interface buttonView : UIView

@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong)UIButton  *selectBtn;

@end
NS_ASSUME_NONNULL_END
