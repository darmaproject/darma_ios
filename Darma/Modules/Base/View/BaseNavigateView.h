



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBack)();
@class BaseNavigateView;
@protocol BaseNavigateViewDelegate<NSObject>

@optional
- (void)navigateViewClickBack:(BaseNavigateView *)view; 
- (void)navigateViewClickTitle:(BaseNavigateView *)view;

@end
@interface BaseNavigateView : UIView
@property(nonatomic, strong) UIView *contentView; 
@property(nonatomic, strong) UIImageView *backgroundImage; 

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSString *title; 
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, copy) ClickBack back;
- (void)updateView; 
@property(nonatomic, weak)id<BaseNavigateViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
