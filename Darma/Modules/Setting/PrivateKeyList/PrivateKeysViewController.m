



#import "PrivateKeysViewController.h"
#import "PrivateKeysCell.h"

@interface PrivateKeysViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation PrivateKeysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigateView.title =BITLocalizedCapString(@"Show keys", nil) ;
    [self addLayoutUI];
    
    dispatch_async(dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT), ^{
    
        NSString *prvateKeys=[[MobileWalletSDKManger shareInstance].mobileWallet get_Keys:_password];
        NSData *jsonData = [prvateKeys dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
       
            if(err) {
                NSString *error= AppwalletGetLastError();
                NSLog(@"Failed to obtain the private key-----------%@",error);
                NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                [SHOWProgressHUD showMessage:dic[@"errMsg"]];
            }else{
               
                 dispatch_async(dispatch_get_main_queue(), ^{
                     _dataArray=[NSMutableArray arrayWithArray:@[@{@"title":@"View Key (public)",@"content":dic[@"Viewkey_Public"]},
                                                                 @{@"title":@"View Key (private)",@"content":dic[@"Viewkey_Secret"]},
                                                                 @{@"title":@"Spend key(public)",@"content":dic[@"Spendkey_Public"]},
                                                                 @{@"title":@"Spend key(private)",@"content":dic[@"Spendkey_Secret"]}]];
                    [_tableView reloadData];
                });
            }
      
    });
  
   
}
- (void)addLayoutUI
{
    
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(20);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
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
    PrivateKeysCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PrivateKeysCell.class)];
    cell.dict = self.dataArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIButton *cpButton = [[UIButton alloc] init];
    [cpButton setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
    [cpButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cpButton.tag = 100+indexPath.row;
    [cell.contentView addSubview:cpButton];
    [cpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentLabel.mas_bottom);
        make.right.equalTo(cell.contentView).offset(FitW(-17));
        make.width.mas_equalTo(Fit(22));
        make.height.mas_equalTo(Fit(22));
    }];
   
    return cell;
}
- (void)buttonClick:(UIButton *)sender
{
    NSString *str_key=self.dataArray[sender.tag-100][@"content"];
    if (str_key.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str_key;
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copied", nil)];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
}

- (UITableView *)tableView{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[PrivateKeysCell class] forCellReuseIdentifier:NSStringFromClass(PrivateKeysCell.class)];
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
    }
    return _dataArray;
}


@end
