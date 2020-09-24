


#import "CreateWalletViewController.h"

#import "CreateWalletInputView.h"
#import "MnemoicWordViewController.h"

@interface CreateWalletViewController ()<UITextFieldDelegate>
@property(nonatomic ,strong) UIView *headPromptView;
@property(nonatomic ,strong) UILabel *PromptLable;
@property(nonatomic ,strong) UILabel *PromptLableTwo;
@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) UIImageView *imageViewTwo;
@property(nonatomic, strong)UIButton  *createBtn;
@property(nonatomic, strong)CreateWalletInputView *WalletName;
@property(nonatomic, strong)CreateWalletInputView *passWord;
@property(nonatomic, strong)CreateWalletInputView *verifyPassWord;

@property(strong, nonatomic) AppwalletMobileWallet *mobileWallet;
@property(strong, nonatomic)NSString *fileNamePath;

@end

@implementation CreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Create Wallet", nil) ;
    self.navigateView.backgroundImage.hidden=YES;
    [self addLayoutUI];
  
}

- (void)addLayoutUI
{
    [self.headPromptView addSubview:self.PromptLable];
    [self.headPromptView addSubview:self.PromptLableTwo];
    [self.headPromptView addSubview:self.imageView];
    [self.headPromptView addSubview:self.imageViewTwo];
    [self.view addSubview:self.headPromptView];
    [self.view addSubview:self.WalletName];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.verifyPassWord];
    [self.view addSubview:self.createBtn];

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
        make.bottom.equalTo(self.headPromptView).offset(-13);
    }];
   
  
    [_headPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(-20);
        make.left.right.equalTo(self.view);

    }];
    
    
    [_WalletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPromptView.mas_bottom).offset(19);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    
    [_passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.WalletName.mas_bottom);
        make.left.right.equalTo(self.view);

        make.height.mas_greaterThanOrEqualTo(62);
    }];
    [_verifyPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWord.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.verifyPassWord.mas_bottom).offset(61);
        make.height.mas_equalTo(48);
    }];
}
-(void)create:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected) {
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#BCE6E7"]];
    }else{
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
    }
    [self creat_Wallet];
    
}

- (void)creat_Wallet{
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
    NSString *wallteName=[NSString stringWithFormat:@"/%@.db",_WalletName.textfiled.text ];
    NSString *password=[NSString stringWithFormat:@"%@",_verifyPassWord.textfiled.text];
    if (_WalletName.textfiled.text.length<3) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The wallet name should be 3 characters at least. ",nil)];
        return;

    }else if (_WalletName.textfiled.text.length>16){
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The wallet name should be 16 characters at most. ",nil)];
        return;
    }
    if (_passWord.textfiled.text.length<6) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"6 characters at least, mixed with numbers, letters in uppercase and lowercase, and special characters are suggested.",nil)];
         return;
    }
    
    if (![_passWord.textfiled.text isEqualToString:password]) {
         [SHOWProgressHUD showMessage:BITLocalizedCapString(@"The password entered twice is inconformity.",nil)];
         return;
    }
    _fileNamePath = [filePath stringByAppendingString:wallteName];
    
    
        
        
        
        
        
        
        
        
        
        
        _mobileWallet=[[AppwalletMobileWallet alloc] init];
        BOOL createWallet= [self.mobileWallet create_Encrypted_Wallet:_fileNamePath password:password];
        if (createWallet) {
            [[MobileWalletSDKManger shareInstance] closeWallet];
            [MobileWalletSDKManger shareInstance].mobileWallet=self.mobileWallet;
            
            NSLog(@"-----------The new wallet file was created successfully");
            NSInteger Height_Default=  [[MobileWalletSDKManger shareInstance] set_Initial_Height_Default];
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
            
            NSString *fileNamePath= _fileNamePath;
            NSString *name=_WalletName.textfiled.text;
            NSString *time=currentTime;
            NSString *address=[[MobileWalletSDKManger shareInstance] walletAddress];
            
            NSDictionary  *dic=[[NSDictionary alloc] init];
            dic=@{@"name":name,@"time":time,@"address":address,@"status":@"1",@"fileNamePath":fileNamePath,@"type":@""};
            [dataArray addObject:dic];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                [defaults setObject:dataArray forKey:addressNameKey];
                [defaults setObject:name forKey:currentWalletNameKey];
                [defaults synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    MnemoicWordViewController *conVC=[[MnemoicWordViewController alloc] init];
                    conVC.password=password;
                    conVC.wallteFile=_fileNamePath;
                    [self.navigationController pushViewController:conVC animated:YES];
                });
               
            });
         
           
        }else{
            NSString *error= AppwalletGetLastError();
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
   
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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
    return YES;
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
- (UILabel *)PromptLable
{
    if (!_PromptLable)
    {
        _PromptLable = [[UILabel alloc] init];
        _PromptLable.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
        _PromptLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _PromptLable.text=BITLocalizedCapString(@"For your assets security, please set password first. The password will be used for private key and transaction authorization.",nil);
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
        _PromptLableTwo.text=BITLocalizedCapString(@"It is a local password. DRAMA will not store it and can not be retrieved. Please keep it well.",nil);
        _PromptLableTwo.numberOfLines=0;
        _PromptLableTwo.textAlignment=NSTextAlignmentLeft;
    }
    return _PromptLableTwo;
}
- (UIButton *)createBtn
{
    if (!_createBtn)
    {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setTitle:BITLocalizedCapString(@"Create Wallet",nil) forState:UIControlStateNormal];
        _createBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_createBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        
        _createBtn.layer.cornerRadius=8.0f;
        _createBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _createBtn.layer.borderWidth=1.0f;
        _createBtn.layer.masksToBounds=YES;
        [_createBtn addTarget:self action:@selector(create:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
- (CreateWalletInputView *)WalletName
{
    if (!_WalletName)
    {
        _WalletName = [[CreateWalletInputView alloc] init];
        _WalletName.textfiled.placeholder=BITLocalizedCapString(@"Wallet name",nil);
        _WalletName.textfiled.secureTextEntry=NO;
        _WalletName.PromptLable.text=BITLocalizedCapString(@"Wallet name",nil);
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
        _passWord.textfiled.placeholder=BITLocalizedCapString(@"Password",nil);
        _passWord.PromptLable.text=BITLocalizedCapString(@"Password",nil);
        _passWord.PromptLable.numberOfLines=0;
        _passWord.textfiled.delegate=self;
        _passWord.textfiled.secureTextEntry=YES;

    }
    return _passWord;
}
- (CreateWalletInputView *)verifyPassWord
{
    if (!_verifyPassWord)
    {
        _verifyPassWord = [[CreateWalletInputView alloc] init];
        _verifyPassWord.textfiled.placeholder=BITLocalizedCapString(@"Confirm Password",nil);
        _verifyPassWord.PromptLable.text=BITLocalizedCapString(@"Confirm Password",nil);
        _verifyPassWord.textfiled.secureTextEntry=YES;

    }
    return _verifyPassWord;
}

@end
