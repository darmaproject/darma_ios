



#import "PingNodeViewController.h"

#import "LoadingView.h"

@interface PingNodeViewController ()
@property(nonatomic, strong) UILabel *slowLabel;
@property(nonatomic, strong) UILabel *mediumLabel;
@property(nonatomic, strong) UILabel *fastLabel;
@property(nonatomic, strong) UILabel *contentInfoLabel;

@property(nonatomic, strong)UIProgressView *progressView;
@property(nonatomic, strong)LoadingView *LoadingView;

@end

@implementation PingNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title = @"Ping";
   
    [self addLayoutUI];
    NSArray *nodes=[_nodeInfo[@"node"] componentsSeparatedByString:@","];
    NSString *node;
    if (nodes.count>1) {
        
        node=[NSString stringWithFormat:@"%@",[[MobileWalletSDKManger shareInstance].mobileWallet get_Daemon_Address]];
    }else{
        node=[NSString stringWithFormat:@"%@",_nodeInfo[@"node"]];
    }
    NSString *pingInfo=AppwalletPing_Daemon_Address(node);
   
    NSData *jsonData = [pingInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    [_LoadingView hideHUD];
    int status=[[NSString stringWithFormat:@"%@",dic[@"status"]] intValue];
    if (status==1) {
        _contentInfoLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        NSString *text = [NSString stringWithFormat:@"%@%@     %@%@ms",BITLocalizedCapString(@"Height ", nil),dic[@"topo_height"],BITLocalizedCapString(@"Delay ", nil),dic[@"delay"]] ;
        _contentInfoLabel.text =text;
    }else{
        _contentInfoLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _contentInfoLabel.text =BITLocalizedCapString(@"Node is not reachable, please check your network", nil);
    }
    
    NSString * score=[NSString stringWithFormat:@"%@",dic[@"score"]];
    if ([score intValue]<50) {
        _slowLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _mediumLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _fastLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
    }else if (50<=[score intValue]&&[score intValue]<100) {
        _slowLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _mediumLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _fastLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
    }else if ([score intValue]==100){
        _slowLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _mediumLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _fastLabel.textColor = [UIColor colorWithHexString:@"#202640"];
    }
    [_progressView setProgress:[score floatValue]/100 animated:YES];
   

}

- (void)addLayoutUI
{
     [self.view addSubview:self.slowLabel];
     [self.view addSubview:self.mediumLabel];
     [self.view addSubview:self.fastLabel];
     [self.view addSubview:self.progressView];
     [self.view addSubview:self.contentInfoLabel];
     [self.view addSubview:self.LoadingView];

   
    
    [_slowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(Fit(20));
        make.left.equalTo(self.view).offset(FitW(28));
    }];
    [_mediumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_slowLabel);
        make.centerX.equalTo(self.view);
    }];
    [_fastLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_slowLabel);
        make.right.equalTo(self.view).offset(FitW(-28));
    }];
    
    [_progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_slowLabel.mas_bottom).offset(FitH(17));
        make.left.equalTo(_slowLabel.mas_left);
        make.right.equalTo(_fastLabel.mas_right);
        make.height.equalTo(@(FitH(10)));
    }];
    
    [_contentInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressView.mas_bottom).offset(FitH(39));
        make.left.equalTo(_progressView.mas_left);
        make.right.equalTo(_progressView.mas_right);
    }];
    
    [_LoadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(Fit(20));
        make.left.right.bottom.equalTo(self.view);
    }];
}


- (UILabel *)slowLabel
{
    if (!_slowLabel)
    {
        _slowLabel = [[UILabel alloc] init];
        _slowLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _slowLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _slowLabel.text=BITLocalizedCapString(@"Slow", nil) ;
    }
    return _slowLabel;
}
- (UILabel *)mediumLabel
{
    if (!_mediumLabel)
    {
        _mediumLabel = [[UILabel alloc] init];
        _mediumLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _mediumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _mediumLabel.text=BITLocalizedCapString(@"Normal", nil);
    }
    return _mediumLabel;
}
- (UILabel *)fastLabel
{
    if (!_fastLabel)
    {
        _fastLabel = [[UILabel alloc] init];
        _fastLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _fastLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _fastLabel.text=BITLocalizedCapString(@"Faster", nil);
    }
    return _fastLabel;
}
- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _progressView.progressTintColor=[UIColor colorWithHexString:@"#AF7EC1"];
        _progressView.trackTintColor=[UIColor colorWithHexString:@"#F4F4F4"];
        _progressView.layer.cornerRadius=5;
        _progressView.clipsToBounds=YES;
    }
    return _progressView;
}
- (UILabel *)contentInfoLabel
{
    if (!_contentInfoLabel)
    {
        _contentInfoLabel = [[UILabel alloc] init];
        _contentInfoLabel.textColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _contentInfoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contentInfoLabel.numberOfLines = 0;
        NSString *text = BITLocalizedCapString(@"Node is not reachable, please check your network", nil);
        _contentInfoLabel.text = text;
    }
    return _contentInfoLabel;
}
- (LoadingView *)LoadingView
{
    if (!_LoadingView)
    {
        _LoadingView = [[LoadingView alloc] init];
        _LoadingView.backgroundColor = [UIColor whiteColor];
        
    }
    return _LoadingView;
}

@end
