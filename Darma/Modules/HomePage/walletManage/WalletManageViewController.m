


#import "WalletManageViewController.h"

#import "WalletManagerBottomView.h"
#import "WalletManagerCell.h"

#import "CreateWalletViewController.h"
#import "RegainWalletViewController.h"

@interface WalletManageViewController ()<UITableViewDataSource,UITableViewDelegate,WalletManagerBottomViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) WalletManagerBottomView *bottomView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSString  *status;

@property(strong, nonatomic) AppwalletMobileWallet *mobileWallet;
@end

@implementation WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Wallets", nil) ;

    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WalletManagerCell.class)];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.dict = dict;
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString  *status=dict[@"status"];

    if ([status isEqualToString:@"0"]) {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *openWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Open", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openWallet:dict];
            
        }];

        UIAlertAction *rename=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Rename", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self renameWallet:dict ];
            
        }];
        UIAlertAction *delete=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Remove", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWallet:dict ];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [openWallet setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
        [rename setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
        [delete setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
        [cancelAction setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
        
            [alertC addAction:openWallet];
            [alertC addAction:rename];
            [alertC addAction:delete];
       
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}
-(void)openWallet:(NSDictionary *)dict{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Enter the password", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *openWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField=[alertC.textFields firstObject];
        NSLog(@"------%@", textField.text);
        
        NSString *walletName= dict[@"name"];
        NSString *path = [MobileWalletSDKManger path];
        NSString *file=[NSString stringWithFormat:@"/%@.db",walletName];
        NSString *fileNamePath=[path stringByAppendingString:file];
        
        _mobileWallet=[[AppwalletMobileWallet alloc] init];
        
        BOOL isopen=[_mobileWallet open_Encrypted_Wallet:fileNamePath password:textField.text];
        if (isopen) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dict[@"name"] forKey:currentWalletNameKey];
            [defaults synchronize];
            
            NSLog(@"-----------Open wallet file successfully");
            [[MobileWalletSDKManger shareInstance] closeWallet];
            [MobileWalletSDKManger shareInstance].mobileWallet=_mobileWallet;
            
            [[MobileWalletSDKManger shareInstance] Update_Wallet];

            for (int i=0;i<self.dataArray.count;i++) {
                NSMutableDictionary *old_dict=[[NSMutableDictionary alloc] initWithDictionary:self.dataArray[i]];
                NSString *old_name=old_dict[@"name"];
                NSString *old_status=old_dict[@"status"];

                if ([old_name isEqualToString:walletName]) {
                    [old_dict setValue:@"1" forKey:@"status"];
                    [old_dict setValue:fileNamePath forKey:@"fileNamePath"];
                    [self.dataArray replaceObjectAtIndex:i withObject:old_dict];
                }else{
                    if ([old_status isEqualToString:@"1"]) {
                        [old_dict setValue:@"0" forKey:@"status"];
                        [self.dataArray replaceObjectAtIndex:i withObject:old_dict];
                    }
                }
            }
            
            
            [defaults setObject:self.dataArray forKey:addressNameKey];
            [defaults synchronize];
            
            [_tableView reloadData];
           
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *error= AppwalletGetLastError();
            NSLog(@"-----------New wallet failed to open wallet file---%@",error);
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
      
    }];
    
    [ alertC  addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = BITLocalizedCapString(@"Please enter password", nil);
        textField.secureTextEntry = YES;
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [openWallet setValue:[UIColor colorWithHexString:@"#3EB7BA"] forKey:@"titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#9CA8B3"] forKey:@"titleTextColor"];
    [alertC addAction:openWallet];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];

}
-(void)renameWallet:(NSDictionary *)dict{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Rename", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *renameWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField=[alertC.textFields firstObject];
        NSLog(@"------%@", textField.text);
      
        NSString *path = [MobileWalletSDKManger path];
       
        
        NSString *walletName= dict[@"name"];
        NSString *file=[NSString stringWithFormat:@"/%@.db",walletName];
        NSString *fileNamePath_old=[path stringByAppendingString:file];
        
        NSString *wallteName=[NSString stringWithFormat:@"/%@.db",textField.text];
        NSString* fileNamePath_new = [path stringByAppendingString:wallteName];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        if ([fm moveItemAtPath:fileNamePath_old toPath:fileNamePath_new error:&error]) {
           

            for (int i=0;i<self.dataArray.count;i++) {
                NSMutableDictionary *old_dict=[[NSMutableDictionary alloc] initWithDictionary:self.dataArray[i]];
                NSString *old_name=old_dict[@"name"];
                if ([old_name isEqualToString:walletName]) {
                    
                    [old_dict setValue:textField.text forKey:@"name"];
                    [old_dict setValue:fileNamePath_new forKey:@"fileNamePath"];
                    [self.dataArray replaceObjectAtIndex:i withObject:old_dict];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:self.dataArray forKey:addressNameKey];
                    [defaults synchronize];
                    NSLog(@"Rename successful------");


                    [_tableView reloadData];
                }
            }
           
        }else{
            NSLog(@"Rename failed------%@",error);
            [SHOWProgressHUD showMessage:[NSString stringWithFormat:@"%@",BITLocalizedCapString(@"The wallet name already exists", nil)]];
        }
        
    }];
    
    [ alertC  addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = BITLocalizedCapString(@"Please enter new name", nil);
        textField.secureTextEntry = NO;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [renameWallet setValue:[UIColor colorWithHexString:@"#3EB7BA"] forKey:@"titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#9CA8B3"] forKey:@"titleTextColor"];
    [alertC addAction:renameWallet];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
