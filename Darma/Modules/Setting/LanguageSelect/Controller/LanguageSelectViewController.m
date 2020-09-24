


#import "LanguageSelectViewController.h"

#import "LanguageListCell.h"
#import "ChangeLanguage.h"

@interface LanguageSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation LanguageSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigateView.title =BITLocalizedCapString(@"Select Language", nil) ;
    [self addLayoutUI];
    
    dispatch_async(dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT), ^{
        
        for (int i=0; i<_dataArray.count; i++) {
            NSMutableArray *array =[NSMutableArray arrayWithArray:self.dataArray[i]];
            for (int j=0; j<array.count; j++) {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:array[j]];
                NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                NSString *currLanguage = [def valueForKey:@"LanguageName"];
                if ([currLanguage isEqualToString:dic[@"title"]]) {
                    [dic setValue:@"1" forKey:@"status"];
                    [array replaceObjectAtIndex:j withObject:dic];
                    [_dataArray replaceObjectAtIndex:i withObject:array];
                }
            }
        }
        
        
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
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LanguageListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LanguageListCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray *array = self.dataArray[indexPath.section];
    cell.dict=array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict=self.dataArray[indexPath.section][indexPath.row];
    NSString *languageName=dict[@"title"];
    if ([languageName isEqualToString:@"Chinese"]){
        
         [[ChangeLanguage shareInstance] setLanguage:@"zh-Hans"];
        
    }else if ([languageName isEqualToString:@"English"]){
        
         [[ChangeLanguage shareInstance] setLanguage:@"en"];
        
    }else if ([languageName isEqualToString:@"Japan"]){
        
        [[ChangeLanguage shareInstance] setLanguage:@"ja"];
        
    }else if ([languageName isEqualToString:@"한국"]){
        
        [[ChangeLanguage shareInstance] setLanguage:@"ko"];
        
    }else if ([languageName isEqualToString:@"España"]){
        
        [[ChangeLanguage shareInstance] setLanguage:@"es"];
        
    }else if ([languageName isEqualToString:@"España"]){
        
        [[ChangeLanguage shareInstance] setLanguage:@"es"];
        
    }else if ([languageName isEqualToString:@"Francais"]){
        
        [[ChangeLanguage shareInstance] setLanguage:@"fr"];
        
    }else if ([languageName isEqualToString:@"Deutsch"]){
        
        [[ChangeLanguage shareInstance] setLanguage:@"de"];
        
    }else if ([languageName isEqualToString:@"Italiano"]){
        
        [[ChangeLanguage shareInstance] setLanguage:@"it"];
        
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setValue:languageName forKey:@"LanguageName"];
        [def synchronize];

        for (int i=0; i<_dataArray.count; i++) {
            NSMutableArray *array =[NSMutableArray arrayWithArray:self.dataArray[i]];
            for (int j=0; j<array.count; j++) {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:array[j]];
                NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                NSString *currLanguage = [def valueForKey:@"LanguageName"];
                if ([currLanguage isEqualToString:dic[@"title"]]) {
                    [dic setValue:@"1" forKey:@"status"];
                    [array replaceObjectAtIndex:j withObject:dic];
                    [_dataArray replaceObjectAtIndex:i withObject:array];
                }else{
                    [dic setValue:@"0" forKey:@"status"];
                    [array replaceObjectAtIndex:j withObject:dic];
                    [_dataArray replaceObjectAtIndex:i withObject:array];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [hud hideAnimated:YES];
        });

    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage"object:self];
    

}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[LanguageListCell class] forCellReuseIdentifier:NSStringFromClass(LanguageListCell.class)];
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
