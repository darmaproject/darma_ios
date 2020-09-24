



#import "TradeOrderDetailsViewController.h"

#import "TradeOrderDetailsCell.h"
#import "RequestAPIManager.h"
#import "TradeDetailsModel.h"


@interface TradeOrderDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) TradeDetailsModel *model;

@end

@implementation TradeOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigateView.title =BITLocalizedCapString(@"Details", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLayoutUI];
    [self orderDetailRequest];

}

- (void)addLayoutUI
{
  
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-FitH(20));
    }];
}

-(void)orderDetailRequest{
    RequestAPIManager *manager=[[RequestAPIManager alloc] init];
    [manager GETRequestQueryOrder:_orderID success:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
        if (!dic) {
            [SHOWProgressHUD showMessage:responseObject[@"message"]];
        }
        _model=[TradeDetailsModel  yy_modelWithDictionary:dic];

        NSArray *arry=[_model.pair componentsSeparatedByString:@"_"];
        
        NSString *sendCoin=[NSString stringWithFormat:@"%@",[[arry firstObject] uppercaseString]];
        NSString *receiveCoin=[NSString stringWithFormat:@"%@",[[arry lastObject] uppercaseString]];
        
        NSInteger count =[[NSString stringWithFormat:@"%@",_model.seconds_till_timeout] integerValue];
        NSString *remainTime=[NSString stringWithFormat:@"%ld'%ld''", (count/(long)60), count%(long)60];
        NSString * state_str =[NSString stringWithFormat:@"%@",_model.state_string];
        
        NSString *time=[NSString stringWithFormat:@"%@",_model.created_at];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date =[formatter1 dateFromString:time];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *createTime = [formatter2 stringFromDate:date ];
        
        if ([_model.state isEqualToString:@"TIMED_OUT"]||[_model.state isEqualToString:@"UNPAID"]) {
            self.dataArray=[NSMutableArray arrayWithArray:@[@{@"title":BITLocalizedCapString(@"ID", nil),@"content":_model.order_id},
                                                        @{@"title":BITLocalizedCapString(@"Status", nil),@"content":state_str},
                                                        @{@"title":BITLocalizedCapString(@"Order Date", nil),@"content":createTime},
                                                        @{@"title":BITLocalizedCapString(@"str_time_out1", nil),@"content":remainTime},
                                                        @{@"title":BITLocalizedCapString(@"Price", nil),@"content":_model.order_price},
                                                        @{@"title":BITLocalizedCapString(@"Send Coin", nil),@"content":sendCoin},
                                                        @{@"title":BITLocalizedCapString(@"Order Amount", nil),@"content":_model.base_amount_total},
                                                        @{@"title":BITLocalizedCapString(@"Receive Coin", nil),@"content":receiveCoin},
                                                        @{@"title":BITLocalizedCapString(@"Excepted Receive Amount", nil),@"content":_model.quota_amount},
                                                        @{@"title":BITLocalizedCapString(@"Send Address", nil),@"content":_model.base_receiving_integrated_address},
                                                        @{@"title":BITLocalizedCapString(@"Receive Address", nil),@"content":_model.quota_dest_address}]];
            
        }else if ([_model.state isEqualToString:@"PAID_UNCONFIRMED"]||[_model.state isEqualToString:@"PAID"]){
            self.dataArray=[NSMutableArray arrayWithArray:@[@{@"title":BITLocalizedCapString(@"ID", nil),@"content":_model.order_id},
                                                        @{@"title":BITLocalizedCapString(@"Status", nil),@"content":state_str},
                                                        @{@"title":BITLocalizedCapString(@"Order Date", nil),@"content":createTime},
                                                        @{@"title":BITLocalizedCapString(@"Price", nil),@"content":_model.order_price},
                                                        @{@"title":BITLocalizedCapString(@"Send Coin", nil),@"content":sendCoin},
                                                        @{@"title":BITLocalizedCapString(@"Order Amount", nil),@"content":_model.base_amount_total},
                                                        @{@"title":BITLocalizedCapString(@"Sent Amount", nil),@"content":_model.base_received_amount},
                                                        @{@"title":BITLocalizedCapString(@"Receive Coin", nil),@"content":receiveCoin},
                                                        @{@"title":BITLocalizedCapString(@"Excepted Receive Amount", nil),@"content":_model.quota_amount},
                                                        @{@"title":BITLocalizedCapString(@"Send Address", nil),@"content":_model.base_receiving_integrated_address},
                                                        @{@"title":BITLocalizedCapString(@"Receive Address", nil),@"content":_model.quota_dest_address},
                                                        @{@"title":BITLocalizedCapString(@"Send TXID", nil),@"content":_model.base_transaction_id}]];
            
        }else if ([_model.state isEqualToString:@"SENDING"]||[_model.state isEqualToString:@"SUCCESS"]){
            self.dataArray=[NSMutableArray arrayWithArray:@[@{@"title":BITLocalizedCapString(@"ID", nil),@"content":_model.order_id},
                                                        @{@"title":BITLocalizedCapString(@"Status", nil),@"content":state_str},
                                                        @{@"title":BITLocalizedCapString(@"Transaction Price", nil),@"content":_model.final_price},
                                                        @{@"title":BITLocalizedCapString(@"Total Transaction Amount", nil),@"content":_model.quota_real_amount},
                                                        @{@"title":BITLocalizedCapString(@"Order Date", nil),@"content":createTime},
                                                        @{@"title":BITLocalizedCapString(@"Price", nil),@"content":_model.order_price},
                                                        @{@"title":BITLocalizedCapString(@"Send Coin", nil),@"content":sendCoin},
                                                        @{@"title":BITLocalizedCapString(@"Order Amount", nil),@"content":_model.base_amount_total},
                                                        @{@"title":BITLocalizedCapString(@"Sent Amount", nil),@"content":_model.base_received_amount},
                                                        @{@"title":BITLocalizedCapString(@"Receive Coin", nil),@"content":receiveCoin},
                                                        @{@"title":BITLocalizedCapString(@"Excepted Receive Amount", nil),@"content":_model.quota_amount},
                                                        @{@"title":BITLocalizedCapString(@"Send Address", nil),@"content":_model.base_receiving_integrated_address},
                                                        @{@"title":BITLocalizedCapString(@"Receive Address", nil),@"content":_model.quota_dest_address},
                                                        @{@"title":BITLocalizedCapString(@"Send TXID", nil),@"content":_model.base_transaction_id},
                                                        @{@"title":BITLocalizedCapString(@"Receive TXID", nil),@"content":_model.quota_transaction_id}]];
            
        }else if ([_model.state isEqualToString:@"FAILED_REFUNDED"]||[_model.state isEqualToString:@"FAILED_UNREFUND"]){
            NSString * state_title;
            if ([_model.state isEqualToString:@"FAILED_UNREFUND"]) {
                state_title =BITLocalizedCapString(@"Amount to be Returned", nil);
            }else if ([_model.state isEqualToString:@"FAILED_REFUNDED"]){
                state_title =BITLocalizedCapString(@"Returned Amount", nil);
            }
            self.dataArray=[NSMutableArray arrayWithArray:@[@{@"title":BITLocalizedCapString(@"ID", nil),@"content":_model.order_id},
                                                        @{@"title":BITLocalizedCapString(@"Status", nil),@"content":state_str},
                                                        @{@"title":BITLocalizedCapString(@"Order Date", nil),@"content":createTime},
                                                        @{@"title":BITLocalizedCapString(@"Price", nil),@"content":_model.order_price},
                                                        @{@"title":BITLocalizedCapString(@"Send Coin", nil),@"content":sendCoin},
                                                        @{@"title":BITLocalizedCapString(@"Order Amount", nil),@"content":_model.base_amount_total},
                                                        @{@"title":BITLocalizedCapString(@"Excepted Receive Amount", nil),@"content":_model.quota_amount},
                                                        @{@"title":state_title,@"content":_model.refund_amount},
                                                        @{@"title":BITLocalizedCapString(@"Receive Coin", nil),@"content":receiveCoin},
                                                        @{@"title":BITLocalizedCapString(@"Send Address", nil),@"content":_model.base_receiving_integrated_address},
                                                        @{@"title":BITLocalizedCapString(@"Receive Address", nil),@"content":_model.quota_dest_address},
                                                        @{@"title":BITLocalizedCapString(@"Refund Address", nil),@"content":_model.refund_address}]];
        }
        
        [_tableView reloadData];
    } fail:^(NSURLSessionDataTask * task, NSError * error) {
        [SHOWProgressHUD showMessage:error.domain];
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
    TradeOrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TradeOrderDetailsCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic= self.dataArray[indexPath.row];;
    cell.infoDict=dic;
    cell.cpButton.tag=indexPath.row+10;
    [cell.cpButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)buttonClick:(UIButton *)sender
{
    NSString *str_content=self.dataArray[sender.tag-10][@"content"];
    if (str_content.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str_content;
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copied", nil)];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[TradeOrderDetailsCell class] forCellReuseIdentifier:NSStringFromClass(TradeOrderDetailsCell.class)];
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

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc] init];
        
    }
    return _dataArray;
}

@end
