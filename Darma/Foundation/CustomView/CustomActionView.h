

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^cancel)(void);
typedef void(^determine)(NSString *string);

@interface CustomActionView : UIView
-(void)show;
@property(nonatomic, strong) cancel cancelBlock;
@property(nonatomic, strong) determine determineBlock;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *placeholder;


@end

NS_ASSUME_NONNULL_END
