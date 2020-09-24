


#import "MnemonicWordPrompView.h"

@interface MnemonicWordPrompView()
@property(nonatomic, strong) UIView *ContentView;

@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) UILabel *titleLable;
@property(nonatomic ,strong) UILabel *infoLable;
@property(nonatomic, strong)UIButton  *deterBtn;

@end
@implementation MnemonicWordPrompView
+ (void)showPrompView
{
    MnemonicWordPrompView *view = [[MnemonicWordPrompView alloc] init];
    view.frame = CGRectMake(0, 0, Width, Height);
    view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.ContentView];
        [self.ContentView addSubview:self.imageView];
        [self.ContentView addSubview:self.titleLable];
        [self.ContentView addSubview:self.infoLable];
        [self.ContentView addSubview:self.deterBtn];
        [self addLayout];
    }
    return self;
}
- (void)addLayout
{
    [_ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(Fit(-12));
        make.left.equalTo(self).offset(Fit(12));
        make.height.equalTo(@(FitH(298)));
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ContentView).offset(50);
        make.centerX.equalTo(self.ContentView);
        make.width.height.mas_equalTo(50);
    }];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(27);
        make.left.equalTo(self.ContentView).offset(25);
        make.right.equalTo(self.ContentView).offset(-25);
    }];
    [_infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(21);
        make.left.equalTo(self.ContentView).offset(25);
        make.right.equalTo(self.ContentView).offset(-25);
    }];
    
    if (KisEnglish) {
       
        [_infoLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(11);
        }];
    }else{
       
        [_infoLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(21);
        }];
    }
   
    [_deterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLable.mas_bottom).offset(17);
        make.left.equalTo(self.ContentView).offset(25);
        make.right.equalTo(self.ContentView).offset(-25);
        make.height.mas_equalTo(48);
        make.bottom.equalTo(self.ContentView).offset(-31);
    }];
}
-(void)deter:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected) {
        [_deterBtn setBackgroundColor:[UIColor colorWithHexString:@"#BCE6E7"]];
    }else{
        [_deterBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
    }
    [self removeFromSuperview];
    
    
}

-(UIView *)ContentView{
    if (!_ContentView) {
        _ContentView=[[UIView alloc] init];
        _ContentView.backgroundColor = [UIColor whiteColor];
        _ContentView.clipsToBounds = YES;
        _ContentView.layer.cornerRadius = 8;
    }
    return _ContentView;
}
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"banScreensshots"];
    }
    return _imageView;
}
- (UILabel *)titleLable
{
    if (!_titleLable)
    {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:21];
        _titleLable.text=BITLocalizedCapString(@"Backup SEED words, couldn`t captrue screenshot", nil) ;
        _titleLable.numberOfLines=2;
        _titleLable.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLable;
}
- (UILabel *)infoLable
{
    if (!_infoLable)
    {
        _infoLable = [[UILabel alloc] init];
        _infoLable.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _infoLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _infoLable.text=BITLocalizedCapString(@"Do not capture screenshot. If someone get your seed words, he is free to get your assets.", nil);
        _infoLable.numberOfLines=0;
        _infoLable.textAlignment=NSTextAlignmentCenter;
    }
    return _infoLable;
}
- (UIButton *)deterBtn
{
    if (!_deterBtn)
    {
        _deterBtn = [[UIButton alloc] init];
        [_deterBtn setTitle:BITLocalizedCapString(@"OK", nil) forState:UIControlStateNormal];
        _deterBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_deterBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_deterBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        _deterBtn.layer.cornerRadius=8.0f;
        _deterBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _deterBtn.layer.borderWidth=1.0f;
        _deterBtn.layer.masksToBounds=YES;
        [_deterBtn addTarget:self action:@selector(deter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deterBtn;
}
@end
