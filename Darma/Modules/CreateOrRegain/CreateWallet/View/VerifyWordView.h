




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VerifyWordView;
@protocol selectWordDelegate<NSObject>

- (void)wordLickView:(VerifyWordView *)view Word:(NSMutableArray *)wordsArray;

@end
@interface VerifyWordView : UIView

@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *clickWordsArray;
@property (nonatomic, assign) BOOL isVerifySucceed;

@property(nonatomic, weak) id<selectWordDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
