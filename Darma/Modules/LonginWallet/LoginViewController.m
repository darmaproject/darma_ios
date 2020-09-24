



#import "LoginViewController.h"

#import "WalletListViewController.h"

#import "BaseTabBarController.h"
#import "BaseNavController.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic, strong) UIImageView *imageView; 
@property(nonatomic, strong)UITextField  *walletNameTF;
@property(nonatomic, strong)UIButton  *chooseWalletBtn;
@property(nonatomic, strong)UILabel  *lineLable;

@property(nonatomic, strong)UITextField  *passwordTF;
@property(nonatomic, strong)UIButton  *HidenBtn;
@property(nonatomic, strong)UILabel  *passwordLineLable;

@property(nonatomic, strong)UIButton  *loginBtn;

@property(strong, nonatomic)NSString *fileNamePath;
@property(strong, nonatomic) AppwalletMobileWallet *mobileWallet;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.hidden=YES;
    [self configUI];
}
- (void)configUI
{
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.walletNameTF];
    [self.view addSubview:self.chooseWalletBtn];
    [self.view addSubview:self.lineLable];
    
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.HidenBtn];
    [self.view addSubview:self.passwordLineLable];
    
    [self.view addSubview:self.loginBtn];

    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.143);
        make.height.mas_equalTo(FitH(64));
        make.width.mas_equalTo(FitW(190));
        
    }];
    
    [_walletNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(FitH(103));
        make.left.equalTo(self.view).offset(FitW(18));
        make.right.equalTo(self.view).offset(-FitW(54));
        make.height.mas_equalTo(FitH(39));
    }];
    [_chooseWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-FitW(18));
        make.width.height.mas_equalTo(FitW(28));
        make.centerY.equalTo(self.walletNameTF);
    }];
    
    [_lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FitW(18));
        make.right.equalTo(self.view).offset(-FitW(18));
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.walletNameTF.mas_bottom).offset(FitH(5));
    }];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLable.mas_bottom).offset(FitH(18));
        make.left.equalTo(self.view).offset(FitW(18));
        make.right.equalTo(self.view).offset(-FitW(54));
        make.height.mas_equalTo(FitH(39));
    }];
    [_HidenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-FitW(18));
        make.width.height.mas_equalTo(FitW(28));
        make.centerY.equalTo(self.passwordTF);
    }];
    
    [_passwordLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FitW(18));
        make.right.equalTo(self.view).offset(-FitW(18));
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(FitH(5));
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-27);
        make.height.mas_equalTo(48);
    }];
}

-(void)chooseWallet:(UIButton *)sender{
    WalletListViewController *chooseWallet=[[WalletListViewController alloc] init];
    chooseWallet.info = ^(NSDictionary *dict) {
        _walletNameTF.text=dict[@"name"];
        _fileNamePath=dict[@"fileNamePath"];
    };
    [self.navigationController pushViewController:chooseWallet animated:YES];
}

-(void)hiden:(UIButton *)sender{
    sender.selected=!sender.selected;
    _passwordTF.secureTextEntry = !_passwordTF.secureTextEntry;
}
-(void)login:(UIButton *)sender{

    NSString *wallteName=[NSString stringWithFormat:@"%@",_walletNameTF.text ];
    NSString *password=[NSString stringWithFormat:@"%@",_passwordTF.text];
    
    if (wallteName.length<=0) {
         [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Please enter the wallet name", nil) ];
         return;
    }
    
    if (password.length<=0) {
         [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Please enter password", nil) ];
         return;
    }
    
    
    BOOL isopen=[[MobileWalletSDKManger shareInstance] OpenWallet:wallteName password:password];
    if (isopen) {
        NSLog(@"-----------Open wallet file successfully");

        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:wallteName forKey:currentWalletNameKey];
        [defaults synchronize];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        BaseTabBarController *loginVC = [[BaseTabBarController alloc]init];
        BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:loginVC];
        [loginVC.navigationController setNavigationBarHidden:YES];
        window.rootViewController = navigationController;
        
    }else{
        NSString *error= AppwalletGetLastError();
        NSLog(@"Failed to open wallet file-----------%@",error);
        NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"Json parsing failed：%@",err);
        }
        [SHOWProgressHUD showMessage:dic[@"errMsg"]];
    }
    
   
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_walletNameTF) {

        return NO;
    }else{
          self.passwordLineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
        return YES;

    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==_walletNameTF) {
        self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    }else{
        self.passwordLineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    }
  
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_walletNameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    self.passwordLineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];

}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"logo"];
    }
    return _imageView;
}
- (UITextField *)walletNameTF
{
    if (!_walletNameTF)
    {
        _walletNameTF = [[UITextField alloc] init];
        _walletNameTF.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _walletNameTF.textColor=[UIColor colorWithHexString:@"#202640"];
        _walletNameTF.delegate=self;
        _walletNameTF.text=[[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
    }
    return _walletNameTF;
}
- (UIButton *)chooseWalletBtn
{
    if (!_chooseWalletBtn)
    {
        _chooseWalletBtn = [[UIButton alloc] init];
        [_chooseWalletBtn setImage:[UIImage imageNamed:@"jiantou_cell_setting"] forState:UIControlStateNormal];
        [_chooseWalletBtn addTarget:self action:@selector(chooseWallet:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseWalletBtn;
}

- (UILabel *)lineLable
{
    if (!_lineLable)
    {
        _lineLable = [[UILabel alloc] init];
        _lineLable.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _lineLable;
}

- (UITextField *)passwordTF
{
    if (!_passwordTF)
    {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _passwordTF.textColor=[UIColor colorWithHexString:@"#202640"];
        _passwordTF.placeholder=BITLocalizedCapString(@"Password", nil);
        _passwordTF.delegate=self;
        _passwordTF.secureTextEntry=YES;
    }
    return _passwordTF;
}
- (UIButton *)HidenBtn
{
    if (!_HidenBtn)
    {
        _HidenBtn = [[UIButton alloc] init];
        [_HidenBtn setImage:[UIImage imageNamed:@"hiden"] forState:UIControlStateNormal];
        [_HidenBtn setImage:[UIImage imageNamed:@"see"] forState:UIControlStateSelected];
        [_HidenBtn addTarget:self action:@selector(hiden:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _HidenBtn;
}
- (UILabel *)passwordLineLable
{
    if (!_passwordLineLable)
    {
        _passwordLineLable = [[UILabel alloc] init];
        _passwordLineLable.backgroundColor = [UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _passwordLineLable;
}
- (UIButton *)loginBtn
{
    if (!_loginBtn)
    {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:BITLocalizedCapString(@"Confirm", nil) forState:UIControlStateNormal];
        _loginBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        _loginBtn.layer.cornerRadius=8.0f;
        _loginBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _loginBtn.layer.borderWidth=1.0f;
        _loginBtn.layer.masksToBounds=YES;
        
        [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

@end
