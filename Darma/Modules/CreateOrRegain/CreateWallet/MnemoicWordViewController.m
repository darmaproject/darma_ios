



#import "MnemoicWordViewController.h"

#import "MnemonicWordPrompView.h"
#import "WordClickListView.h"
#import "VerifyWordViewController.h"

@interface MnemoicWordViewController ()<BaseNavigateViewDelegate>
@property(nonatomic ,strong) UIView *headPromptView;
@property(nonatomic ,strong) UILabel *PromptLable;
@property(nonatomic ,strong) UILabel *PromptLableTwo;
@property(nonatomic ,strong) UILabel *PromptLableThree;

@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) UIImageView *imageViewTwo;
@property(nonatomic ,strong) UIImageView *imageViewThree;
@property(nonatomic ,strong) UILabel *titleLable;

@property(nonatomic ,strong) WordClickListView *wordView;

@property(nonatomic, strong)UIButton  *saveBtn;

@property(strong, nonatomic) AppwalletMobileWallet *mobileWallet;

@end

@implementation MnemoicWordViewController
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([_isClass isEqualToString:@"SettingViewController"]) {
         self.navigateView.title =BITLocalizedCapString(@"Show seed", nil) ;
    }else{
        self.navigateView.title = BITLocalizedCapString(@"Create Wallet", nil);
    }
    self.navigateView.backgroundImage.hidden=YES;

    [self configRightButton];

    [self addLayoutUI];
    
    NSString *Seeds=[self.mobileWallet get_Seeds:_password];
    if (Seeds) {
        NSArray *arry=[Seeds componentsSeparatedByString:@" "];
        
        _wordView.markArray=arry;
    }else{
        NSString *error= AppwalletGetLastError();
        NSLog(@"Failed to obtain the private key-----------%@",error);
        NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        [SHOWProgressHUD showMessage:dic[@"errMsg"]];
    }
   
}
-(void)navigateViewClickBack:(BaseNavigateView *)view{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)configRightButton
{
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn addTarget:self action:@selector(copyBtn) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn setImage:[UIImage imageNamed:@"nav_copy"] forState:UIControlStateNormal];
    
    [copyBtn sizeToFit];
    [self.navigateView.contentView addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.right.equalTo(self.navigateView.contentView).offset(-10);
    }];
}
-(void)copyBtn
{
    NSString *Seeds=[self.mobileWallet get_Seeds:_password];

    if (Seeds.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = Seeds;
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Copied", nil)  message:BITLocalizedCapString(@"Please put your wallet in safe location. Do not store it in clear text or send it via internet, or else you lose your wallet.", nil)  preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"OK" , nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [cancelAction setValue:[UIColor colorWithHexString:@"#3EB7BA"] forKey:@"titleTextColor"];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
}

-(void)userDidTakeScreenshot:(NSNotification *)notification {
      [MnemonicWordPrompView showPrompView];
}

- (void)addLayoutUI
{
    [self.headPromptView addSubview:self.PromptLable];
    [self.headPromptView addSubview:self.PromptLableTwo];
    [self.headPromptView addSubview:self.PromptLableThree];
    [self.headPromptView addSubview:self.imageView];
    [self.headPromptView addSubview:self.imageViewTwo];
    [self.headPromptView addSubview:self.imageViewThree];
    [self.view addSubview:self.headPromptView];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.wordView];
    [self.view addSubview:self.saveBtn];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPromptView).offset(17);
        make.left.equalTo(self.headPromptView).offset(6);
        make.width.height.mas_equalTo(7);
    }];
    [_PromptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPromptView).offset(12);
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.equalTo(self.headPromptView).offset(-32);
    }];
    
    [_imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PromptLable.mas_bottom).offset(12);
        make.left.equalTo(self.headPromptView).offset(6);
        make.width.height.mas_equalTo(7);
    }];
    
    [_PromptLableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PromptLable.mas_bottom).offset(7);
        make.left.equalTo(self.imageViewTwo.mas_right).offset(5);
        make.right.equalTo(self.headPromptView).offset(-32);
    }];
    
    [_imageViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PromptLableTwo.mas_bottom).offset(12);
        make.left.equalTo(self.headPromptView).offset(6);
        make.width.height.mas_equalTo(7);
    }];
    
    [_PromptLableThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PromptLableTwo.mas_bottom).offset(7);
        make.left.equalTo(self.imageViewThree.mas_right).offset(5);
        make.right.equalTo(self.headPromptView).offset(-32);
        make.bottom.equalTo(self.headPromptView).offset(-13);
    }];
    
    [_headPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(-20);
        make.left.right.equalTo(self.view);
        
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPromptView.mas_bottom).offset(28);
        make.left.right.equalTo(self.view);
    }];
    [_wordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-88);
        make.height.mas_equalTo(48);
    }];
    
    if ([_isClass isEqualToString:@"SettingViewController"]) {
        _saveBtn.hidden=YES;
    }else{
        _saveBtn.hidden=NO;
    }
}

