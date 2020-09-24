



#import "PaymentDetailsViewController.h"

#import "PaymentDetailsCell.h"
#import "PaymentDetailsAddressCell.h"

#import "DropDownView.h"
#import "YYText.h"
#import "CunstomMessageView.h"

#import "BlockBrowserViewController.h"
#import <SafariServices/SafariServices.h>

@interface PaymentDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,SelectDelegate>
@property(nonatomic, strong) DropDownView *moreView;

@property(nonatomic, strong) UIImageView *statusImageV;
@property(nonatomic, strong) UILabel *statusLabel;

@property(nonatomic, strong) NSDictionary *infoDict;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *addressArray;
@end

@implementation PaymentDetailsViewController
+ (PaymentDetailsViewController *)controllerWithDict:(NSDictionary *)dict
{
    PaymentDetailsViewController *controller = [[PaymentDetailsViewController alloc] init];
    controller.infoDict = dict;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Transaction details", nil) ;
    [self configRightButton];

    [self configUI];
}
- (void)configRightButton
{
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(moreSelect:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"add_button_nav"] forState:UIControlStateNormal];
    
    [moreBtn sizeToFit];
    [self.navigateView.contentView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigateView.contentView);
        make.right.equalTo(self.navigateView.contentView).offset(-10);
    }];
}

- (void)configUI
{
    [self.view addSubview:self.statusImageV];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.moreView];
    [_statusImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(40);
        make.width.height.mas_equalTo(Fit(36));
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.statusImageV.mas_bottom).offset(14);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.statusLabel.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-7);
        make.top.equalTo(self.navigateView.mas_bottom).offset(-15);
        make.width.mas_equalTo(145);
        make.height.mas_equalTo(175);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.dataArray.count;
    }else{
        return self.addressArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        PaymentDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PaymentDetailsCell.class)];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dic=self.dataArray[indexPath.row];
        if (indexPath.row==0) {
            UIButton *cpButton = [[UIButton alloc] init];
            [cpButton setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
            [cpButton addTarget:self action:@selector(copy:) forControlEvents:UIControlEventTouchUpInside];
            cpButton.tag = 120+indexPath.row;
            [cell.contentView addSubview:cpButton];
            [cpButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentLabel.mas_bottom);
                make.right.equalTo(cell.contentView).offset(FitW(-17));
                make.width.mas_equalTo(Fit(22));
                make.height.mas_equalTo(Fit(22));
            }];
        }
        return cell;
    }else{
        PaymentDetailsAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PaymentDetailsAddressCell.class)];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dic=self.addressArray[indexPath.row];
        return cell;
    }
}
- (void)moreSelect:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
        _moreView.hidden=NO;
    }else{
        _moreView.hidden=YES;
    }
    
}
- (void)copy:(UIButton *)sender
{
    NSString *str_txid=self.dataArray[sender.tag-120][@"content"];
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

-(void)commentTableViewTouchInSide{
    _moreView.hidden=YES;
}

-(void)dropDownSelectView:(DropDownView *)view clickIndex:(NSInteger)index{
    if (index==0) {


        

        NSURL *Url = [NSURL URLWithString:@"https://explorer.darmacash.com/m_tx?hash=ba22361b4941f229472e0688b6e23617dd47e6a40fb0ec89f38071d7fcc5339c"];

        SFSafariViewController *safariCon=[[SFSafariViewController alloc] initWithURL:Url];
        safariCon.DismissButtonStyle=SFSafariViewControllerDismissButtonStyleCancel;
        [self presentViewController:safariCon animated:YES completion:nil];
    }else if (index==1) {

        NSString *key=_infoDict[@"secret_tx_key"];
        BOOL iskey;
        if (key.length<=0) {
            key = BITLocalizedCapString(@"Tx private key is not found, it might be lost if you restore the wallet by seeds or keys.", nil);
            iskey=NO;
        }else{
            iskey=YES;
        }

        [CunstomMessageView showCustomViewTitle:BITLocalizedCapString(@"Tx key", nil) message:key isHaveCopy:iskey cancelClick:^{
            
        }];
    }else if (index==2) {
        [self share];
    }
}


-(UIImageView *)statusImageV{
    if (!_statusImageV) {
        _statusImageV=[[UIImageView alloc] init];
        NSString *status=[NSString stringWithFormat:@"%@",_infoDict[@"unlock_status"]];
        if ([status intValue]==0) {
            _statusImageV.image=[UIImage imageNamed:@"dealFinish"];

        }else if ([status intValue]==1){
            _statusImageV.image=[UIImage imageNamed:@"underWay"];
        }else if ([status intValue]==2){
            _statusImageV.image=[UIImage imageNamed:@"details_status_lock"];
        }
    }
    return _statusImageV;
}
-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel=[[UILabel alloc] init];
        NSString *status=[NSString stringWithFormat:@"%@",_infoDict[@"unlock_status"]];
        if ([status intValue]==0) {
            _statusLabel.text=BITLocalizedCapString(@"Transaction success", nil);

        }else if ([status intValue]==1){
            _statusLabel.text=BITLocalizedCapString(@"Pending", nil);
        }else if ([status intValue]==2){
            _statusLabel.text=BITLocalizedCapString(@"Transaction Locked", nil);
        }
        _statusLabel.textColor=[UIColor colorWithHexString:@"#202640"];
        _statusLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _statusLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _statusLabel;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[PaymentDetailsCell class] forCellReuseIdentifier:NSStringFromClass(PaymentDetailsCell.class)];
        [_tableView registerClass:[PaymentDetailsAddressCell class] forCellReuseIdentifier:NSStringFromClass(PaymentDetailsAddressCell.class)];

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
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:tableViewGesture];
    }
    return _tableView;
}

