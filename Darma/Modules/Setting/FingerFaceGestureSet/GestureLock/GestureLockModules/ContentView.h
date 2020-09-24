



#import <UIKit/UIKit.h>

#import "RectView.h"

@protocol ContentVieDelegate<NSObject>

- (void)selectedWithNum:(NSString *)str;

@end

@interface ContentView : UIView

@property (nonatomic,weak) id<ContentVieDelegate> delegate;

@end
