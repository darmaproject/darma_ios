

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cancel)(void);

@interface CunstomMessageView : UIView
-(void)show;
+ (void)showCustomViewTitle:(NSString *)title message:(NSString *)message isHaveCopy:(BOOL)isHaveCopy cancelClick:(cancel)cancel;

@property(nonatomic, strong) cancel cancelBlock;
@property(nonatomic, strong) NSString *str_message;


@end

NS_ASSUME_NONNULL_END
