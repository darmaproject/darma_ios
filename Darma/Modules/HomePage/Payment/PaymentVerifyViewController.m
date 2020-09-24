

#import "PaymentVerifyViewController.h"

#import "PaymentVerifyViewController.h"

#import "PaymentVerifyCell.h"
#import "PaymentFinishViewController.h"
#import "TradeOrderDetailsViewController.h"

@interface PaymentVerifyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIButton *sureButton;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation PaymentVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Confirm transaction", nil);
   
    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(Fit(12));
        make.right.equalTo(self.view).offset(Fit(-12));
        make.height.equalTo(@(FitH(48)));
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-FitH(20));
    }];
    [self.view addSubview:self.tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.bottom.equalTo(self.sureButton.mas_top);
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
    PaymentVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PaymentVerifyCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==2) {
        cell.contentLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
        cell.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    }
    NSDictionary *dic= self.dataArray[indexPath.row];;
    cell.infoDict=dic;
   
    return cell;
}
- (void)sure:(UIButton *)sender
{
    NSString* text= [[MobileWalletSDKManger shareInstance] Send_Raw_Transaction:_dicInfo[@"transfer_txhex"]];
    if (text.length<=0) {
        NSString *error= AppwalletGetLastError();
        NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        [SHOWProgressHUD showMessage:dic[@"errMsg"]];
        return;
    }
    if ([_className isEqualToString:@"TradeDetailsViewController"]) {
        TradeOrderDetailsViewController*controller = [[TradeOrderDetailsViewController alloc] init];
        controller.orderID=_orderID;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        PaymentFinishViewController*controller = [[PaymentFinishViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.dicInfo=_dicInfo;
        controller.txid=text;
        controller.paymentID=_paymentID;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[PaymentVerifyCell class] forCellReuseIdentifier:NSStringFromClass(PaymentVerifyCell.class)];
        _tableView.rowHeight =UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0,18, 0, 18);
        _tableView.separatorColor =[UIColor colorWithHexString:@"#D2D6DC"] ;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}
- (UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:BITLocalizedCapString(@"Confirm", nil) forState:UIControlStateNormal];
        _sureButton.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_sureButton setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        
        _sureButton.layer.cornerRadius=8.0f;
        _sureButton.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _sureButton.layer.borderWidth=1.0f;
        _sureButton.layer.masksToBounds=YES;
        [_sureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc] init];
      
    }
    NSString *amount=AppwalletFormat_Money([NSString stringWithFormat:@"%@",_dicInfo[@"amount"]]);
    NSString *fee=AppwalletFormat_Money([NSString stringWithFormat:@"%@",_dicInfo[@"fee"]]);

    _dataArray=[NSMutableArray arrayWithArray:@[@{@"title":@"Darma address",@"content":_address},
                                                @{@"title":@"Payment ID",@"content":_paymentID},
                                                @{@"title":@"Amount",@"content":amount},
                                                @{@"title":@"Fee",@"content":fee},
                                                @{@"title":@"Remark",@"content":@""}]];

    return _dataArray;
}


@end
