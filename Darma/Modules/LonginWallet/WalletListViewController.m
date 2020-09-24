


#import "WalletListViewController.h"

#import "WalletListCell.h"
#import "ChooseTypeViewController.h"

@interface WalletListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WalletListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title = BITLocalizedCapString(@"Wallets", nil);
    
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
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [createButton setTitle:BITLocalizedCapString(@"New", nil) forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor colorWithHexString:@"#AF7EC1"] forState:UIControlStateNormal];
    [createButton sizeToFit];
    [createButton addTarget:self action:@selector(createNewWallet:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigateView.contentView addSubview:createButton];
    [createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.right.equalTo(self.navigateView.contentView).offset(-10);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    WalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WalletListCell.class)];
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
    self.info(dict);
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

-(void)createNewWallet:(UIButton *)sender{
    ChooseTypeViewController *createVC=[[ChooseTypeViewController alloc] init];
    [self.navigationController pushViewController:createVC animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[WalletListCell class] forCellReuseIdentifier:NSStringFromClass(WalletListCell.class)];
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
