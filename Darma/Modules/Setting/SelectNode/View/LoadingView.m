



#import "LoadingView.h"

@interface LoadingView()
@property(nonatomic ,strong) UIActivityIndicatorView *activity;

@property(nonatomic ,strong) UILabel *messsageLabel;

@end

@implementation LoadingView

-(void)hideHUD{
    
    __block int timeout = 3;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); 
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ 
            
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"~~~~~~~~~~~~~~~~%d", timeout);
                self.hidden=YES;
                [self.activity stopAnimating];
                [self removeFromSuperview];
              
            });
            
            
        }
        else{
            
            timeout--;
        }
    });
    
    
    dispatch_resume(_timer);

}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.messsageLabel];
        [self addSubview:self.activity];
        [self addLayout];
    }
    return self;
}
-(void)addLayout{
  
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_activity.superview);
        make.width.height.mas_equalTo(Fit(36));
    }];
    
    [_activity startAnimating];
    
    [_messsageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_activity.mas_bottom).offset(FitH(41));
        make.centerX.equalTo(self);
    }];
}


- (UILabel *)messsageLabel
{
    if (!_messsageLabel)
    {
        _messsageLabel = [[UILabel alloc] init];
        _messsageLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        _messsageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _messsageLabel.text=BITLocalizedCapString(@"Loading", nil) ;
        _messsageLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _messsageLabel;
}
- (UIActivityIndicatorView *)activity
{
    if (!_activity)
    {
        _activity = [[UIActivityIndicatorView alloc] init];
        _activity.color=[UIColor colorWithHexString:@"#AF7EC1"];
    }
    return _activity;
}

@end
