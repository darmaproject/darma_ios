



#import "HomeViewController.h"

#import "HomeHeaderView.h"
#import "HomeListCell.h"
#import "PaymentDetailsViewController.h"
#import "WalletManageViewController.h"
#import "ReceiptViewController.h"
#import "PaymentViewController.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,AppwalletAppWalletStats>{
    BOOL isSend;
    BOOL isReceive;
    BOOL isPull;

}
@property(nonatomic, strong)UIView  *selectBtnView;
@property(nonatomic, strong)UIButton  *allBtn;
@property(nonatomic, strong)UIButton  *receiveBtn;
@property(nonatomic, strong)UIButton  *sendBtn;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) HomeHeaderView *headerView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *allArray;


@property(nonatomic, strong) NSDictionary *UpdateInfoDict;
@property(nonatomic, strong) NSString *minHeight;
@property(nonatomic, strong) NSString *maxHeight;
@property(nonatomic, strong) NSString *walletType;
@property(nonatomic, strong) NSString *lastHeight;

@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *title= [[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
    if (title.length>4) {
        title=[title substringToIndex:4];
        title=[NSString stringWithFormat:@"%@...",title];
    }
    self.navigateView.title = title;
    NSMutableArray * walletArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:addressNameKey]];
    for (int i=0; i<walletArray.count; i++) {
        NSDictionary  *dic=walletArray[i];
        NSString *name=dic[@"name"];
        NSString *type=dic[@"type"];
        NSString *title= [[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
        if ([name isEqualToString:title]) {
            if ([type isEqualToString:@"Read only the wallet"]) {
                _headerView.sendBtn.userInteractionEnabled=NO;
                _headerView.sendImage.image = [UIImage imageNamed:@"btn_send_gray"];
                _headerView.sendLabel.textColor = [UIColor colorWithHexString:@"#D2D6DC"];
                _headerView.sendLabel.text=BITLocalizedCapString(@"Send(read-only)", nil);
                
                _headerView.sendView.layer.borderColor=[UIColor clearColor].CGColor;
                _headerView.sendView.layer.borderWidth=0.0f;
            }else{
                _headerView.sendBtn.userInteractionEnabled=YES;
                _headerView.sendImage.image = [UIImage imageNamed:@"btn_send"];
                _headerView.sendLabel.textColor = [UIColor colorWithHexString:@"#202640"];
                _headerView.sendLabel.text=BITLocalizedCapString(@"Send", nil);
                
                _headerView.sendView.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
                _headerView.sendView.layer.borderWidth=1.0f;
            }
        }
    }
    
    
    
    [self Update_Wallet];
    
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title= [[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
    if (title.length>4) {
        title=[title substringToIndex:4];
        title=[NSString stringWithFormat:@"%@...",title];
    }
    self.navigateView.title = title;
    self.navigateView.backButton.hidden = YES;
    self.navigateView.backgroundImage.hidden=YES;
    [self configLeftButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    
    [self Update_Wallet];
  
}
- (void)configLeftButton
{
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    [settingBtn sizeToFit];
    [self.navigateView.contentView addSubview:settingBtn];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.left.equalTo(self.navigateView.contentView).offset(10);
    }];
}
-(void)pushSettingVC
{
    WalletManageViewController *vc  = [[WalletManageViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)configUI
{
    [self.view addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom);

    }];
    
    [self.view addSubview:self.selectBtnView];
    [_selectBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
    [_selectBtnView addSubview:self.allBtn];
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtnView).offset(17);
        make.top.equalTo(self.selectBtnView).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(64);
    }];
    [_selectBtnView addSubview:self.receiveBtn];
    [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allBtn.mas_right).offset(10);
        make.centerY.equalTo(self.allBtn);
        make.width.height.equalTo(self.allBtn);
    }];
    [_selectBtnView addSubview:self.sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiveBtn.mas_right).offset(10);
        make.centerY.equalTo(self.receiveBtn);
        make.width.height.equalTo(self.receiveBtn);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.selectBtnView.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    __weak typeof(self)weakSelf=self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         isPull=YES;
        [weakSelf getTransRecordsReceive:isReceive send:isSend starHeight:@"" pageNumber:@"20"];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [header setTitle:BITLocalizedCapString(@"Pull-to-refresh", nil) forState:MJRefreshStateIdle];
    [header setTitle:BITLocalizedCapString(@"Release to refresh", nil) forState:MJRefreshStatePulling];
    [header setTitle:BITLocalizedCapString(@"Refreshing", nil) forState:MJRefreshStateRefreshing];
     header.lastUpdatedTimeLabel.hidden=YES;


    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        isPull=NO;
        if (![Tool isBlankString:_lastHeight]) {
             [weakSelf getTransRecordsReceive:isReceive send:isSend starHeight:_lastHeight pageNumber:@"20"];
         }
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    
    self.tableView.mj_footer = footer;


  
}
- (void)Update_Wallet{
    [[MobileWalletSDKManger shareInstance].mobileWallet set_DumpStats_Callback:self];

    
    [self screenAll:nil];
    
}
-(void)dumpWalletStats:(NSString *)stats{
    NSLog(@"-----------Synchronize wallet data %@",stats);
    _UpdateInfoDict=[[NSDictionary alloc] init];
    if (stats != nil) {
        NSData *jsonData = [stats dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        _UpdateInfoDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:&err];
        if(err)
        {
            NSLog(@"Json parsing failed：%@",err);
        }else{
            NSString * Unlocked_balance=_UpdateInfoDict[@"unlocked_balance"];
            NSString * Locked_balance=_UpdateInfoDict[@"locked_balance"];
            NSUInteger wallet_topo_height=[_UpdateInfoDict[@"wallet_topo_height"] integerValue];
            NSUInteger daemon_topo_height=[_UpdateInfoDict[@"daemon_topo_height"] integerValue];
            int wallet_height=[ _UpdateInfoDict[@"wallet_height"]intValue];
            NSString *wallet_balance_changed=[NSString stringWithFormat:@"%@", _UpdateInfoDict[@"wallet_balance_changed"]];
            BOOL wallet_online=(bool)_UpdateInfoDict[@"wallet_online"];
            BOOL wallet_network=(bool)_UpdateInfoDict[@"wallet_available"];


            _minHeight=[NSString stringWithFormat:@"%i",wallet_height-10];
            _maxHeight=[NSString stringWithFormat:@"%i",wallet_height];

            dispatch_async(dispatch_get_main_queue(),^{
                
                [_headerView showContentView:Unlocked_balance Locked_balance:Locked_balance wallet_topo_height:wallet_topo_height Daemon_topo_height:daemon_topo_height Wallet_online:wallet_online Wallet_network:wallet_network];
                
                if ([wallet_balance_changed isEqualToString:@"1"]) {
                    [self getTransRecordsReceive:isReceive send:isSend starHeight:@"" pageNumber:@"20"];
                }
                
            });

        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *items=[[NSArray alloc] init];
    items =self.dataArray[section];
    if (items.count>0) {
        return 33.0;
    }else{
        return 0.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *items=[[NSArray alloc] init];
    items =self.dataArray[section];
    if (items.count>0) {
        UIView *tableviewHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 33)];
        tableviewHeadView.backgroundColor=[UIColor whiteColor];
        UILabel *lab_time=[[UILabel alloc] initWithFrame:CGRectMake(16, 0,Width-32, 33)];
       
        NSDictionary *dic=items[0];
        NSString *time=[NSString stringWithFormat:@"%@", dic[@"time"]];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSDate *date =[formatter1 dateFromString:time];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];

        [formatter2 setDateFormat:@"MM/yyyy"];
        NSString *Time = [formatter2 stringFromDate:date ];
        NSArray *array=[Time componentsSeparatedByString:@"/"];
        lab_time.text=[NSString stringWithFormat:@"%@，%@",BITLocalizedCapString(array[0], nil),array[1]];
        lab_time.textColor=[UIColor colorWithHexString:@"#9CA8B3"];
        lab_time.font=[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [tableviewHeadView addSubview:lab_time];
        return tableviewHeadView;
    }else{
         return nil;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items=[[NSArray alloc] init];
    items =self.dataArray[section];
    return items.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HomeListCell.class)];
    NSArray *items=[[NSArray alloc] init];
    items =self.dataArray[indexPath.section];
    cell.dic=items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items=[[NSArray alloc] init];
     items =self.dataArray[indexPath.section];
    NSDictionary *dict =items[indexPath.row];;
    PaymentDetailsViewController *controller = [PaymentDetailsViewController controllerWithDict:dict];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)send:(UIButton *)sender{
   
    PaymentViewController*controller = [[PaymentViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.infoDict=_UpdateInfoDict;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)receive:(UIButton *)sender{

    ReceiptViewController*controller = [[ReceiptViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)screenAll:(UIButton *)sender{
    sender.selected =!sender.selected;
    
    [_allBtn setTitleColor:[UIColor colorWithHexString:@"#3EB7BA"] forState:UIControlStateNormal];
    [_receiveBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
    isSend=YES;
    isReceive=YES;
     [self.allArray removeAllObjects];
    [self getTransRecordsReceive:isReceive send:isSend starHeight:@"" pageNumber:@""];
}
-(void)screenReceive:(UIButton *)sender{
    sender.selected =!sender.selected;
    [_receiveBtn setTitleColor:[UIColor colorWithHexString:@"#3EB7BA"] forState:UIControlStateNormal];
    [_allBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
    
    isSend=NO;
    isReceive=YES;
     [self.allArray removeAllObjects];
    [self getTransRecordsReceive:isReceive send:isSend starHeight:@"" pageNumber:@"20"];
}
-(void)screenSend:(UIButton *)sender{
    sender.selected =!sender.selected;
    
    [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#3EB7BA"] forState:UIControlStateNormal];
    [_receiveBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
    [_allBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
    
    isSend=YES;
    isReceive=NO;
     [self.allArray removeAllObjects];
    [self getTransRecordsReceive:isReceive send:isSend starHeight:@"" pageNumber:@"20"];
}

-(void)getTransRecordsReceive:(BOOL)receive send:(BOOL)send starHeight:(NSString *)startHeight pageNumber:(NSString *)pageNumber{

   
    NSArray *array=  [[MobileWalletSDKManger shareInstance] transferRecords:receive send:send max_height_str:startHeight str_number:pageNumber];
    _lastHeight=[NSString stringWithFormat:@"%@",[array lastObject][@"height"]];
    
    if (isPull==NO) {
        [self.dataArray removeAllObjects];
        [self.allArray addObjectsFromArray:array];
    }else{
        [self.dataArray removeAllObjects];

        self.allArray=[[NSMutableArray alloc]initWithArray:array];
    }

    NSMutableArray *muArray=[[NSMutableArray alloc] initWithArray:self.allArray];

    for (int i = 0; i < muArray.count; i ++) {
        NSDictionary *dic=muArray[i];
        NSString *time=[NSString stringWithFormat:@"%@", dic[@"time"]];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSDate *date =[formatter1 dateFromString:time];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"yyyy/MM"];
        NSString *Time = [formatter2 stringFromDate:date ];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [tempArray addObject:dic];
        for (int j=i+1;j<muArray.count;j++) {
            NSDictionary *dic2=muArray[j];
            NSString *time2=[NSString stringWithFormat:@"%@", dic2[@"time"]];
            NSDate *date2 =[formatter1 dateFromString:time2];
            NSString *Time2 = [formatter2 stringFromDate:date2 ];
            if ([Time isEqualToString:Time2]) {
                [tempArray addObject:dic2];
                [muArray removeObjectAtIndex:j];
                j -= 1;
            }
        }
        
        [self.dataArray addObject:tempArray];
      
    }
    
    
    NSMutableArray *resultArrM = [NSMutableArray array];
    for ( NSObject *obj in self.dataArray) {
        if (![resultArrM containsObject:obj]) {
            [resultArrM addObject:obj];
        }
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < resultArrM.count; i ++) {
         NSArray *array =resultArrM[i];
        NSMutableArray *dddArray = [[NSMutableArray alloc] init];
        for (int j=0; j<array.count; j++) {
            NSDictionary *dic=array[j];
            NSString *status=[NSString stringWithFormat:@"%@",dic[@"status"]];
            if (receive&&!send) {
                if ([status intValue]==0) {
                    [dddArray addObject:dic];
                }
            }else if (send&&!receive){
                if ([status intValue]==1) {
                    [dddArray addObject:dic];
                }
            }else{
                [dddArray addObject:dic];
            }
        }
        [result addObject:dddArray];

    }

    self.dataArray=[[NSMutableArray alloc] initWithArray:result];

    
    [_tableView reloadData];
    if (self.dataArray.count==0) {
        self.tableView.mj_footer.alpha = 0.0;
    }else{
        self.tableView.mj_footer.alpha = 1.0;
    }
}

- (HomeHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[HomeHeaderView alloc] init];
        _headerView.alpha = 1.0;
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];

        _headerView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _headerView.layer.shadowOffset = CGSizeMake(0,0);
        _headerView.layer.shadowRadius = 20;
        _headerView.layer.shadowOpacity = 0.1;
        _headerView.layer.masksToBounds = NO;
        
        float shadowPathWidth = _headerView.layer.shadowRadius;
        CGRect shadowRect = CGRectMake(0,215, Width, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];

        _headerView.layer.shadowPath=path.CGPath;
        
        [_headerView.receiveBtn addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.sendBtn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UIView *)selectBtnView
{
    if (!_selectBtnView)
    {
        _selectBtnView = [[UIView alloc] init];
    }
    return _selectBtnView;
}

- (UIButton *)allBtn
{
    if (!_allBtn)
    {
        _allBtn = [[UIButton alloc] init];
        _allBtn = [[UIButton alloc] init];
        [_allBtn setTitle:BITLocalizedCapString(@"All", nil) forState:UIControlStateNormal];
        
        _allBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_allBtn setTitleColor:[UIColor colorWithHexString:@"#3EB7BA"] forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(screenAll:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}
- (UIButton *)receiveBtn
{
    if (!_receiveBtn)
    {
        _receiveBtn = [[UIButton alloc] init];
        [_receiveBtn setTitle:BITLocalizedCapString(@"Receive" , nil) forState:UIControlStateNormal];

        _receiveBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_receiveBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
        [_receiveBtn addTarget:self action:@selector(screenReceive:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
}
- (UIButton *)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:BITLocalizedCapString(@"Send", nil) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#9CA8B3"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(screenSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[HomeListCell class] forCellReuseIdentifier:NSStringFromClass(HomeListCell.class)];
        _tableView.rowHeight =66;
        
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -44, 0, 0);
        _tableView.separatorColor =[UIColor whiteColor] ;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (NSMutableArray *)allArray
{
    if (!_allArray)
    {
        _allArray = [NSMutableArray array];
        
    }
    return _allArray;
}
@end
