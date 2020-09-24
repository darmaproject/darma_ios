



#import "AddressListViewController.h"

#import "AddressCell.h"
#import "AddAdressViewController.h"

@interface AddressListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *items;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=BITLocalizedCapString(@"Address book", nil) ;
    self.navigateView.title = title;
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self configRightButton];
    
    
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    dispatch_async(dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary* addressSDic = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:walletAddressKey]];
        if (_coinName.length<=0) {
            _coinName=@"dmc";
        }
        self.items=addressSDic[_coinName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}
- (void)configRightButton
{
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressButton addTarget:self action:@selector(AddAddress:) forControlEvents:UIControlEventTouchUpInside];
    [addressButton setImage:[UIImage imageNamed:@"add_button_nav"] forState:UIControlStateNormal];
    
    [addressButton sizeToFit];
    [self.navigateView.contentView addSubview:addressButton];
    [addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.right.equalTo(self.navigateView.contentView).offset(-10);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AddressCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dict=[[NSDictionary alloc] initWithDictionary:self.items[indexPath.row]];
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
    
    NSDictionary *dict =[[NSDictionary alloc] initWithDictionary:self.items[indexPath.row]];
  
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *openWallet=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Open", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openWallet:dict];
        
    }];
  
    UIAlertAction *delete=[UIAlertAction actionWithTitle:BITLocalizedCapString(@"Remove", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteWithIDNum:dict];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [openWallet setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    [delete setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#202640"] forKey:@"titleTextColor"];
    
   
    [alertC addAction:openWallet];
    [alertC addAction:delete];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
-(void)openWallet:(NSDictionary *)dict{
    self.info(dict);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteWithIDNum:(NSDictionary *)dict
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary* addressSDic = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:walletAddressKey]];
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:addressSDic[_coinName]];

    if ([array containsObject: dict]) {
        [array removeObject:dict];
    }
    [addressSDic setValue:array forKey:_coinName];
    
    [defaults setObject:addressSDic forKey:walletAddressKey];
    [defaults synchronize];
    
    NSMutableDictionary* addressNewDic = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:walletAddressKey]];
    _items=[NSMutableArray arrayWithArray:addressNewDic[_coinName]];
    [_tableView reloadData];
}
-(void)AddAddress:(UIButton *)sender{
    
   
    AddAdressViewController *vc = [[AddAdressViewController alloc]init];
    vc.coinName=_coinName;
    vc.addBlock = ^{
        NSMutableDictionary* addressSDic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:walletAddressKey]];
        _items=[NSMutableArray arrayWithArray:addressSDic[_coinName]];
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[AddressCell class] forCellReuseIdentifier:NSStringFromClass(AddressCell.class)];
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

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [[NSMutableArray alloc] init];

    }
    return _items;
}
@end