-(void)save:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected) {
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#BCE6E7"]];
    }else{
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
    }
    
    VerifyWordViewController *conVC=[[VerifyWordViewController alloc] init];
    NSString *Seeds=[self.mobileWallet get_Seeds:_password];
    NSMutableArray *seedArry= [[NSMutableArray alloc] initWithArray:[Seeds componentsSeparatedByString:@" "]];
    conVC.seedArray=seedArry;
    [self.navigationController pushViewController:conVC animated:YES];
}


- (UIView *)headPromptView
{
    if (!_headPromptView)
    {
        _headPromptView = [[UIView alloc] init];
        _headPromptView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
    }
    return _headPromptView;
}
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"dian"];
    }
    return _imageView;
}
- (UIImageView *)imageViewTwo
{
    if (!_imageViewTwo)
    {
        _imageViewTwo = [[UIImageView alloc] init];
        _imageViewTwo.image = [UIImage imageNamed:@"dian"];
    }
    return _imageViewTwo;
}
- (UIImageView *)imageViewThree
{
    if (!_imageViewThree)
    {
        _imageViewThree = [[UIImageView alloc] init];
        _imageViewThree.image = [UIImage imageNamed:@"dian"];
    }
    return _imageViewThree;
}
- (UILabel *)PromptLable
{
    if (!_PromptLable)
    {
        _PromptLable = [[UILabel alloc] init];
        _PromptLable.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
        _PromptLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _PromptLable.text=BITLocalizedCapString(@"Your wallet can be recovered using the below seed.",nil);
        _PromptLable.numberOfLines=0;
        _PromptLable.textAlignment=NSTextAlignmentLeft;
    }
    return _PromptLable;
}
- (UILabel *)PromptLableTwo
{
    if (!_PromptLableTwo)
    {
        _PromptLableTwo = [[UILabel alloc] init];
        _PromptLableTwo.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
        _PromptLableTwo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _PromptLableTwo.text=BITLocalizedCapString(@"You must save the SEED in a safe secure location.Sharing your SEED is equal to sharing your wallet.",nil);
        _PromptLableTwo.numberOfLines=0;
        _PromptLableTwo.textAlignment=NSTextAlignmentLeft;
    }
    return _PromptLableTwo;
}
- (UILabel *)PromptLableThree
{
    if (!_PromptLableThree)
    {
        _PromptLableThree = [[UILabel alloc] init];
        _PromptLableThree.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
        _PromptLableThree.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _PromptLableThree.text=BITLocalizedCapString(@"If your SEED is lost, consider your wallet as lost.",nil);
        _PromptLableThree.numberOfLines=0;
        _PromptLableThree.textAlignment=NSTextAlignmentLeft;
    }
    return _PromptLableThree;
}

- (UILabel *)titleLable
{
    if (!_titleLable)
    {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLable.text=BITLocalizedCapString(@"Please copy your SEED words",nil);
        _titleLable.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLable;
}

-(WordClickListView *)wordView{
    if (!_wordView)
    {
        _wordView = [[WordClickListView alloc] init];
        _wordView.backgroundColor=[UIColor whiteColor];

    }
    return _wordView;
}
- (UIButton *)saveBtn
{
    if (!_saveBtn)
    {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitle:BITLocalizedCapString(@"I have copy and save my SEED words.",nil) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_saveBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        _saveBtn.layer.cornerRadius=8.0f;
        _saveBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _saveBtn.layer.borderWidth=1.0f;
        _saveBtn.layer.masksToBounds=YES;
        [_saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
-(AppwalletMobileWallet *)mobileWallet{
    if (!_mobileWallet) {
        _mobileWallet=[[AppwalletMobileWallet alloc] init];
        _mobileWallet=[MobileWalletSDKManger shareInstance].mobileWallet;

    }
    return _mobileWallet;
}
@end
