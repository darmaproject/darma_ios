


#import <UIKit/UIKit.h>

@protocol HideTrackDelegate<NSObject>

- (void)hideTrack:(BOOL)Hide;

@end


@interface HideTrackView : UIView

@property (nonatomic,weak)id<HideTrackDelegate>  delegate;


- (void)relodGesHideTrack;


@end
