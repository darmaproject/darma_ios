



#import "SettingViewController.h"

#import "SettingCell.h"
#import "SettingListManager.h"
#import "SettingModel.h"


#import "NodeViewController.h"
#import "SyncIntervalViewController.h"
#import "ChangePasswordViewController.h"
#import "InitialHightSyncViewController.h"
#import "MnemoicWordViewController.h"
#import "PrivateKeysViewController.h"
#import "AgreementViewController.h"

#import <CloudKit/CloudKit.h>

#import "CustomActionView.h"

#import "ChooseTypeViewController.h"

#import "LoginViewController.h"

#import "LanguageSelectViewController.h"

#import "FingerFaceGestureSetViewCon.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SettingListManager *dataManager;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
    _dataManager = [[SettingListManager alloc] init];
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Settings", nil) ;
    self.navigateView.backButton.hidden=YES;
    
    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
 
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataManager.item.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataManager.item[section];

    return array.count;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    
    if (section==self.dataManager.item.count-1) {
        UIView *lastView = [UIView new];
        lastView.backgroundColor = [UIColor whiteColor];
        lastView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FitH(150.0f));
        
        UILabel *lineLable = [[UILabel alloc] init];
        lineLable.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [lastView addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(lastView);
            make.height.equalTo(@(FitH(10)));
        }];
        
        UIButton *exitBtn=[[UIButton alloc] init];
        [exitBtn setTitle:BITLocalizedCapString(@"Delete wallet", nil) forState:UIControlStateNormal];
        [exitBtn setTitleColor:[UIColor colorWithHexString:@"#AF7EC1"] forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(deleteWallet:) forControlEvents:UIControlEventTouchUpInside];
        [lastView addSubview:exitBtn];
        [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineLable.mas_bottom);
            make.left.right.equalTo(lastView);
            make.height.equalTo(@(FitH(50)));
        }];
        UILabel *lineLableB = [[UILabel alloc] init];
        lineLableB.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [lastView addSubview:lineLableB];
        [lineLableB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(exitBtn.mas_bottom);
            make.left.right.equalTo(lastView);
            make.height.equalTo(@(FitH(10)));
        }];
        
        UILabel *urlLabel=[[UILabel alloc] initWithFrame:CGRectMake(FitW(18),FitH(80), lastView.width-FitW(18*2), FitH(20))];
        urlLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        urlLabel.font = [UIFont systemFontOfSize:12];
        urlLabel.text=[NSString stringWithFormat:@"%@%@",BITLocalizedCapString(@"Website：", nil),@"www.darmacash.com"];
        [lastView addSubview:urlLabel];
        
        UILabel *versionLabel=[[UILabel alloc] initWithFrame:CGRectMake(FitW(18),FitH(100), lastView.width-FitW(18*2), FitH(20))];
        versionLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        versionLabel.font = [UIFont systemFontOfSize:12];
        versionLabel.text=[NSString stringWithFormat:@"%@%@",BITLocalizedCapString(@"Version", nil),@"1.0.0"];
        [lastView addSubview:versionLabel];
        
        return lastView;
    }else{
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10.0f);
        return view;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.dataManager.item.count-1) {
        return FitH(150.0f);
    }else{
        return FitH(10.0f);
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SettingCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray *array = self.dataManager.item[indexPath.section];
    if (indexPath.row==array.count-1) {
        cell.bottomLine.hidden=YES;
    }else{
         cell.bottomLine.hidden=NO;
    };
    SettingModel *model = array[indexPath.row];
    cell.model = model;

    
    [cell.isSwitch addTarget:self action:@selector(BAutomaticBackup:) forControlEvents:UIControlEventValueChanged];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.dataManager.item[indexPath.section];
    SettingModel *model = array[indexPath.row];
    UIViewController *controller = [NSClassFromString(model.pushClass) new];
    if ([controller isKindOfClass:[UIViewController class]])
    {
        if ([controller isKindOfClass:[MnemoicWordViewController class]])
        {
            CustomActionView *actionV = [[CustomActionView alloc] init];
            actionV.frame = CGRectMake(0, 0, Width, Height);
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:actionV];
            
            actionV.title=BITLocalizedCapString(@"Enter the password",nil);
            actionV.placeholder=BITLocalizedCapString(@"Please enter password",nil);
            actionV.determineBlock = ^(NSString * _Nonnull string) {
                NSString *password=[NSString stringWithFormat:@"%@",string];
                NSString *Seeds=[[MobileWalletSDKManger shareInstance].mobileWallet get_Seeds:password];
                if (Seeds.length<=0) {
                    NSString *error= AppwalletGetLastError();
                    NSLog(@"Failed to open wallet file-----------%@",error);
                    NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    
                    [SHOWProgressHUD showMessage:dic[@"errMsg"]];
                }else{
                    


                        MnemoicWordViewController *cont = (MnemoicWordViewController *)controller;
                        cont.isClass=@"SettingViewController";
                        cont.password=password;
                        controller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:controller animated:YES];


                
                }
            };
        
        }else if ([controller isKindOfClass:[PrivateKeysViewController class]]){
            CustomActionView *actionV = [[CustomActionView alloc] init];
            actionV.frame = CGRectMake(0, 0, Width, Height);
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:actionV];
            
            actionV.title=BITLocalizedCapString(@"Enter the password",nil);
            actionV.placeholder=BITLocalizedCapString(@"Please enter password",nil);
            actionV.determineBlock = ^(NSString * _Nonnull string) {
                NSString *password=[NSString stringWithFormat:@"%@",string];
                
                NSString *prvateKeys=[[MobileWalletSDKManger shareInstance].mobileWallet get_Keys:password];
                if (prvateKeys.length<=0) {
                    NSString *error= AppwalletGetLastError();
                    NSLog(@"Failed to open wallet file-----------%@",error);
                    NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    
                    [SHOWProgressHUD showMessage:dic[@"errMsg"]];
                }else{
                    PrivateKeysViewController *cont = (PrivateKeysViewController *)controller;
                    cont.password=password;
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            };
            
        }else {
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
       
    }
    if ([model.titleName isEqualToString:BITLocalizedCapString(@"Backup Wallet", nil)])
    {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Enter the password",nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *openWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField=[alertC.textFields firstObject];
            NSLog(@"------%@", textField.text);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *filePath =[NSString stringWithFormat:@"%@/DarmaWalletBackup",paths[0]];
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:filePath]) {
                
                NSLog(@"This user directory file exists");
                
            } else{
                
                NSError *error=nil;
                if([fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]){
                    NSLog(@"The backup wallet directory was created successfully");
                }
                else{
                    NSLog(@"Backup wallet directory creation failed，reason is %@",error);
                }
            }
            NSString *password=[NSString stringWithFormat:@"%@",textField.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *backWalletInfo=[[MobileWalletSDKManger shareInstance].mobileWallet backup_WalletFile:filePath password:password];

                if (backWalletInfo.length<=0) {
                    NSString *error= AppwalletGetLastError();
                    NSLog(@"Failed to backup wallet file-----------%@",error);
                    NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    
                    [SHOWProgressHUD showMessage:dic[@"errMsg"]];
                }else{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:filePath forKey:backupWalletPath];
                    [defaults synchronize];
                    
                    NSURL *fileurl=[NSURL fileURLWithPath:backWalletInfo];
                    NSArray *activityItems = @[fileurl];
                    
                    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
                    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop];
                    [self presentViewController:activityVC animated:YES completion:nil];
                    
                    UIActivityViewControllerCompletionWithItemsHandler completionHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
                        if (completed)
                        {
                            NSError *err=nil;
                            if ([fm removeItemAtPath:backWalletInfo error:&err]) {
                                NSLog(@"Share completed file deleted successfully，reason is %@",err);
                            }
                            else{
                                NSLog(@"File failed after sharing completed，reason is %@",err);
                            }
                        }
                    };
                    activityVC.completionWithItemsHandler = completionHandler;
                }
            });
        }];
        
        [ alertC  addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = BITLocalizedCapString(@"Please enter password",nil);
            textField.secureTextEntry = YES;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [openWallet setValue:[UIColor colorWithHexString:@"#3EB7BA"] forKey:@"titleTextColor"];
        [cancelAction setValue:[UIColor colorWithHexString:@"#9CA8B3"] forKey:@"titleTextColor"];
        [alertC addAction:openWallet];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
       
    }else if ([model.titleName isEqualToString:BITLocalizedCapString(@"Backup now to iCloud", nil)])
    {
        

       
      
        
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Enter the password",nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *openWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField=[alertC.textFields firstObject];
            NSLog(@"------%@", textField.text);
    
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *filePath =[NSString stringWithFormat:@"%@/DarmaWalletBackup",paths[0]];
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:filePath]) {
            } else{
                NSError *error=nil;
                if([fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]){
                    NSLog(@"The backup wallet directory was created successfully");
                }
                else{
                    NSLog(@"Backup wallet directory creation failed，reason is %@",error);
                }
            }
           
            NSString *password=[NSString stringWithFormat:@"%@",textField.text];
            
            NSString *LocklWalletInfo=[[MobileWalletSDKManger shareInstance].mobileWallet backup_WalletFile:filePath password:password];
            if (LocklWalletInfo.length<=0) {
                NSString *error= AppwalletGetLastError();
                NSLog(@"Failed to backup wallet file-----------%@",error);
                NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];

                [SHOWProgressHUD showMessage:dic[@"errMsg"]];
            }else{
               
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^(void){
                    NSFileManager * fileManager = [NSFileManager defaultManager];
                    id currentiCloudToken = fileManager.ubiquityIdentityToken;
                    NSLog(@"iCloud token：%@",currentiCloudToken);
                    if(currentiCloudToken) {

                        NSURL *ubiquityURL= [fileManager URLForUbiquityContainerIdentifier:@"iCloud.com.Darma"];
                        ubiquityURL=[ubiquityURL URLByAppendingPathComponent:@"Documents"];
                        ubiquityURL=[ubiquityURL URLByAppendingPathComponent:@"iCloud_DARMA"];

                        if ([fileManager fileExistsAtPath:[ubiquityURL path]] == NO)
                        {
                            NSLog(@"iCloud Documents directory does not exist");
                            [fileManager createDirectoryAtURL:ubiquityURL withIntermediateDirectories:YES attributes:nil error:nil];
                        } else {
                            NSLog(@"iCloud Documents directory exists");
                        }
                        
                        NSString *fileName=[LocklWalletInfo lastPathComponent];
                        NSURL *iCloudUrl = [ubiquityURL URLByAppendingPathComponent:fileName];
                     
                        NSURL *localURL = [NSURL fileURLWithPath:filePath];
                        localURL=[localURL URLByAppendingPathComponent:fileName];
                        
                        NSString *localFilePath =[NSString stringWithFormat:@"%@/%@",filePath,fileName];
                        NSData *localFileData = [NSData dataWithContentsOfFile:localFilePath];
                        if([fileManager isUbiquitousItemAtURL:iCloudUrl]){ 
                            NSError *error = nil;
                            [localFileData writeToURL:iCloudUrl options:NSDataWritingAtomic error:&error];
                            if (!error)
                            {
                                 NSLog(@"%@The backup successful---------------",error);
                            

                                
                                 [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Backup successfully",nil)];
                            }else{
                                NSLog(@"%@Backup failure---------------",error);
                                [SHOWProgressHUD showMessage:[NSString stringWithFormat:@"%@%@",BITLocalizedCapString(@"Backup failed",nil),error] ];
                            }

                        }else{
                            NSError *error = nil;

                            BOOL success = [fileManager setUbiquitous:YES itemAtURL:localURL destinationURL:iCloudUrl error:&error];


                            if (success)
                            {
                                NSLog(@"%@---------------",error);
                                [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Backup successfully",nil)];

                            }else{
                                 NSLog(@"[iCloud] Error while uploading document from local directory: %@", error);
                                [SHOWProgressHUD showMessage:[NSString stringWithFormat:@"%@%@",BITLocalizedCapString(@"Backup failed",nil),error]];
                            }

                         NSArray *directoryContent = [fileManager contentsOfDirectoryAtURL:ubiquityURL includingPropertiesForKeys:nil options:0 error:nil];
                        
                            NSLog(@"%@---------------",directoryContent);
                        }
                    }else{
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"iCloud is not available",nil) message:BITLocalizedCapString(@"Please open iCloud to keep your documents safe stored in iCloud",nil) preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                            }
                        }];
                        [ac addAction:cancelAction];
                        [ac addAction:sureAction];
                        
                        
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
                    }
               });
             }
        }];
        
        [ alertC  addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = BITLocalizedCapString(@"Please enter password",nil);
            textField.secureTextEntry = YES;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [openWallet setValue:[UIColor colorWithHexString:@"#3EB7BA"] forKey:@"titleTextColor"];
        [cancelAction setValue:[UIColor colorWithHexString:@"#9CA8B3"] forKey:@"titleTextColor"];
        [alertC addAction:openWallet];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
       
       
    }else if ([model.titleName isEqualToString:BITLocalizedCapString(@"Select Language", nil)]){
        
        LanguageSelectViewController *controller = [[LanguageSelectViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([model.titleName isEqualToString:BITLocalizedCapString(@"Finger/Face/Gesture", nil)]){
        
        FingerFaceGestureSetViewCon*controller = [[FingerFaceGestureSetViewCon alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

-(void)BAutomaticBackup:(UISwitch *)isSwitch{

    BOOL isON;
    if(isSwitch.isOn){
        isON=NO;
        
        
    }else{
        isON=YES;
    }
  
}
-(void)deleteWallet:(UIButton *)sender{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Confirm", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[MobileWalletSDKManger shareInstance] closeWallet];
        NSString *path = [MobileWalletSDKManger path];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *subpaths= [fm subpathsAtPath:path];
        NSMutableArray* walletFileInfo= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:addressNameKey]];
        for (int i=0;i<walletFileInfo.count;i++) {
            NSDictionary *dict=walletFileInfo[i];
            NSString *fileName=[dict[@"fileNamePath"] lastPathComponent];

            NSString  *status=dict[@"status"];
            if ([status isEqualToString:@"1"]) {
                for (NSString  *localName in subpaths ) {
                    if ([localName isEqualToString:fileName]) {
                        NSString *localfile=[NSString stringWithFormat:@"/%@",localName];
                        localfile=[path stringByAppendingString:localfile];
                         NSError *err=nil;
                        if ([fm removeItemAtPath:localfile error:&err]) {
                            [walletFileInfo removeObject:dict];
                            [MobileWalletSDKManger shareInstance].mobileWallet=[[AppwalletMobileWallet alloc] init];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSetGesPass"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isOnGesPass"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isOpenUnlock"];
                           
                            if (walletFileInfo.count>0) {
                                LoginViewController*LoginVC = [[LoginViewController alloc]init];
                                [LoginVC.navigationController setNavigationBarHidden:YES];
                                [self.navigationController pushViewController:LoginVC animated:YES];
                            }else{
                                ChooseTypeViewController*noWallteVC = [[ChooseTypeViewController alloc]init];
                                [noWallteVC.navigationController setNavigationBarHidden:YES];
                                [self.navigationController pushViewController:noWallteVC animated:YES];
                            }
                           
                        } else{
                            NSLog(@"File deletion failed，reason is %@",err);
                            [SHOWProgressHUD showMessage:[NSString stringWithFormat:@"%@",err]];
                        }
                    }
                }
            }
           
            
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:walletFileInfo forKey:addressNameKey];
        
        NSString *wallteName=walletFileInfo[0][@"name"];
        [defaults setObject:wallteName forKey:currentWalletNameKey];
        [defaults synchronize];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:BITLocalizedCapString(@"Confirm", nil)];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8C8B90"] range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, alertControllerStr.length)];
    [alertC setValue:alertControllerStr forKey:@"attributedTitle"];

    [deleteWallet setValue:[UIColor colorWithHexString:@"#EC4561"] forKey:@"titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    [alertC addAction:deleteWallet];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[SettingCell class] forCellReuseIdentifier:NSStringFromClass(SettingCell.class)];
        _tableView.rowHeight =UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0,18, 0, 18);
        _tableView.separatorColor =[UIColor colorWithHexString:@"#D2D6DC"] ;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}


@end
