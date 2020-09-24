

#import "RectView.h"

#import "GesManager.h"
@implementation RectView
{
    UIView *interview;
    UIView *radius;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = RECT_RADIUS;
        self.backgroundColor = [UIColor whiteColor];
        self.isSelected = NO;
        
        radius = [[UIView alloc]initWithFrame:CGRectMake(-5, -5, RECT_WEIGHT+10, RECT_WEIGHT+10)];
        radius.layer.cornerRadius = RECT_RADIUS+5;
        radius.backgroundColor = [UIColor whiteColor];
        radius.layer.borderWidth = RECT_BORDER;
        radius.layer.borderColor = [UIColor colorWithHexString:@"#E1C303"].CGColor;
        radius.hidden = YES;
        [self addSubview:radius];
        
        interview = [[UIView alloc]initWithFrame:CGRectMake(RECT_WEIGHT/4, RECT_WEIGHT/4, RECT_WEIGHT/2, RECT_WEIGHT/2)];
        interview.layer.cornerRadius = RECT_WEIGHT/4;
        interview.backgroundColor = [UIColor colorWithHexString:@"#505156"];
        [self addSubview:interview];
        
        
        
    }
    return self;
}


- (void)defauftRect{

    if (_isSelected) {
        radius.hidden = YES;
        radius.layer.borderColor = RECT_COLORDONE.CGColor;
        _isSelected = !_isSelected;
    }
}

- (void)selectRect{
   
    if (!_isSelected && ![GesManager getGesHidenOpen]) {
        radius.hidden = NO;
        radius.backgroundColor = [UIColor whiteColor];
        radius.layer.borderColor = [UIColor colorWithHexString:@"#E1C303"].CGColor;
    }
    _isSelected = !_isSelected;

}

@end
