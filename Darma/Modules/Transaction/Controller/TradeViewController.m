


#import "TradeViewController.h"

#import "TopSendView.h"

#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import "AddressListViewController.h"

#import "RequestAPIManager.h"
#import "NSString+BITTool.h"

#import "TradeDetailsViewController.h"
#import "TradeRecordViewController.h"

@interface TradeViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)TopSendView *topView;
@property (nonatomic,strong)TopSendView *bottomView;
@property(nonatomic, strong) UIButton *changeBtn;
@property(nonatomic, strong) UILabel *exchangePriceLable;
@property(nonatomic, strong) UIButton *sureBtn;

@property(nonatomic, assign) BOOL isChange;
@property(nonatomic, strong) NSString * coinName1;
@property(nonatomic, strong) NSString * coinName2;

@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, assign) BOOL timerStauts;

@property(nonatomic, strong) NSString * exchangeNum;
@property(nonatomic, strong) NSString * walletAddress;

@property(nonatomic, assign) BOOL isTopScan;
@property(nonatomic, strong) NSString * maxnum;
@property(nonatomic, strong) NSString * minnum;
@end

@implementation TradeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resume];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self pauseGCD];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self closeGCD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigateView.title =BITLocalizedCapString(@"Exchange",nil);
    self.navigateView.backButton.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configRightButton];
    _isChange=NO;
    _coinName1=@"dmc";
    _coinName2=@"usdt";
    [self addUIAndLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanInfo:) name:@"tradeAddress" object:nil];

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
-(void)addUIAndLayout{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.changeBtn];
    [self.view addSubview:self.exchangePriceLable];
    [self.view addSubview:self.sureBtn];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(FitH(10));
        make.height.mas_equalTo(FitH(200));
    }];
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(FitH(2));
        make.centerX.equalTo(self.view);
        make.height.width.mas_equalTo(Fit(30));
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeBtn.mas_bottom).offset(FitH(2));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(FitH(200));
    }];
    [_exchangePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(FitW(8));
        make.left.equalTo(self.view).offset(FitW(20));
        make.right.equalTo(self.view).offset(-FitW(20));
        make.height.mas_equalTo(Fit(20));
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FitW(18));
        make.right.equalTo(self.view).offset(-FitW(18));
        make.height.mas_equalTo(FitH(48));
        make.top.equalTo(self.exchangePriceLable.mas_bottom).offset(FitH(10));
    }];
    [self getRequest:_coinName1 coinTwo:_coinName2];
    [self stardGCD];
}

- (void)stardGCD
{
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer =  dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    uint64_t interval= 3.0 * NSEC_PER_SEC;
    dispatch_source_set_timer(_timer, start, interval, 0);
    dispatch_source_set_event_handler(_timer, ^{
         NSLog(@"timer fired");
        [self getRequest:_coinName1 coinTwo:_coinName2];
    });
    [self resume];
}

- (void)pauseGCD
{
    
    if (_timerStauts &&  _timer)
    {
        dispatch_suspend(_timer); 
        _timerStauts = NO;
        
    }
}

- (void)resume
{
    
    if (!_timerStauts && _timer)
    {
        dispatch_resume(_timer);
        _timerStauts = YES;
        
    }
}

- (void)closeGCD
{
    
    if (_timer)
    {
        dispatch_source_cancel(_timer);
        
        _timer = nil;
        _timerStauts = NO;
        
    }
}


