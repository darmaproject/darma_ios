



#import "PrivateKeyRegainWalletVC.h"
#import "CreateWalletInputView.h"
#import "InputAutoChangeHeightView.h"
#import "BaseTabBarController.h"
#import "BaseNavController.h"
#import "UITextView+Placeholder.h"

@interface PrivateKeyRegainWalletVC ()<textViewEditDelegate,UITextFieldDelegate>
@property(nonatomic, strong)CreateWalletInputView *WalletName;
@property(nonatomic, strong)CreateWalletInputView *passWord;
@property(nonatomic, strong)CreateWalletInputView *verifyPassWord;
@property(nonatomic, strong)CreateWalletInputView *startHeigt;
@property(nonatomic, strong)InputAutoChangeHeightView *PrivateKey;
@property(nonatomic, strong)UIButton  *regainBtn;
@property(strong, nonatomic) AppwalletMobileWallet *mobileWallet;

@end

@implementation PrivateKeyRegainWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Recover from private keys", nil) ;
    
    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.WalletName];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.verifyPassWord];
    [self.view addSubview:self.startHeigt];
    [self.view addSubview:self.PrivateKey];
    [self.view addSubview:self.regainBtn];
    [_WalletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    
    [_passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.WalletName.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_verifyPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWord.mas_bottom);
        make.left.right.equalTo(self.view);

        make.height.mas_greaterThanOrEqualTo(62);

    }];
    [_startHeigt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyPassWord.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_PrivateKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startHeigt.mas_bottom);
        make.left.right.equalTo(self.view);

    }];
    
    [_regainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-53);
        make.height.mas_equalTo(48);
    }];
}
-(void)regain:(UIButton *)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *currentDate=[NSDate date];
    NSString *currentTime= [formatter stringFromDate:currentDate];
    

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath =[NSString stringWithFormat:@"%@/DarmaWallet",paths[0]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        
        NSLog(@"This user directory file exists");
    } else{
        
        NSError *error=nil;
        if([fm createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]){
        }
        else{
        }
    }
    NSString *wallteName=[NSString stringWithFormat:@"/%@.db",_WalletName.textfiled.text ];
    NSString *password=[NSString stringWithFormat:@"%@",_verifyPassWord.textfiled.text];
    NSString *privateKey=[NSString stringWithFormat:@"%@",_PrivateKey.textView.text];

    if (_WalletName.textfiled.text.length<3) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The wallet name should be 3 characters at least. ",nil)];
        return;
        
    }else if (_WalletName.textfiled.text.length>16){
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The wallet name should be 16 characters at most. ",nil)];
        return;
    }
    if (_passWord.textfiled.text.length<6) {
       
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"6 characters at least, mixed with numbers, letters in uppercase and lowercase, and special characters are suggested.", nil) ];
        return;
    }
    if (![_passWord.textfiled.text isEqualToString:password]) {
       
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The password entered twice is inconformity.", nil) ];

        return;
    }
    if (privateKey.length<64) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Invalid spent key",nil)];
        return;
    }
   
    NSString *fileNamePath = [filePath stringByAppendingString:wallteName];
    
    if ([fm fileExistsAtPath:fileNamePath]) {
        
       
       [SHOWProgressHUD showMessage:@"This file already exists"];
        
    }else{
        BOOL createWallet= [self.mobileWallet create_Encrypted_Wallet_SpendKey:fileNamePath password:password spendkey:privateKey];
        if (createWallet) {
            [[MobileWalletSDKManger shareInstance] closeWallet];
            [MobileWalletSDKManger shareInstance].mobileWallet=self.mobileWallet;
            
            NSLog(@"-----------The new wallet file was created successfully");
            NSInteger Height_Default=  [self.mobileWallet  set_Initial_Height:[_startHeigt.textfiled.text intValue]];
            if (Height_Default) {
                NSLog(@"Set the default height for wallet scan-----------%li",(long)Height_Default);
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray* dataArray = [NSMutableArray array];
            dataArray=[NSMutableArray arrayWithArray:[defaults objectForKey:addressNameKey]];
            for (int i=0; i<dataArray.count; i++) {
                NSMutableDictionary *dict_old=[[NSMutableDictionary alloc] init];
                dict_old=[[NSMutableDictionary alloc] initWithDictionary:dataArray[i]];
                NSString *status_old=dict_old[@"status"];
                if ([status_old isEqualToString:@"1"]) {
                    [dict_old setValue:@"0" forKey:@"status"];
                    [dataArray replaceObjectAtIndex:i withObject:dict_old];
                }
            }
            
            NSString *name=_WalletName.textfiled.text;
            NSString *time=currentTime;
            NSString *address=[[MobileWalletSDKManger shareInstance] walletAddress];
            NSDictionary  *dic=[[NSDictionary alloc] init];
            dic=@{@"name":name,@"time":time,@"address":address,@"status":@"1",@"fileNamePath":fileNamePath,@"type":@""};
            [dataArray addObject:dic];
            
            [defaults setObject:dataArray forKey:addressNameKey];
            [defaults setObject:name forKey:currentWalletNameKey];
            [defaults synchronize];
            
            [[MobileWalletSDKManger shareInstance] Update_Wallet];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            BaseTabBarController *loginVC = [[BaseTabBarController alloc]init];
            BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:loginVC];
            [loginVC.navigationController setNavigationBarHidden:YES];
            window.rootViewController = navigationController;
        }else{
            NSString *error= AppwalletGetLastError();
            NSLog(@"error--------%@",error);
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
   
   
  
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_WalletName.textfiled) {
        _WalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name",nil);
        _WalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
        _WalletName.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
        _WalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    }else if (textField==_passWord.textfiled){
        _passWord.PromptLable.text=BITLocalizedCapString(@"Password",nil);
        _passWord.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
        _passWord.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
        _passWord.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    }
    if (textField==_startHeigt.textfiled) {
        _startHeigt.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==_WalletName.textfiled) {
        _WalletName.PromptLable.hidden=NO;
        if (_WalletName.textfiled.text.length<3) {
            _WalletName.PromptLable.text=BITLocalizedCapString(@"The wallet name should be 3 characters at least. ",nil);
            _WalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _WalletName.textfiled.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _WalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#EC4561"];
        }else if (_WalletName.textfiled.text.length>16){
            _WalletName.PromptLable.text=BITLocalizedCapString(@"The wallet name should be 16 characters at most. ",nil);
            _WalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _WalletName.textfiled.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _WalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#EC4561"];
        }else{
            
            _WalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name",nil);
            _WalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
            _WalletName.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
            _WalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
        }
    }
    if (textField==_passWord.textfiled) {
        _passWord.PromptLable.hidden=NO;
        if (_passWord.textfiled.text.length<6) {
            _passWord.PromptLable.text=BITLocalizedCapString(@"6 characters at least, mixed with numbers, letters in uppercase and lowercase, and special characters are suggested.",nil);
            _passWord.PromptLable.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _passWord.textfiled.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _passWord.lineLable.backgroundColor=[UIColor colorWithHexString:@"#EC4561"];
        }else{
            _passWord.PromptLable.text=BITLocalizedCapString(@"Password",nil);
            _passWord.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
            _passWord.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
            _passWord.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
        }
        
    }
    if (textField==_startHeigt.textfiled) {
        if (_startHeigt.textfiled) {
            _startHeigt.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==_startHeigt.textfiled) {
        
        BOOL isHaveDian = YES;
        if ([string isEqualToString:@" "]){
            return NO;
        }
        
        if ([textField.text rangeOfString:@"."].location == NSNotFound){
            isHaveDian = NO;
        }
        
        if ([string length] > 0){
            
            unichar single = [string characterAtIndex:0];
            if ((single >= '0' && single <= '9') || single == '.'){
                
                if([textField.text length] == 0){
                    if(single == '.') {
                        [SHOWProgressHUD   showMessage:@"Data format error"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                
                if (single == '.'){
                    if(!isHaveDian)
                    {
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [SHOWProgressHUD   showMessage:@"Data format error"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian){
                        
                        
                        NSRange ran = [textField.text rangeOfString:@"."];
                        
                        if (range.location - ran.location <= 8){
                            return YES;
                        } else{
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{
                [SHOWProgressHUD   showMessage:@"Data format error"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }else {
        NSString * aStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField==_WalletName.textfiled) {
            if(aStr.length == 0){
                _WalletName.PromptLable.hidden=YES;
            }else{
                _WalletName.PromptLable.hidden=NO;
            }
        }else if (textField==_passWord.textfiled) {
            if(aStr.length == 0){
                _passWord.PromptLable.hidden=YES;
            }else{
                _passWord.PromptLable.hidden=NO;
            }
        }
    }
    return YES;
}

- (CreateWalletInputView *)WalletName
{
    if (!_WalletName)
    {
        _WalletName = [[CreateWalletInputView alloc] init];
        _WalletName.textfiled.placeholder=BITLocalizedCapString(@"Wallet name", nil) ;
        _WalletName.textfiled.secureTextEntry=NO;
        _WalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name", nil);
        _WalletName.PromptLable.numberOfLines=0;
        _WalletName.HidenBtn.hidden=YES;
        _WalletName.textfiled.delegate=self;
    }
    return _WalletName;
}
- (CreateWalletInputView *)passWord
{
    if (!_passWord)
    {
        _passWord = [[CreateWalletInputView alloc] init];
        _passWord.textfiled.placeholder=BITLocalizedCapString(@"Password", nil);
        _passWord.PromptLable.text=BITLocalizedCapString(@"Password", nil);
        _passWord.PromptLable.numberOfLines=0;
        _passWord.textfiled.secureTextEntry=YES;
        _passWord.textfiled.delegate=self;

    }
    return _passWord;
}
- (CreateWalletInputView *)verifyPassWord
{
    if (!_verifyPassWord)
    {
        _verifyPassWord = [[CreateWalletInputView alloc] init];
        _verifyPassWord.textfiled.placeholder=BITLocalizedCapString(@"Confirm Password", nil);
        _verifyPassWord.PromptLable.text=BITLocalizedCapString(@"Confirm Password", nil);
        _verifyPassWord.textfiled.secureTextEntry=YES;

    }
    return _verifyPassWord;
}
- (CreateWalletInputView *)startHeigt
{
    if (!_startHeigt)
    {
        _startHeigt = [[CreateWalletInputView alloc] init];
        _startHeigt.textfiled.placeholder=BITLocalizedCapString(@"Wallet start Topoheight (optional)", nil);
        _startHeigt.PromptLable.text=BITLocalizedCapString(@"Wallet start Topoheight (optional)", nil);
        _startHeigt.HidenBtn.hidden=YES;
        _startHeigt.textfiled.delegate=self;
    }
    return _startHeigt;
}
- (InputAutoChangeHeightView *)PrivateKey
{
    if (!_PrivateKey)
    {
        _PrivateKey = [[InputAutoChangeHeightView alloc] init];
        _PrivateKey.PromptLable.text=BITLocalizedCapString(@"Spend private key (64 hex characters)", nil);
        _PrivateKey.textView.placeholderLabel.text=BITLocalizedCapString(@"Spend private key (64 hex characters)", nil);
        
    }
    return _PrivateKey;
}
- (UIButton *)regainBtn
{
    if (!_regainBtn)
    {
        _regainBtn = [[UIButton alloc] init];
        [_regainBtn setTitle:BITLocalizedCapString(@"Recover Wallet", nil) forState:UIControlStateNormal];
        _regainBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_regainBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_regainBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        
        _regainBtn.layer.cornerRadius=8.0f;
        _regainBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _regainBtn.layer.borderWidth=1.0f;
        _regainBtn.layer.masksToBounds=YES;
        [_regainBtn addTarget:self action:@selector(regain:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _regainBtn;
}

-(AppwalletMobileWallet *)mobileWallet{
    if (!_mobileWallet) {
        _mobileWallet=[[AppwalletMobileWallet alloc] init];
    }

    return _mobileWallet;
}

@end
