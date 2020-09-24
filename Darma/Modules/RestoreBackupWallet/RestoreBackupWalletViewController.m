




#import "RestoreBackupWalletViewController.h"

#import "RestoreBackupInputView.h"

#import "BaseTabBarController.h"
#import "BaseNavController.h"

#import "LoginViewController.h"

@interface RestoreBackupWalletViewController ()<UITextFieldDelegate,BaseNavigateViewDelegate>
@property(nonatomic, strong)RestoreBackupInputView *inputWalletName;
@property(nonatomic, strong)RestoreBackupInputView *inputStartHeigt;
@property(nonatomic, strong)RestoreBackupInputView *inputTime;
@property(nonatomic, strong)RestoreBackupInputView *inputBackupName;
@property(nonatomic, strong)RestoreBackupInputView *inputPassWord;

@property(nonatomic, strong)UIButton  *regainBtn;
@property(strong, nonatomic) AppwalletMobileWallet *mobileWallet;

@end

@implementation RestoreBackupWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title = BITLocalizedCapString(@"Recover from backup file", nil) ;
    [self addLayoutUI];
    

    NSString *json=AppwalletCheck_Backup_WalletFile(_fileUrl);
    if (json.length>0) {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"Json parsing failed：%@",err);
        }
       
        NSTimeInterval timeInt=[dic[@"ctime"]  doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeInt];
        NSLog(@"date:%@",[detaildate description]);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSString *str_time=[dateFormatter stringFromDate:detaildate];
        
        
        _inputWalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name", nil) ;
        _inputWalletName.textfiled.text=dic[@"name"];
        _inputStartHeigt.PromptLable.text=BITLocalizedCapString(@"Wallet topoheight", nil) ;
        _inputStartHeigt.textfiled.text=[NSString stringWithFormat:@"%@",dic[@"Height"]];
        _inputTime.PromptLable.text=BITLocalizedCapString(@"Backup time", nil) ;
        _inputTime.textfiled.text=str_time;
        
        _inputBackupName.PromptLable.text=BITLocalizedCapString(@"Backup file name", nil) ;
        NSArray *arry=[_fileUrl componentsSeparatedByString:@"/"];
        _inputBackupName.textfiled.text=[arry lastObject];
        _inputPassWord.PromptLable.text=BITLocalizedCapString(@"Password", nil) ;

        
    }else{
        NSLog(@"Backup recovery failed---------%@",AppwalletGetLastError());
    }
    
}
-(void)navigateViewClickBack:(BaseNavigateView *)view{
    LoginViewController *logVCon=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:logVCon animated:YES];

}
- (void)addLayoutUI
{
    [self.view addSubview:self.inputWalletName];
    [self.view addSubview:self.inputStartHeigt];
    [self.view addSubview:self.inputTime];
    [self.view addSubview:self.inputBackupName];
    [self.view addSubview:self.inputPassWord];
    [self.view addSubview:self.regainBtn];
    [_inputWalletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    
    [_inputStartHeigt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputWalletName.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_inputTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputStartHeigt.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_inputBackupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputTime.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_inputPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputBackupName.mas_bottom);
        make.left.right.equalTo(self.view);

        make.height.mas_greaterThanOrEqualTo(62);

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
        if([fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]){
        }
        else{
        }
    }
    NSString *wallteName=[NSString stringWithFormat:@"/%@.db",_inputWalletName.textfiled.text ];
    NSString *password=[NSString stringWithFormat:@"%@",_inputPassWord.textfiled.text];
    if (_inputWalletName.textfiled.text.length<=0) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Please enter the wallet name", nil) ];
        return;
    }else if (_inputWalletName.textfiled.text.length<3) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The wallet name should be 3 characters at least. ",nil)];
        return;
        
    }else if (_inputWalletName.textfiled.text.length>16){
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The wallet name should be 16 characters at most. ",nil)];
        return;
    }
    
    if (password.length<6) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"6 characters at least, mixed with numbers, letters in uppercase and lowercase, and special characters are suggested.", nil) ];
        return;
    }
  
    NSString *fileNamePath = [filePath stringByAppendingString:wallteName];
    
    NSInteger height=[_inputStartHeigt.textfiled.text integerValue];
    
    [[MobileWalletSDKManger shareInstance] closeWallet];
    
    BOOL restore= AppwalletRestore_WalletFile(_fileUrl, fileNamePath, password, height);

    if (restore) {
        _mobileWallet=[[AppwalletMobileWallet alloc] init];
        
        BOOL isopen=[_mobileWallet open_Encrypted_Wallet:fileNamePath password:password];
        if (isopen) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:_inputWalletName.textfiled.text forKey:currentWalletNameKey];
            [defaults synchronize];
            NSLog(@"-----------Open wallet file successfully");
            [[MobileWalletSDKManger shareInstance] closeWallet];
            
            [MobileWalletSDKManger shareInstance].mobileWallet=_mobileWallet;
            [[MobileWalletSDKManger shareInstance] Update_Wallet];
            
            NSMutableArray* dataArray=[NSMutableArray arrayWithArray:[defaults objectForKey:addressNameKey]];
            for (int i=0; i<dataArray.count; i++) {
                NSMutableDictionary *dict_old=[[NSMutableDictionary alloc] init];
                dict_old=[[NSMutableDictionary alloc] initWithDictionary:dataArray[i]];
                NSString *status_old=dict_old[@"status"];
                if ([status_old isEqualToString:@"1"]) {
                    [dict_old setValue:@"0" forKey:@"status"];
                    [dataArray replaceObjectAtIndex:i withObject:dict_old];
                }
            }
            NSString *name=_inputWalletName.textfiled.text;
            NSString *time=currentTime;
            NSString *address=[[MobileWalletSDKManger shareInstance] walletAddress];
            NSDictionary  *dic=[[NSDictionary alloc] init];
            dic=@{@"name":name,@"time":time,@"address":address,@"status":@"1",@"fileNamePath":fileNamePath};
            [dataArray addObject:dic];
            
            [defaults setObject:dataArray forKey:addressNameKey];
            [defaults setObject:name forKey:currentWalletNameKey];
            [defaults synchronize];
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            BaseTabBarController *loginVC = [[BaseTabBarController alloc]init];
            BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:loginVC];
            [loginVC.navigationController setNavigationBarHidden:YES];
            window.rootViewController = navigationController;
        }
       
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
    if (textField==_inputWalletName.textfiled) {
        _inputWalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name",nil);
        _inputWalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
        _inputWalletName.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
        _inputWalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    }else if (textField==_inputPassWord.textfiled){
        _inputPassWord.PromptLable.text=BITLocalizedCapString(@"Password",nil);
        _inputPassWord.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
        _inputPassWord.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
        _inputPassWord.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
    }
    if (textField==_inputStartHeigt.textfiled) {
        _inputStartHeigt.lineLable.backgroundColor=[UIColor colorWithHexString:@"#3EB7BA"];
        
    }
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==_inputWalletName.textfiled) {
        _inputWalletName.PromptLable.hidden=NO;
        if (_inputWalletName.textfiled.text.length<3) {
            _inputWalletName.PromptLable.text=BITLocalizedCapString(@"The wallet name should be 3 characters at least. ",nil);
            _inputWalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _inputWalletName.textfiled.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _inputWalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#EC4561"];
        }else if (_inputWalletName.textfiled.text.length>16){
            _inputWalletName.PromptLable.text=BITLocalizedCapString(@"The wallet name should be 16 characters at most. ",nil);
            _inputWalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _inputWalletName.textfiled.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _inputWalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#EC4561"];
        }else{
            
            _inputWalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name",nil);
            _inputWalletName.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
            _inputWalletName.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
            _inputWalletName.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
        }
    }
    if (textField==_inputPassWord.textfiled) {
        _inputPassWord.PromptLable.hidden=NO;
        if (_inputPassWord.textfiled.text.length<6) {
            _inputPassWord.PromptLable.text=BITLocalizedCapString(@"6 characters at least, mixed with numbers, letters in uppercase and lowercase, and special characters are suggested.",nil);
            _inputPassWord.PromptLable.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _inputPassWord.textfiled.textColor=[UIColor colorWithHexString:@"#EC4561"];
            _inputPassWord.lineLable.backgroundColor=[UIColor colorWithHexString:@"#EC4561"];
        }else{
            _inputPassWord.PromptLable.text=BITLocalizedCapString(@"Password",nil);
            _inputPassWord.PromptLable.textColor=[UIColor colorWithHexString:@"#202640"];
            _inputPassWord.textfiled.textColor=[UIColor colorWithHexString:@"#202640"];
            _inputPassWord.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
        }
        
    }
    
    if (textField==_inputStartHeigt.textfiled) {
        _inputStartHeigt.lineLable.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_inputStartHeigt.textfiled) {
        
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
        if (textField==_inputWalletName.textfiled) {
            if(aStr.length == 0){
                _inputWalletName.PromptLable.hidden=YES;
            }else{
                _inputWalletName.PromptLable.hidden=NO;
            }
        }else if (textField==_inputPassWord.textfiled) {
            if(aStr.length == 0){
                _inputPassWord.PromptLable.hidden=YES;
            }else{
                _inputPassWord.PromptLable.hidden=NO;
            }
        }
    }
    return YES;
}
- (RestoreBackupInputView *)inputWalletName
{
    if (!_inputWalletName)
    {
        _inputWalletName = [[RestoreBackupInputView alloc] init];
        _inputWalletName.textfiled.placeholder=BITLocalizedCapString(@"Wallet name", nil) ;
        _inputWalletName.textfiled.secureTextEntry=NO;
        _inputWalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name", nil);
        _inputWalletName.HidenBtn.hidden=YES;
        _inputWalletName.textfiled.delegate=self;

    }
    return _inputWalletName;
}
- (RestoreBackupInputView *)inputStartHeigt
{
    if (!_inputStartHeigt)
    {
        _inputStartHeigt = [[RestoreBackupInputView alloc] init];
        _inputStartHeigt.textfiled.placeholder=BITLocalizedCapString(@"Wallet topoheight", nil);
        _inputStartHeigt.PromptLable.text=BITLocalizedCapString(@"Wallet topoheight", nil);
        _inputStartHeigt.HidenBtn.hidden=YES;
        _inputStartHeigt.textfiled.secureTextEntry=NO;
        _inputStartHeigt.textfiled.delegate=self;
    }
    return _inputStartHeigt;
}
- (RestoreBackupInputView *)inputTime
{
    if (!_inputTime)
    {
        _inputTime = [[RestoreBackupInputView alloc] init];
        _inputTime.textfiled.placeholder=BITLocalizedCapString(@"Backup time", nil);
        _inputTime.PromptLable.text=BITLocalizedCapString(@"Backup time", nil);
        _inputTime.HidenBtn.hidden=YES;
        _inputTime.textfiled.secureTextEntry=NO;
        _inputTime.textfiled.delegate=self;
    }
    return _inputTime;
}
- (RestoreBackupInputView *)inputBackupName
{
    if (!_inputBackupName)
    {
        _inputBackupName = [[RestoreBackupInputView alloc] init];
        _inputBackupName.textfiled.placeholder=BITLocalizedCapString(@"Backup file name", nil);
        _inputBackupName.PromptLable.text=BITLocalizedCapString(@"Backup file name", nil);
        _inputBackupName.HidenBtn.hidden=YES;
        _inputBackupName.textfiled.secureTextEntry=NO;
        _inputBackupName.textfiled.delegate=self;

    }
    return _inputBackupName;
}
- (RestoreBackupInputView *)inputPassWord
{
    if (!_inputPassWord)
    {
        _inputPassWord = [[RestoreBackupInputView alloc] init];
        _inputPassWord.PromptLable.text=BITLocalizedCapString(@"Password", nil);
        _inputPassWord.PromptLable.numberOfLines=0;
        _inputPassWord.textfiled.placeholder=BITLocalizedCapString(@"Password", nil);
        _inputPassWord.textfiled.secureTextEntry=YES;
        _inputPassWord.textfiled.delegate=self;
    }
    return _inputPassWord;
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

@end
