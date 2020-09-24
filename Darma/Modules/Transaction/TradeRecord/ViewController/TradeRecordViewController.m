



#import "TradeRecordViewController.h"

#import "TradeRecordCell.h"
#import "TradeDetailsModel.h"
#import "TradeRecodeDetailsViewController.h"

@interface TradeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) TradeDetailsModel *model;


@end

@implementation TradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigateView.title =BITLocalizedCapString(@"str_order_log", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLayoutUI];
    dispatch_async(dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.dataArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:TradeRecordKey]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    

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
    TradeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TradeRecordCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:self.dataArray[indexPath.row]];
    _model=[TradeDetailsModel  yy_modelWithDictionary:dic];
    cell.model=_model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TradeRecodeDetailsViewController *con=[[TradeRecodeDetailsViewController alloc] init];
    NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:self.dataArray[indexPath.row]];
    con.model=[TradeDetailsModel  yy_modelWithDictionary:dic];;
    [self.navigationController pushViewController:con animated:YES];
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[TradeRecordCell class] forCellReuseIdentifier:NSStringFromClass(TradeRecordCell.class)];
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
