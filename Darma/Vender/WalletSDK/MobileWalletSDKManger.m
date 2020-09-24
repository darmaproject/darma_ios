

NSString *const addressNameKey = @"addressNameKey";

NSString *const walletAddressKey = @"walletAddressKey";

NSString *const nodeKey = @"nodeKey";


NSString *const backupWalletPath = @"backupWalletPath";

NSString *const currentWalletNameKey = @"currentWalletNameKey";

NSString *const TradeRecordKey = @"TradeRecordKey";

@interface MobileWalletSDKManger()
@end
@implementation MobileWalletSDKManger
+(instancetype)shareInstance{
    static MobileWalletSDKManger *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mobileWallet=[[AppwalletMobileWallet alloc] init];
    }
    return self;
}
-(NSInteger)set_Initial_Height_Default{
    
    NSInteger Height_Default=  [_mobileWallet set_Initial_Height_Default];
    
    return Height_Default;
}
- (BOOL)OpenWallet:(NSString *)walletName password:(NSString*)password {
    NSString *path = [MobileWalletSDKManger path];
    NSString *file=[NSString stringWithFormat:@"/%@.db",walletName];
    NSString *fileNamePath=[path stringByAppendingString:file];

    NSMutableArray*dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:addressNameKey]];
    for (int i=0; i<dataArray.count; i++) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:dataArray[i]];
        NSString *name=dict[@"name"];
        NSString *status=dict[@"status"];

        if ([name isEqualToString:walletName]) {
            [dict setValue:@"1" forKey:@"status"];
            [dict setValue:fileNamePath forKey:@"fileNamePath"];
            [dataArray replaceObjectAtIndex:i withObject:dict];
        }else{
            if ([status isEqualToString:@"1"]) {
                [dict setValue:@"0" forKey:@"status"];
                [dataArray replaceObjectAtIndex:i withObject:dict];
            }
        }

    }
    BOOL isopen=[_mobileWallet open_Encrypted_Wallet:fileNamePath password:password];
    if (isopen) {
        NSLog(@"----------Open wallet file successfully");
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dataArray forKey:addressNameKey];
        [defaults synchronize];
               [self Update_Wallet];
        });
      
    }else{
        NSLog(@"-----------Failed to open wallet file");
    }
    return isopen;
    
}
-(void)closeWallet{
    
    BOOL  isUpdae=_mobileWallet.isSync;
    if (isUpdae) {
        [self Stop_Update];
    }
    BOOL isClose=[_mobileWallet close_Encrypted_Wallet];
    if (isClose) {
        NSLog(@"-----------Closed the open wallet successfully");
    }
}
- (void)Update_Wallet{
    NSString * str_node = [[NSString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* dataArray=[NSMutableArray arrayWithArray:[defaults objectForKey:nodeKey]];
    for (int i=0; i<dataArray.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:dataArray[i]];

        if ([dic[@"isSelect"]intValue]==1) {
            str_node=dic[@"node"];
        }
    }
    BOOL isNode=[_mobileWallet set_Daemon_Address:str_node];
    if (isNode) {
        NSLog(@"-----------Setting default node succeeded");
        BOOL isStart=[_mobileWallet update_Wallet_Balance];
        if (isStart) {
            NSLog(@"-----------Start synchronizing wallet");
            NSLog(@"-----------The wallet address%@",[self walletAddress]);
        }
    }
   
}

- (void)Stop_Update{
    BOOL isStart=[_mobileWallet stop_Update_Blance];
    if (isStart) {
        NSLog(@"-----------Stop synchronizing wallet");
    }
}

-(NSDictionary *)transfer:(NSString* _Nonnull)walletAddress amountstr:(NSString* _Nonnull)amountstr unlock_time_str:(NSString* _Nonnull)unlock_time_str payment_id:(NSString* _Nonnull)payment_id mixin:(long)mixin sendtx:(BOOL)sendtx password:(NSString* _Nonnull)password{
    NSString *json=[_mobileWallet  transfer:walletAddress amountstr:amountstr unlock_time_str:unlock_time_str payment_id:payment_id mixin:mixin sendtx:sendtx password:password];

    NSLog(@"-----------Withdraw money from your wallet%@",json);
    if (json == nil) {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"Json parsing failed：%@",err);
        return nil;
    }
    return dic;
}
-(NSDictionary *)Transfer_Everything:(NSString* _Nonnull)walletAddress unlock_time_str:(NSString* _Nullable)unlock_time_str payment_id:(NSString* _Nullable)payment_id mixin:(long)mixin password:(NSString* _Nonnull)password{
    NSString *json=[_mobileWallet transfer_Everything:walletAddress unlock_time_str:unlock_time_str payment_id_hex:payment_id mixin:mixin sendtx:NO password:password];
    NSLog(@"-----------json%@",json);
    if (json == nil) {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"Json parsing failed：%@",err);
        return nil;
    }
    return dic;
}
-(NSString *)Send_Raw_Transaction:(NSString* _Nonnull)txraw{
    NSString *text=[_mobileWallet send_Raw_Transaction:txraw];
    return text;
}
-(NSArray *)transferRecords:(BOOL)receive send:(BOOL)send max_height_str:(NSString* _Nullable)max_height_str str_number:(NSString* _Nullable)str_number{

    NSString *json=[_mobileWallet get_Transfers:receive out_:send max_height_str:max_height_str limit_str:str_number];

    NSLog(@"Transaction records json-----------------%@",json);
    if (json == nil) {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"Json parsing failed：%@",err);
        return nil;
    }

    return array;
}
-(NSString *)walletAddress{
    
    NSString *str_address=[_mobileWallet get_Wallet_Address];
    NSLog(@"-----------Get the address of the wallet %@",str_address);
    return str_address;
}
- (NSString *)Generate_Intergrated_Address:(long)length{
     NSString *str=[_mobileWallet generate_Intergrated_Address:length];
     return str;
}
-(NSDictionary *)Verify_Address:(NSString*)string{
    NSString *json=[_mobileWallet verify_Address:string];
    NSLog(@"-----------paymnetID%@",json);
    if (json == nil) {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"Json parsing failed：%@",err);
        return nil;
    }
    return dic;
    
}
-(void)saveDefaultNodeList{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray* dataArray = [NSMutableArray array];
    dataArray=[NSMutableArray arrayWithArray:[defaults objectForKey:nodeKey]];
    NSDictionary  *dic_default0=[[NSDictionary alloc] init];

    NSDictionary  *dic_default1=[[NSDictionary alloc] init];
    NSDictionary  *dic_default2=[[NSDictionary alloc] init];
    NSDictionary  *dic_default3=[[NSDictionary alloc] init];
    NSDictionary  *dic_default4=[[NSDictionary alloc] init];
    NSDictionary  *dic_default5=[[NSDictionary alloc] init];

    
    NSString *tip=[NSString stringWithFormat:@"%@",BITLocalizedCapString(@"Default node", nil)];
    NSMutableArray *nodesArray=[[NSMutableArray alloc] init];
    if (dataArray.count==0) {
         nodesArray=[[NSMutableArray alloc] initWithObjects:@"app0.darmacash.com:33804",@"app1.darmacash.com:33804",@"app2.darmacash.com:33804",@"app3.darmacash.com:33804",@"app4.darmacash.com:33804", nil];
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *dic=[[NSDictionary alloc] init];
            dic=dataArray[i];
            NSString *node=dic[@"node"];
            [nodesArray addObject:node];
        }
    }
    NSString *str_nodes=[nodesArray componentsJoinedByString:@","];
    

    
        dic_default0=@{@"IP":@"",@"prot":@"",@"userName":@"Auto",@"password":@"",@"tip":BITLocalizedCapString(@"Select the best node automatically", nil),@"nodeNum":@0,@"node":str_nodes,@"isDefault":@1,@"isSelect":@1};
    dic_default1=@{@"IP":@"app0.darmacash.com",@"prot":@"33804",@"userName":@"Default Node 1",@"password":@"",@"tip":tip,@"nodeNum":@0,@"node":@"app0.darmacash.com:33804",@"isDefault":@1,@"isSelect":@0};
    dic_default2=@{@"IP":@"app1.darmacash.com",@"prot":@"33804",@"userName":@"Default Node 2",@"password":@"",@"tip":tip,@"nodeNum":@1,@"node":@"app1.darmacash.com:33804",@"isDefault":@1,@"isSelect":@0};
    dic_default3=@{@"IP":@"app2.darmacash.com",@"prot":@"33804",@"userName":@"Default Node 3",@"password":@"",@"tip":tip,@"nodeNum":@2,@"node":@"app2.darmacash.com:33804",@"isDefault":@1,@"isSelect":@0};
    dic_default4=@{@"IP":@"app3.darmacash.com",@"prot":@"33804",@"userName":@"Default Node 4",@"password":@"",@"tip":tip,@"nodeNum":@3,@"node":@"app3.darmacash.com:33804",@"isDefault":@1,@"isSelect":@0};
    dic_default5=@{@"IP":@"app4.darmacash.com",@"prot":@"33804",@"userName":@"Default Node 5",@"password":@"",@"tip":tip,@"nodeNum":@4,@"node":@"app4.darmacash.com:33804",@"isDefault":@1,@"isSelect":@0};

    

    
    if (dataArray.count==0) {
        [dataArray addObject:dic_default0];
        [dataArray addObject:dic_default1];
        [dataArray addObject:dic_default2];
        [dataArray addObject:dic_default3];
        [dataArray addObject:dic_default4];
        [dataArray addObject:dic_default5];

    }

    
    [defaults setObject:dataArray forKey:nodeKey];
    [defaults synchronize];
   
}
-(void)selectNode:(NSString *)node{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* dataArray = [NSMutableArray array];
    dataArray=[NSMutableArray arrayWithArray:[defaults objectForKey:nodeKey]];
   
    for (int i=0; i<dataArray.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:dataArray[i]];
        if ([node isEqualToString:dic[@"node"]]) {
            [dic setValue:@1 forKey:@"isSelect"];
            [dataArray replaceObjectAtIndex:i withObject:dic];
        }else{
             [dic setValue:@0 forKey:@"isSelect"];
             [dataArray replaceObjectAtIndex:i withObject:dic];
        }
    }
    
    [defaults setObject:dataArray forKey:nodeKey];
    [defaults synchronize];
}
+ (NSString *)path
{
    

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
    return filePath;
}

@end
