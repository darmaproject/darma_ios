



#import "SyncIntervalViewController.h"

#import "CustomSlider.h"
#import "YYText.h"

@interface SyncIntervalViewController ()
@property(nonatomic, strong) UILabel *numberLabel;

@property(nonatomic, strong) UILabel *InfoLabelA;
@property(nonatomic, strong) UILabel *InfoLabelB;

@property(nonatomic, strong)CustomSlider *slider;
@end

@implementation SyncIntervalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Sync interval", nil) ;
    
    [self addLayoutUI];
}
- (void)addLayoutUI
{
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.InfoLabelA];
    [self.view addSubview:self.InfoLabelB];
    [self.view addSubview:self.slider];

    
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(Fit(20));
        make.left.equalTo(self.view).offset(FitW(26));
        make.right.equalTo(self.view).offset(FitW(-26));
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberLabel.mas_bottom).offset(FitH(25));
        make.left.equalTo(self.view).offset(FitW(28));
        make.right.equalTo(self.view).offset(FitW(-28));
        make.height.equalTo(@(FitH(8)));
    }];
    
    [_InfoLabelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_slider.mas_bottom).offset(FitH(29));
        make.left.equalTo(self.view).offset(FitW(26));
        make.width.equalTo(self.view).multipliedBy(0.5).offset(-Fit(26));
    }];
    [_InfoLabelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_InfoLabelA);
        make.right.equalTo(self.view).offset(FitW(-26));
        make.width.equalTo(self.view).multipliedBy(0.5).offset(-Fit(26));

    }];
    
    int64_t syncNumber=[[MobileWalletSDKManger shareInstance].mobileWallet get_Delay_Sync];
    
  
    
    NSString *string=[NSString stringWithFormat:@"Sync Every %li seconds",(long)syncNumber];
    NSString *number=[NSString stringWithFormat:@"%li",(long)syncNumber];
    _numberLabel.attributedText = [self titleAttribute:string number:number];
    _slider.value=(float)syncNumber;
    
}
-(void)sliderValueChanged:(CustomSlider *)slider{
    
   
   
   
    
    NSString *string=[NSString stringWithFormat:@"Sync Every %.0f seconds",slider.value];
    NSString *number=[NSString stringWithFormat:@"%.0f",slider.value];

    _numberLabel.attributedText = [self titleAttribute:string number:number];
    
    int64_t syncNumber=[[MobileWalletSDKManger shareInstance].mobileWallet set_Delay_Sync:atoll([number UTF8String])];
    NSLog(@"Set the synchronization interval successfully-----%li",(long)syncNumber);
}


- (NSMutableAttributedString *)titleAttribute:(NSString *)string number:(NSString *)str_number
{
   
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *head = [[NSMutableAttributedString alloc] initWithString:string];
        head.yy_font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        head.yy_color = [UIColor colorWithHexString:@"#202640"];
        NSRange range = [string rangeOfString:str_number];
        
        [head addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:12],NSFontAttributeName, [UIColor colorWithHexString:@"#AF7EC1"],NSForegroundColorAttributeName,nil] range:NSMakeRange( range.location, range.length)];
        
        [title appendAttributedString:head];
        
        return title;
  
}


- (UILabel *)numberLabel
{
    if (!_numberLabel)
    {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _numberLabel.text=@"Synchronize every 14 seconds";
    }
    return _numberLabel;
}
- (UILabel *)InfoLabelA
{
    if (!_InfoLabelA)
    {
        _InfoLabelA = [[UILabel alloc] init];
        _InfoLabelA.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _InfoLabelA.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];

        _InfoLabelA.text=BITLocalizedCapString(@"High operation\nHigh network transmission",nil);
        _InfoLabelA.numberOfLines=0;
    }
    return _InfoLabelA;
}
- (UILabel *)InfoLabelB
{
    if (!_InfoLabelB)
    {
        _InfoLabelB = [[UILabel alloc] init];
        _InfoLabelB.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _InfoLabelB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];

        _InfoLabelB.text=BITLocalizedCapString(@"Low operation\nLow network transmission",nil);
        _InfoLabelB.numberOfLines=0;
        _InfoLabelB.textAlignment=NSTextAlignmentRight;

    }
    return _InfoLabelB;
}
- (CustomSlider *)slider
{
    if (!_slider)
    {
        _slider = [[CustomSlider alloc]init];
        _slider.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _slider.layer.cornerRadius=4;
        _slider.layer.masksToBounds=YES;
        _slider.minimumValue=5;
        _slider.maximumValue=300;
        _slider.continuous = NO;
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#AF7EC1"]; 
        _slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#F4F4F4"]; 
        [_slider setThumbImage:[UIImage imageNamed:@"huadong_setting_button"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    }
    return _slider;
}

@end
