



#import "CALayer+anim.h"

@implementation CALayer (anim)

- (void)shake{

    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anima.duration = 0.3f;
    anima.removedOnCompletion = YES;
    anima.repeatCount = 2;
    CGFloat s = 3;
    anima.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    [self addAnimation:anima forKey:@"shake"];
}

@end
