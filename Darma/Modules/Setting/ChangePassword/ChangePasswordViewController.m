


#import "ChangePasswordViewController.h"

#import "ChangePasswordInputView.h"

@interface ChangePasswordViewController ()
@property(nonatomic, strong)ChangePasswordInputView * oldPassWord;
@property(nonatomic, strong)ChangePasswordInputView * freshPassWord;
@property(nonatomic, strong)ChangePasswordInputView * verifyPassWord;
@property(nonatomic, strong)UIButton  *sureBtn;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Change password", nil) ;
   
    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.oldPassWord];
    [self.view addSubview:self.freshPassWord];
    [self.view addSubview:self.verifyPassWord];
    [self.view addSubview:self.sureBtn];
    [_oldPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    
    [_freshPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oldPassWord.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_verifyPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_freshPassWord.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-53);
        make.height.mas_equalTo(48);
    }];
}


-(void)sureAdd:(UIButton *)sender{
    NSString *oldPassword=_oldPassWord.textfiled.text;
    NSString *password=_freshPassWord.textfiled.text;
    NSString *surePassword=_verifyPassWord.textfiled.text;

    if ([password isEqualToString:surePassword]) {
        
        [self changePassword:oldPassword NewPassword:surePassword];
        
    }else{
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The password entered twice is inconformity.", nil)];
    }
 
}
-(void)changePassword:(NSString *)oldPassword NewPassword:(NSString *)NewPassword{
    
     BOOL isCheck= [[MobileWalletSDKManger shareInstance].mobileWallet check_Password:oldPassword];
    
    if (isCheck) {
        BOOL isSure= [[MobileWalletSDKManger shareInstance].mobileWallet change_Password:NewPassword];
        if (isSure) {
            [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Password changed", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Password change failed", nil)];
        }
    }else{
         [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Password error", nil)];
    }
 
}

- (ChangePasswordInputView *)oldPassWord
{
    if (!_oldPassWord)
    {
        _oldPassWord = [[ChangePasswordInputView alloc] init];
        _oldPassWord.PromptLable.text=BITLocalizedCapString(@"Enter The Old Password", nil);
        _oldPassWord.textfiled.placeholder=BITLocalizedCapString(@"Enter The Old Password", nil);
    }
    return _oldPassWord;
}

- (ChangePasswordInputView *)freshPassWord
{
    if (!_freshPassWord)
    {
        _freshPassWord = [[ChangePasswordInputView alloc] init];
        _freshPassWord.PromptLable.text=BITLocalizedCapString(@"Enter New Password", nil);
        _freshPassWord.textfiled.placeholder=BITLocalizedCapString(@"Enter New Password", nil);
    }
    return _freshPassWord;
}
- (ChangePasswordInputView *)verifyPassWord
{
    if (!_verifyPassWord)
    {
        _verifyPassWord = [[ChangePasswordInputView alloc] init];
        _verifyPassWord.PromptLable.text=BITLocalizedCapString(@"Enter New Password Again", nil);
        _verifyPassWord.textfiled.placeholder=BITLocalizedCapString(@"Enter New Password Again", nil);
    }
    return _verifyPassWord;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn)
    {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:BITLocalizedCapString(@"Confirm", nil) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        
        _sureBtn.layer.cornerRadius=8.0f;
        _sureBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _sureBtn.layer.borderWidth=1.0f;
        _sureBtn.layer.masksToBounds=YES;
        [_sureBtn addTarget:self action:@selector(sureAdd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
