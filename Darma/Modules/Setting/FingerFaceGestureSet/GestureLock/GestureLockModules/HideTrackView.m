



#import "HideTrackView.h"

#import "GesManager.h"


@implementation HideTrackView
{
    UISwitch *sw;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
- (void)createUI{
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    lbl.text = @"Hidden track";
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor =[UIColor grayColor];
    
    [self addSubview:lbl];
  
    sw = [[UISwitch alloc]initWithFrame:CGRectMake(lbl.frame.size.width, 0, 100, 30)];
    [sw sizeToFit];
    sw.on = NO;
    [self addSubview:sw];
    [sw addTarget:self action:@selector(chanage) forControlEvents:UIControlEventTouchUpInside];
    
    [self sizeToFit];
    
    [self relodGesHideTrack];

}

- (void)relodGesHideTrack{
    
    
    sw.on = [GesManager getGesHidenOpen];
    
}


- (void)chanage{
    
    [GesManager setGesHidenOpen:sw.on];
    
}


@end
