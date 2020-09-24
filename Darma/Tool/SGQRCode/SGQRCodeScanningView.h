




#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    CornerLoactionDefault,
    
    CornerLoactionInside,
    
    CornerLoactionOutside,
} CornerLoaction;

typedef enum : NSUInteger {
    
    ScanningAnimationStyleDefault,
    
    ScanningAnimationStyleGrid,
} ScanningAnimationStyle;

@interface SGQRCodeScanningView : UIView

@property (nonatomic, assign) ScanningAnimationStyle scanningAnimationStyle;

@property (nonatomic, copy) NSString *scanningImageName;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CornerLoaction cornerLocation;

@property (nonatomic, strong) UIColor *cornerColor;

@property (nonatomic, assign) CGFloat cornerWidth;

@property (nonatomic, assign) CGFloat backgroundAlpha;

@property (nonatomic, assign) NSTimeInterval animationTimeInterval;


- (void)addTimer;

- (void)removeTimer;


@end