-(DropDownView *)moreView{
    if (!_moreView) {
        _moreView=[[DropDownView alloc] init];
        _moreView.hidden=YES;
        _moreView.delegate=self;
    }
    return _moreView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray=[[NSMutableArray alloc] init];
    
        NSString *status=[NSString stringWithFormat:@"%@",_infoDict[@"status"]];
        NSString *str_status;
        if ([status intValue]==0) {
            str_status =BITLocalizedCapString(@"Receive", nil);
        }else  if ([status intValue]==1){
            str_status =BITLocalizedCapString(@"Send", nil);
        }else{
            str_status =BITLocalizedCapString(@"", nil);
        }
        NSString *time=[NSString stringWithFormat:@"%@", _infoDict[@"time"]];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSDate *date =[formatter1 dateFromString:time];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *Time = [formatter2 stringFromDate:date ];
        NSDictionary *details=_infoDict[@"details"];

        NSUInteger amount=[_infoDict[@"amount"]integerValue];


        NSString *str_amount=[NSString stringWithFormat:@"%ld",(long)amount];
        NSString *str_fee=[NSString stringWithFormat:@"%@", details[@"fees"]];

        _dataArray=[NSMutableArray arrayWithArray:@[@{@"title":@"Transaction ID",@"content":_infoDict[@"txid"]},
                                                    @{@"title":@"Payment ID",@"content":_infoDict[@"payment_id_str"]},
                                                    @{@"title":@"Date",@"content":Time},
                                                    @{@"title":@"Amount",@"content":AppwalletFormat_Money(str_amount)},
                                                    @{@"title":@"Fee",@"content":AppwalletFormat_Money(str_fee)},
                                                    @{@"title":@"Height",@"content":_infoDict[@"height"]},
                                                    @{@"title":@"Type",@"content":str_status}]];
       
    }
    return _dataArray;
}
- (NSMutableArray *)addressArray
{
    if (!_addressArray)
    {
        _addressArray=[[NSMutableArray alloc] init];

        NSDictionary *details=_infoDict[@"details"];
        NSArray *address=details[@"to"];
        for (int i=0; i<address.count; i++) {
             NSString *title=[NSString stringWithFormat:@"%@%i",BITLocalizedCapString(@"转出地址",nil),i+1] ;
             NSString *str_address=address[i];
             NSString *str_amount= [NSString stringWithFormat:@"%@",details[@"amount"][i]];
            str_amount=AppwalletFormat_Money(str_amount);
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            [dict setObject:title forKey:@"title"];
            [dict setObject:str_address forKey:@"address"];
            [dict setObject:str_amount forKey:@"amount"];
            
            [_addressArray addObject:dict];
        }
        


    }
    return _addressArray;
}
@end
