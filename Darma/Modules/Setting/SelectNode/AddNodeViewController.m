



#import "AddNodeViewController.h"

#import "CreateWalletInputView.h"

@interface AddNodeViewController ()
@property(nonatomic, strong)CreateWalletInputView *IPAddressView;
@property(nonatomic, strong)CreateWalletInputView *portView;
@property(nonatomic, strong)CreateWalletInputView *userNameView;
@property(nonatomic, strong)CreateWalletInputView *passwordView;
@property(nonatomic, strong)CreateWalletInputView *tagView;
@property(nonatomic, strong)UIButton  *sureBtn;
@end

@implementation AddNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([_isState isEqualToString:@"Add Nodes"]) {
        self.navigateView.title =BITLocalizedCapString(@"Add Nodes", nil) ;
    }else{
        self.navigateView.title = BITLocalizedCapString(@"Edit Nodes", nil);
    }
    
    
    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.IPAddressView];
    [self.view addSubview:self.portView];
    [self.view addSubview:self.userNameView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.tagView];
    [self.view addSubview:self.sureBtn];
    [_IPAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    
    [_portView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_IPAddressView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_portView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordView.mas_bottom);
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
-(void)setNodeInfo:(NSDictionary *)nodeInfo{
    _nodeInfo=nodeInfo;
   
}


-(void)sureAdd:(UIButton *)sender{
    NSMutableArray*dataArray = [[NSMutableArray alloc] init];
    dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:nodeKey]];
    if ([_isState isEqualToString:@"Add Nodes"]) {
        NSMutableDictionary  *dic=[[NSMutableDictionary alloc] init];
        NSString *str_IP=[NSString stringWithFormat:@"%@",_IPAddressView.textfiled.text];
        if (str_IP.length>0) {
            [dic setValue:str_IP forKey:@"IP"];
        }else{
            [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Please enter IP address", nil)];
            return;
            
        }
        
        NSString *str_port=[NSString stringWithFormat:@"%@",_portView.textfiled.text];
        if (str_port.length>0) {
            if ([str_port intValue]<1||[str_port intValue]>65535) {
                 [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Invalid port value", nil)];
                return;
            }else{
                [dic setValue:str_port forKey:@"prot"];
            }
            
        }else{
              [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Invalid port value", nil)];
             return;
        }
        
        NSString *node=[NSString stringWithFormat:@"%@:%@",dic[@"IP"],dic[@"prot"]];
        [dic setValue:node forKey:@"node"];
        
        NSString *str_Name=[NSString stringWithFormat:@"%@",_userNameView.textfiled.text];
        if (str_Name.length>0) {
            [dic setValue:str_Name forKey:@"userName"];
        }else{
            [dic setValue:@"" forKey:@"userName"];
        }
        
        NSString *str_password=[NSString stringWithFormat:@"%@",_passwordView.textfiled.text];
        if (str_password.length>0) {
            [dic setValue:str_password forKey:@"password"];
        }else{
            [dic setValue:@"" forKey:@"password"];
        }
        
        NSString *str_tag=[NSString stringWithFormat:@"%@",_tagView.textfiled.text];
        if (str_tag.length>0) {
            [dic setValue:str_tag forKey:@"tip"];
        }else{
            [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Pleasen enter a tag", nil)];
            return;
        }
        [dic setValue:@0 forKey:@"isDefault"];
        [dic setValue:@0 forKey:@"isSelect"];
        for (NSDictionary * dict in dataArray) {
            if ([dict[@"node"] isEqualToString:node] ) {
                [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Existed node", nil)];
                return;
            }
        }
        
        [dataArray addObject:dic];
    }else{
       
        for (int i=0; i<dataArray.count; i++) {
            NSMutableDictionary  *dic=[[NSMutableDictionary alloc] initWithDictionary:dataArray[i]];
            if ([_nodeInfo[@"node"] isEqualToString:dic[@"node"]]) {
                
                if (_IPAddressView.textfiled.text.length>0) {
                     [dic setValue:_IPAddressView.textfiled.text forKey:@"IP"];
                }
              
                if (_portView.textfiled.text.length>0) {
                    if ([_portView.textfiled.text intValue]<1||[_portView.textfiled.text intValue]>65535) {
                        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Invalid port value", nil)];
                        return;
                    }else{
                        [dic setValue:_portView.textfiled.text forKey:@"prot"];
                    }

                }
                
                NSString *node=[NSString stringWithFormat:@"%@:%@",dic[@"IP"],dic[@"prot"]];
                [dic setValue:node forKey:@"node"];

                if (_userNameView.textfiled.text.length>0) {
                    [dic setValue:_userNameView.textfiled.text forKey:@"userName"];
                }
                
                if (_passwordView.textfiled.text.length>0) {
                    [dic setValue:_passwordView.textfiled.text forKey:@"password"];
                }
                
                if (_tagView.textfiled.text.length>0) {
                    [dic setValue:_tagView.textfiled.text forKey:@"tip"];
                }
                
                [dataArray replaceObjectAtIndex:i withObject:dic];
            }
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dataArray forKey:nodeKey];
    [defaults synchronize];
    
    self.addNodeBlock();
    [self.navigationController popViewControllerAnimated:YES];
}


- (CreateWalletInputView *)IPAddressView
{
    if (!_IPAddressView)
    {
        _IPAddressView = [[CreateWalletInputView alloc] init];
        _IPAddressView.textfiled.placeholder=BITLocalizedCapString(@"IP Address", nil);
        _IPAddressView.textfiled.secureTextEntry=NO;
        _IPAddressView.PromptLable.text=BITLocalizedCapString(@"IP Address", nil);
        _IPAddressView.HidenBtn.hidden=YES;
        if ([_isState isEqualToString:@"Edit Nodes"]) {
            _IPAddressView.textfiled.text=_nodeInfo[@"IP"];
        }
    }
    return _IPAddressView;
}
- (CreateWalletInputView *)portView
{
    if (!_portView)
    {
        _portView = [[CreateWalletInputView alloc] init];
        _portView.textfiled.placeholder=BITLocalizedCapString(@"Port", nil);
        _portView.PromptLable.text=BITLocalizedCapString(@"Port", nil);
        _portView.HidenBtn.hidden=YES;
        if ([_isState isEqualToString:@"Edit Nodes"]) {
            _portView.textfiled.text=_nodeInfo[@"prot"];
        }
    }
    return _portView;
}
- (CreateWalletInputView *)userNameView
{
    if (!_userNameView)
    {
        _userNameView = [[CreateWalletInputView alloc] init];
        _userNameView.textfiled.placeholder=BITLocalizedCapString(@"Username(optional)", nil);
        _userNameView.PromptLable.text=BITLocalizedCapString(@"Username(optional)", nil);
        _userNameView.HidenBtn.hidden=YES;
        if ([_isState isEqualToString:@"Edit Nodes"]) {
            _userNameView.textfiled.text=_nodeInfo[@"userName"];
        }
    }
    return _userNameView;
}
- (CreateWalletInputView *)passwordView
{
    if (!_passwordView)
    {
        _passwordView = [[CreateWalletInputView alloc] init];
        _passwordView.textfiled.placeholder=BITLocalizedCapString(@"Password(optional)", nil);
        _passwordView.PromptLable.text=BITLocalizedCapString(@"Password(optional)", nil);
        _passwordView.textfiled.secureTextEntry=YES;
        if ([_isState isEqualToString:@"Edit Nodes"]) {
            _passwordView.textfiled.text=_nodeInfo[@"password"];
        }
    }
    return _passwordView;
}
- (CreateWalletInputView *)tagView
{
    if (!_tagView)
    {
        _tagView = [[CreateWalletInputView alloc] init];
        _tagView.PromptLable.text=BITLocalizedCapString(@"Label", nil);
        _tagView.textfiled.placeholder=BITLocalizedCapString(@"Label", nil);
        _tagView.HidenBtn.hidden=YES;
        if ([_isState isEqualToString:@"Edit Nodes"]) {
            _tagView.textfiled.text=_nodeInfo[@"tip"];
        }
    }
    return _tagView;
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
