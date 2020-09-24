

extern NSString * const addressNameKey;
extern NSString * const walletAddressKey;
extern NSString * const nodeKey;
extern NSString * const backupWalletPath;
extern NSString * const currentWalletNameKey;
extern NSString * const TradeRecordKey;
NS_ASSUME_NONNULL_BEGIN

@interface MobileWalletSDKManger : NSObject
+ (instancetype)shareInstance;
+ (NSString *)path;
@property(strong, nonatomic) AppwalletMobileWallet *mobileWallet;
@property(strong, nonatomic) Appwallet *wallet;
-(NSInteger)set_Initial_Height_Default;
- (BOOL)OpenWallet:(NSString *)walletName password:(NSString*)password;
-(void)closeWallet;

- (NSString *)walletAddress;

- (NSString *)Generate_Intergrated_Address:(long)length;

-(NSDictionary *)Verify_Address:(NSString*)string;

- (void)Update_Wallet;
- (void)Stop_Update;

-(NSDictionary *)transfer:(NSString* _Nonnull)walletAddress amountstr:(NSString* _Nonnull)amountstr unlock_time_str:(NSString* _Nonnull)unlock_time_str payment_id:(NSString* _Nonnull)payment_id mixin:(long)mixin sendtx:(BOOL)sendtx password:(NSString* _Nonnull)password;


-(NSDictionary *)Transfer_Everything:(NSString* _Nonnull)walletAddress unlock_time_str:(NSString* _Nullable)unlock_time_str payment_id:(NSString* _Nullable)payment_id mixin:(long)mixin password:(NSString* _Nonnull)password;


-(NSString *)Send_Raw_Transaction:(NSString* _Nonnull)txraw;

-(NSArray *)transferRecords:(BOOL)receive send:(BOOL)send max_height_str:(NSString* _Nullable)max_height_str str_number:(NSString* _Nullable)str_number;

-(void)saveDefaultNodeList;
-(void)selectNode:(NSString *)node;

@property(strong, nonatomic) NSString *readOnleyWallet;

@end

NS_ASSUME_NONNULL_END
