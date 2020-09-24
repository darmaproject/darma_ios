


#import "TradeRecodeDetailsViewController.h"

#import "TradeRecordeDetailsCell.h"
#import "RequestAPIManager.h"

#import "TradeOrderDetailsViewController.h"

@interface TradeRecodeDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TradeRecodeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigateView.title =BITLocalizedCapString(@"Details", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self configRightButton];
    [self addLayoutUI];

    dispatch_async(dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT), ^{
        
        NSString *time=[NSString stringWithFormat:@"%@",_model.created_at];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date =[formatter1 dateFromString:time];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *Time = [formatter2 stringFromDate:date ];
        
        NSString *amount=[NSString stringWithFormat:@"%@",_model.base_amount_total];

        NSArray *arry=[_model.pair componentsSeparatedByString:@"_"];
        NSString *tradePair=[NSString stringWithFormat:@"%@/%@",[[arry firstObject] uppercaseString],[[arry lastObject] uppercaseString]];
        
        self.dataArray=[NSMutableArray arrayWithArray:@[@{@"title":BITLocalizedCapString(@"ID", nil),@"content":_model.order_id},
                                                    @{@"title":BITLocalizedCapString(@"Date", nil),@"content":Time},
                                                    @{@"title":BITLocalizedCapString(@"Amount", nil),@"content":amount},
                                                    @{@"title":BITLocalizedCapString(@"Pair", nil),@"content":tradePair},
                                                    @{@"title":BITLocalizedCapString(@"Status", nil),@"content":_model.state}
                                                   ]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
        [self orderDetailRequest];
    });
}
- (void)configRightButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"trade_recoder_nav_btn"] forState:UIControlStateNormal];
    
    [rightBtn sizeToFit];
    [self.navigateView.contentView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.right.equalTo(self.navigateView.contentView).offset(-10);
    }];
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
    [manager GETRequestQueryOrder:_model.order_id success:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
        if (dic) {
            _model=[TradeDetailsModel  yy_modelWithDictionary:dic];
            if (_model.state_string) {
                NSDictionary *dic=[[NSDictionary alloc] init];
                dic=@{@"title":BITLocalizedCapString(@"Status", nil),@"content":_model.state_string};
                for (int i=0; i<self.dataArray.count; i++) {
                    NSDictionary *oldDic=[[NSDictionary alloc] init];
                    oldDic=self.dataArray[i];
                    if ([oldDic[@"title"] isEqualToString:BITLocalizedCapString(@"Status", nil)]) {
                        [self.dataArray removeObject:oldDic];
                        [self.dataArray addObject:dic];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }else{
             [SHOWProgressHUD showMessage:responseObject[@"message"]];
        }
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
    TradeRecordeDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TradeRecordeDetailsCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic= self.dataArray[indexPath.row];
    cell.infoDict=dic;
    if ([dic[@"title"] isEqualToString:BITLocalizedCapString(@"ID", nil)]) {
        UIButton *cpButton = [[UIButton alloc] init];
        [cpButton setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
        [cpButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        cpButton.tag = 10+indexPath.row;
        [cell.contentView addSubview:cpButton];
        [cpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentLabel.mas_bottom);
            make.right.equalTo(cell.contentView).offset(FitW(-17));
            make.width.mas_equalTo(Fit(22));
            make.height.mas_equalTo(Fit(22));
        }];
    }
    
    
    return cell;
}

- (void)rightBtn:(UIButton *)sender
{
    TradeOrderDetailsViewController *con=[[TradeOrderDetailsViewController alloc] init];
    con.orderID=_model.order_id;
    [self.navigationController pushViewController:con animated:YES];
}


- (void)buttonClick:(UIButton *)sender
{
    NSString *str_OrderID=self.dataArray[sender.tag-10][@"content"];
    if (str_OrderID.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str_OrderID;
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
        [_tableView registerClass:[TradeRecordeDetailsCell class] forCellReuseIdentifier:NSStringFromClass(TradeRecordeDetailsCell.class)];
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
