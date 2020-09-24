

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol textViewEditDelegate <NSObject>

@optional
- (void) onTextViewLineCountChangeTo:(NSInteger)lines;

@end
@interface InputAutoChangeHeightView : UIView<UITextViewDelegate>
@property(nonatomic ,strong) UILabel *PromptLable;
@property(nonatomic ,strong) UILabel *lineLable;

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, weak) id<textViewEditDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
