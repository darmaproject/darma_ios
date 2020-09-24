

#import "PaymentFinishViewController.h"

#import "PaymentFinishCell.h"

@interface PaymentFinishViewController ()<UITableViewDataSource,UITableViewDelegate,BaseNavigateViewDelegate>
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIImageView *statuImageView;
@property(nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation PaymentFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Transaction success", nil);
    
    self.navigateView.delegate = self;
    [self configRightButton];
    [self addLayoutUI];
    
}
- (void)configRightButton
{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
    [shareBtn sizeToFit];
    [self.navigateView.contentView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.right.equalTo(self.navigateView.contentView).offset(-10);
    }];
}
-(void)share
{
    UIImage *imageToShare = [self imageWithScreenshot];
    
    
    
    NSArray *activityItems = @[imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    UIActivityViewControllerCompletionWithItemsHandler completionHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            
        }else{
            
        }
    };
    activityVC.completionWithItemsHandler = completionHandler;
}

- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

-(void)navigateViewClickBack:(BaseNavigateView *)view{
    UIViewController *vc=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4];
    [self.navigationController popToViewController:vc animated:YES];

}
- (void)addLayoutUI
{
    [self.view addSubview:self.statuImageView];
    [_statuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(FitH(20));
        make.height.width.equalTo(@(FitH(45)));
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        make.top.equalTo(self.statuImageView.mas_bottom).offset(11);
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
    PaymentFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PaymentFinishCell.class)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.row==0) {
        
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
    cell.dic=self.dataArray[indexPath.row];
    
    return cell;
}
- (void)buttonClick:(UIButton *)sender
{
    NSString *str_txid=self.dataArray[sender.tag-10][@"content"];
    if (str_txid.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str_txid;
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
        [_tableView registerClass:[PaymentFinishCell class] forCellReuseIdentifier:NSStringFromClass(PaymentFinishCell.class)];
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
- (UIImageView *)statuImageView
{
    if (!_statuImageView)
    {
        _statuImageView = [[UIImageView alloc] init];
        _statuImageView.image=[UIImage imageNamed:@"dealFinish"];
    }
    return _statuImageView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc] init];
        NSString *amount=AppwalletFormat_Money([NSString stringWithFormat:@"%@",_dicInfo[@"amount"]]);
        NSString *fee=AppwalletFormat_Money([NSString stringWithFormat:@"%@",_dicInfo[@"fee"]]);
        
        _dataArray=[NSMutableArray arrayWithArray:@[@{@"title":@"TXID",@"content":_txid},
                                                    @{@"title":@"Payment ID",@"content":_paymentID},
                                                    @{@"title":@"Amount",@"content":amount},
                                                    @{@"title":@"Fee",@"content":fee},
                                                    @{@"title":@"Remark",@"content":@""}]];

    }
    return _dataArray;
}


@end
