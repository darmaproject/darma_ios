



#import "NodeViewController.h"

#import "NodeListCell.h"
#import "AddNodeViewController.h"
#import "PingNodeViewController.h"

@interface NodeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation NodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Nodes", nil) ;
    [self configRightButton];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
}
- (void)configRightButton
{
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [AddButton addTarget:self action:@selector(AddNode:) forControlEvents:UIControlEventTouchUpInside];
    [AddButton setImage:[UIImage imageNamed:@"add_button_nav"] forState:UIControlStateNormal];
    
    [AddButton sizeToFit];
    [self.navigateView.contentView addSubview:AddButton];
    [AddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.right.equalTo(self.navigateView.contentView).offset(-10);
    }];
}
-(void)AddNode:(UIButton *)sender{
    AddNodeViewController *vc = [[AddNodeViewController alloc]init];
    vc.isState=@"Add Nodes";
    vc.addNodeBlock = ^{
        _dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:nodeKey]];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    NodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NodeListCell.class)];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.dict = dict;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
   
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *selectNode=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Select", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectNode:dict ];
        
    }];
    UIAlertAction *editNode=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Edit", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editNode:dict ];
        
    }];
    UIAlertAction *pingNode=[UIAlertAction actionWithTitle:@"Ping" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pingNode:dict ];
        
    }];
    UIAlertAction *delete=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Remove", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteWithIDNum:dict];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [selectNode setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    [editNode setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    [pingNode setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    [delete setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    
    NSString *isDefault=[NSString stringWithFormat:@"%@",dict[@"isDefault"]];
    NSString *isSelect=[NSString stringWithFormat:@"%@",dict[@"isSelect"]];

    if ([isDefault isEqualToString:@"1"]) {
        [alertC addAction:selectNode];
        [alertC addAction:pingNode];
    }else{
        if ([isSelect isEqualToString:@"0"]) {
            [alertC addAction:selectNode];
            [alertC addAction:editNode];
            [alertC addAction:pingNode];
            [alertC addAction:delete];
        }else{
            [alertC addAction:pingNode];
        }
    }

    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
   
}
-(void)selectNode:(NSDictionary *)dict{
    BOOL isSuccess=[[MobileWalletSDKManger shareInstance].mobileWallet set_Daemon_Address:dict[@"node"]];
    if (isSuccess) {
        [[MobileWalletSDKManger shareInstance] selectNode:dict[@"node"]];
        _dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:nodeKey]];
        [self.tableView reloadData];
    }
    
    
}
-(void)editNode:(NSDictionary *)dict{
    AddNodeViewController *vc = [[AddNodeViewController alloc]init];
    vc.isState=@"Edit Nodes";
    vc.nodeInfo=dict;
    vc.addNodeBlock = ^{
        _dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:nodeKey]];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pingNode:(NSDictionary *)dict{
    
    PingNodeViewController *vc = [[PingNodeViewController alloc]init];
    vc.nodeInfo=dict;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)deleteWithIDNum:(NSDictionary *)dict
{
    if ([_dataArray containsObject:dict]) {
         [_dataArray removeObject:dict];
        
        [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:nodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:nodeKey]];
        [self.tableView reloadData];
    }
   
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[NodeListCell class] forCellReuseIdentifier:NSStringFromClass(NodeListCell.class)];
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


- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
        _dataArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:nodeKey]];

    }
    return _dataArray;
}

@end