-(void)deleteWallet:(NSDictionary *)dict{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Delete the wallet. Confirm?", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Delete wallet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *path = [MobileWalletSDKManger path];
        
        NSString *walletName= dict[@"name"];
        NSString *file=[NSString stringWithFormat:@"/%@.db",walletName];
        NSString *fileNamePath_old=[path stringByAppendingString:file];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *err=nil;
        if ([fm removeItemAtPath:fileNamePath_old error:&err]) {
            for (int i=0;i<self.dataArray.count;i++) {
                NSDictionary *old_dict=self.dataArray[i];
                NSString *old_name=old_dict[@"name"];
                if ([old_name isEqualToString:walletName]) {
                    [self.dataArray removeObject:old_dict];
                }
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:self.dataArray forKey:addressNameKey];
            [defaults synchronize];
            [_tableView reloadData];
        }
        else{
            [SHOWProgressHUD showMessage:[NSString stringWithFormat:@"%@",err]];
        }
        
       
    }];
  
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [deleteWallet setValue:[UIColor colorWithHexString:@"#EC4561"] forKey:@"titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#9CA8B3"] forKey:@"titleTextColor"];
    [alertC addAction:deleteWallet];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}

-(void)createWallet{
    CreateWalletViewController *createVC=[[CreateWalletViewController alloc] init];
    [self.navigationController pushViewController:createVC animated:YES];
}
-(void)raginWallet{
    RegainWalletViewController *regainVC=[[RegainWalletViewController alloc] init];
    [self.navigationController pushViewController:regainVC animated:YES];
}
- (UITableView *)tableView{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[WalletManagerCell class] forCellReuseIdentifier:NSStringFromClass(WalletManagerCell.class)];
        _tableView.rowHeight =UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0,11, 0, 13);
        _tableView.separatorColor =[UIColor colorWithHexString:@"#D2D6DC"] ;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}
- (WalletManagerBottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[WalletManagerBottomView alloc] init];
        _bottomView.backgroundColor=[UIColor whiteColor];
        _bottomView.layer.shadowOpacity = 0.03;

        _bottomView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        UIBezierPath *path=[UIBezierPath bezierPathWithRect:CGRectMake(0,0, Width, 30)];
        _bottomView.layer.shadowPath=path.CGPath;
        _bottomView.delegate=self;
    }
    return _bottomView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
        
        NSString *path = [MobileWalletSDKManger path];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *subpaths= [fm subpathsAtPath:path];
        NSMutableArray* walletFileInfo= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:addressNameKey]];
        NSMutableArray  *resutArray=[[NSMutableArray alloc] init];
        for (int i=0;i<walletFileInfo.count;i++) {
            NSDictionary *dict=walletFileInfo[i];
            NSString *fileName=[dict[@"fileNamePath"] lastPathComponent];
           
            for (NSString  *localName in subpaths ) {
                if ([localName isEqualToString:fileName]) {
                    [resutArray addObject:dict];
                }
            }
           
        }
        _dataArray=[NSMutableArray arrayWithArray:resutArray];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:self.dataArray forKey:addressNameKey];
        [defaults synchronize];
    }
    return _dataArray;
}

@end