-(void)getRequest:(NSString *)coinOne coinTwo:(NSString *)coinTwo{
    RequestAPIManager *manager=[[RequestAPIManager alloc] init];
    [manager GETRequestRate:coinOne coinName2:coinTwo success:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
        _exchangeNum=dic[@"price"];
        _minnum=[NSString stringWithFormat:@"%@",dic[@"quota_lower_limit"]];
        _maxnum=[NSString stringWithFormat:@"%@",dic[@"quota_upper_limit"]];
        if (_isChange==YES) {
            _bottomView.tipLable.text=[NSString stringWithFormat:@"%@%@ %@",@"min：",_minnum,[_coinName2 uppercaseString]];
            _bottomView.tip2Lable.text=[NSString stringWithFormat:@"%@%@ %@",@"max：",_maxnum,[_coinName2 uppercaseString]];
            _exchangePriceLable.text=[NSString stringWithFormat:@"1 %@ = %@ %@",[_coinName1 uppercaseString],_exchangeNum,[_coinName2 uppercaseString]];
       
        }else{
            _bottomView.tipLable.text=[NSString stringWithFormat:@"%@%@ %@",@"min：",_minnum,[_coinName2 uppercaseString]];
            _bottomView.tip2Lable.text=[NSString stringWithFormat:@"%@%@ %@",@"max：",_maxnum,[_coinName2 uppercaseString]];
            _exchangePriceLable.text=[NSString stringWithFormat:@"1 %@ = %@ %@",[_coinName1 uppercaseString],_exchangeNum,[_coinName2 uppercaseString]];
        
        }
        NSString * code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message=[NSString stringWithFormat:@"%@",responseObject[@"message"]];

        if ([code intValue]==400) {
            _sureBtn.userInteractionEnabled=NO;
            [_sureBtn setTitle:BITLocalizedCapString(@"str_exchange_funtion_is_not_open",nil) forState:UIControlStateNormal];
            _sureBtn.backgroundColor=[UIColor lightGrayColor];
        }else{
            _sureBtn.userInteractionEnabled=YES;
            [_sureBtn setTitle:BITLocalizedCapString(@"Exchange",nil) forState:UIControlStateNormal];
            _sureBtn.backgroundColor=[UIColor colorWithHexString:@"#F1FAFA"];
        }
    } fail:^(NSURLSessionDataTask * task, NSError * error) {
        [SHOWProgressHUD showMessage:error.domain];
        _sureBtn.userInteractionEnabled=NO;
        [_sureBtn setTitle:BITLocalizedCapString(@"str_exchange_funtion_is_not_open",nil) forState:UIControlStateNormal];
        _sureBtn.backgroundColor=[UIColor lightGrayColor];
    }];
    
}
-(void)createOrderRequest{
    RequestAPIManager *manager=[[RequestAPIManager alloc] init];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    NSString *string=[NSString stringWithFormat:@"%@_%@",_coinName1,_coinName2];
    if (_topView.addressField.text.length<=0) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"str_please_input_transfer_address",nil)];
        return;
    }
    if (_bottomView.amountField.text.length<=0) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"str_please_input_target_addree",nil)];
        return;
    }else if ([_bottomView.amountField.text integerValue]>[_maxnum integerValue]){
         [SHOWProgressHUD showMessage:BITLocalizedCapString(@"str_transferable_amounts_notice",nil)];
        return;
    }else if ([_bottomView.amountField.text integerValue]<[_minnum integerValue]){
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"str_transferable_amounts_notice",nil)];
        return;
    }
    if (_bottomView.addressField.text.length<=0) {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"str_input_destination_address",nil)];
        return;
    }
    
    [dic setValue:string forKey:@"pair"];
    [dic setValue:_topView.addressField.text forKey:@"base_src_address"];
    [dic setValue:_bottomView.amountField.text forKey:@"quota_amount"];
    [dic setValue:_bottomView.addressField.text forKey:@"quota_dest_address"];
    [manager POSTRequestCreateOrder:dic success:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
        NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code intValue]==200) {
            TradeDetailsViewController *con=[[TradeDetailsViewController alloc] init];
            con.orderID=[NSString stringWithFormat:@"%@",dic[@"order_id"]];
            if (_isChange==YES) {
                con.checkType=@"USDT-DMC";
            }else{
                con.checkType=@"DMC-USDT";
            }
            [self.navigationController pushViewController:con animated:YES];
        }else{
             [SHOWProgressHUD showMessage:responseObject[@"message"]];
        }
    } fail:^(NSURLSessionDataTask * task, NSError * error) {
         [SHOWProgressHUD showMessage:error.domain];
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (_isChange) {
        if (textField==_bottomView.addressField) {
            _walletAddress=[_bottomView.addressField.text stringByAppendingString:string];
        }
    }else{
        if (textField==_topView.addressField) {
            _walletAddress=[_topView.addressField.text stringByAppendingString:string];
        }
    }
    NSString *mut = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField==_topView.amountField) {
        NSString *price=[NSString stringWithFormat:@"%@",mut];
        _bottomView.amountField.text=[price bitMul:_exchangeNum round:4];
    }else if (textField==_bottomView.amountField) {
        NSString *price=[NSString stringWithFormat:@"%@",mut];
        _topView.amountField.text=[price div:_exchangeNum round:4];
    }
   
    return YES;
}
- (void)rightBtn:(UIButton *)sender
{
    TradeRecordViewController *con=[[TradeRecordViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}
-(void)change:(UIButton *)sender{
    sender.selected=!sender.selected;
    if (sender.selected) {
        _coinName1=@"usdt";
        _coinName2=@"dmc";


        
        _isChange=YES;
        _topView.walletNameLable.hidden=YES;
        _bottomView.walletNameLable.hidden=NO;

        _topView.coinNameLable.text=[_coinName1 uppercaseString];
        _topView.tipLable.text=[NSString stringWithFormat:@"min：0.00 %@",[_coinName1 uppercaseString]];
        _topView.tip2Lable.text=[NSString stringWithFormat:@"max：0.00 %@",[_coinName1 uppercaseString]];
        
        _topView.walletNameLable.text=@"";

        _topView.addressField.text=_bottomView.addressField.text;
        _bottomView.addressField.text=_walletAddress;

        _bottomView.coinNameLable.text=[_coinName2 uppercaseString];
        _bottomView.tipLable.text=[NSString stringWithFormat:@"min：0.00 %@",[_coinName2 uppercaseString]];
        _bottomView.tip2Lable.text=[NSString stringWithFormat:@"max：0.00 %@",[_coinName2 uppercaseString]];
        _bottomView.walletNameLable.text=[[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
        

        [self getRequest:_coinName1 coinTwo:_coinName2];
        
        NSString *topPrice=[NSString stringWithFormat:@"%@",_topView.amountField.text];
        NSString *bottomPrice=[NSString stringWithFormat:@"%@",_bottomView.amountField.text];
        _topView.amountField.text=[topPrice bitMul:_exchangeNum round:4];
        _bottomView.amountField.text=[bottomPrice div:_exchangeNum round:4];

    }else{
        _coinName1=@"dmc";
        _coinName2=@"usdt";


        
        _isChange=NO;
        _topView.walletNameLable.hidden=NO;
        _bottomView.walletNameLable.hidden=YES;

        _topView.coinNameLable.text=[_coinName1 uppercaseString];
        _topView.tipLable.text=[NSString stringWithFormat:@"min：0.00 %@",[_coinName1 uppercaseString]];
        _topView.tip2Lable.text=[NSString stringWithFormat:@"max：0.00 %@",[_coinName1 uppercaseString]];
        _topView.walletNameLable.text=[[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];

        _bottomView.addressField.text=_topView.addressField.text;
        _topView.addressField.text=_walletAddress;

        _bottomView.coinNameLable.text=[_coinName2 uppercaseString];
        _bottomView.tipLable.text=[NSString stringWithFormat:@"min：0.00 %@",[_coinName2 uppercaseString]];
        _bottomView.tip2Lable.text=[NSString stringWithFormat:@"max：0.00 %@",[_coinName2 uppercaseString]];
        _bottomView.walletNameLable.text=@"";
        

        [self getRequest:_coinName1 coinTwo:_coinName2];
        
        NSString *topPrice=[NSString stringWithFormat:@"%@",_topView.amountField.text];
        NSString *bottomPrice=[NSString stringWithFormat:@"%@",_bottomView.amountField.text];
        _topView.amountField.text=[topPrice bitMul:_exchangeNum round:4];
        _bottomView.amountField.text=[bottomPrice div:_exchangeNum round:4];

    }
    
    
}
- (void)scan:(UIButton *)sender
{
    if (sender.tag==100) {
        _isTopScan=YES;
    }else if (sender.tag==200){
        _isTopScan=NO;
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                } else {
                    
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized)
        { 
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { 
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Warm remind", nil) message:BITLocalizedCapString(@"Please go to [settings-privacy-camera-DARMA] to turn on the access switch", nil) preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"Unable to access the album due to system reasons");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:BITLocalizedCapString(@"Warm remind", nil) message:BITLocalizedCapString(@"Your camera is not detected", nil) preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:BITLocalizedCapString(@"Confirm", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

-(void)scanInfo:(NSNotification * )info{
    NSDictionary *dic=[info userInfo];
    NSString *address=dic[@"address"];
    
    
    
    if (_isTopScan==YES) {
        _topView.addressField.text=address;
    }else{
        _bottomView.addressField.text=address;
    }
    
}

- (void)selectAddress:(UIButton *)sender
{

    AddressListViewController*controller = [[AddressListViewController alloc] init];
    
    if (sender.tag==110) {
        controller.coinName=_coinName1;
    }else if (sender.tag==210){
        controller.coinName=_coinName2;
    }
    controller.hidesBottomBarWhenPushed = YES;
    controller.info = ^(NSDictionary * _Nonnull dict) {
        NSString *address=dict[@"walletAddress"];

        if (sender.tag==110) {
            _topView.addressField.text=address;
        }else if (sender.tag==210){
            _bottomView.addressField.text=address;
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)sureClick:(UIButton *)sender{
    [self createOrderRequest];
}

-(TopSendView*)topView{
    if (!_topView) {
        _topView=[[TopSendView alloc] init];
        _topView.titleLable.text=BITLocalizedCapString(@"You will send", nil);

        _topView.coinNameLable.text=[_coinName1 uppercaseString];
        _topView.walletNameLable.hidden=NO;
        _topView.walletNameLable.text=[[NSUserDefaults standardUserDefaults] objectForKey:currentWalletNameKey];
        _topView.tipLable.hidden=YES;
        _topView.tip2Lable.hidden=YES;

        _topView.tipLable.text=[NSString stringWithFormat:@"min：0.00 %@",[_coinName1 uppercaseString]];
        _topView.amountField.delegate=self;
        _topView.amountField.keyboardType=UIKeyboardTypeDecimalPad;
        _topView.addressField.delegate=self;
        _walletAddress=[[MobileWalletSDKManger shareInstance] walletAddress];
        _topView.addressField.text=_walletAddress;
        _topView.scanButton.tag=100;
        _topView.selectAddress.tag=110;

        [_topView.scanButton addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.selectAddress addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}
- (UIButton *)changeBtn
{
    if (!_changeBtn)
    {
        _changeBtn = [[UIButton alloc] init];
        [_changeBtn setImage:[UIImage imageNamed:@"trade_exchange_btn"] forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

-(TopSendView*)bottomView{
    if (!_bottomView) {
        _bottomView=[[TopSendView alloc] init];
        _bottomView.titleLable.text=BITLocalizedCapString(@"You will get",nil);

        _bottomView.coinNameLable.text=[_coinName2 uppercaseString];
        _bottomView.walletNameLable.hidden=YES;
        _bottomView.tip2Lable.hidden=NO;


        _bottomView.tipLable.text=[NSString stringWithFormat:@"min：0.00 %@",[_coinName2 uppercaseString]];
        _bottomView.tip2Lable.text=[NSString stringWithFormat:@"max：0.00 %@",[_coinName2 uppercaseString]];
        _bottomView.amountField.delegate=self;
        _bottomView.amountField.keyboardType=UIKeyboardTypeDecimalPad;
        _bottomView.addressField.delegate=self;
        _bottomView.scanButton.tag=200;
        _bottomView.selectAddress.tag=210;
        [_bottomView.scanButton addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.selectAddress addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
-(UILabel*)exchangePriceLable{
    if (!_exchangePriceLable) {
        _exchangePriceLable=[[UILabel alloc] init];
        _exchangePriceLable.textColor=[UIColor colorWithHexString:@"#9CA8B3"];
        _exchangePriceLable.font = [UIFont systemFontOfSize:14];
        _exchangePriceLable.textAlignment=NSTextAlignmentCenter;

        _exchangePriceLable.text=[NSString stringWithFormat:@"0.00 %@ = 0.00 %@",[_coinName1 uppercaseString],[_coinName1 uppercaseString]];

    }
    return _exchangePriceLable;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn)
    {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor=[UIColor colorWithHexString:@"#F1FAFA"];
        _sureBtn.layer.borderWidth=1;
        _sureBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _sureBtn.layer.cornerRadius=8;
        [_sureBtn setTitle:BITLocalizedCapString(@"Exchange",nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}



@end
