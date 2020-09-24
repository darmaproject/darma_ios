


#import "TradeDetailsViewController.h"

#import "TradeDetailsHeadQrCodeView.h"
#import "TradeDetailsBottomView.h"
#import "RequestAPIManager.h"
#import "TradeDetailsModel.h"

#import "CustomActionView.h"

#import "PaymentVerifyViewController.h"
#import "TradeOrderDetailsViewController.h"
#import "PaymentManager.h"

@interface TradeDetailsViewController ()<TradeDetailsBottomViewDelegate>
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) TradeDetailsHeadQrCodeView *topView;
@property(nonatomic, strong) TradeDetailsBottomView *bottomView;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) TradeDetailsModel *model;
@property(nonatomic, strong) NSString *sureBtnTitle;

@end

@implementation TradeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigateView.title =BITLocalizedCapString(@"Trade details", nil) ;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUIAndLayout];
    [self orderDetailRequest];
}
-(void)addUIAndLayout{
    [self.view addSubview:self.sureBtn];

    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentView];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FitW(18) );
        make.right.equalTo(self.view).offset(FitW(-18));
        make.height.mas_equalTo(FitH(48));
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(FitH(-12));
    }];
    
    
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(FitH(10));
        make.bottom.equalTo(self.sureBtn.mas_top).offset(FitH(-10));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.mainScrollView);
        make.centerX.equalTo(self.mainScrollView);
        make.height.mas_equalTo(Height);
    }];
    [self.contentView addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(FitH(160));
    }];
    
    [self.contentView addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(FitH(302));
        make.bottom.equalTo(self.contentView);
    }];
}

-(void)orderDetailRequest{
    RequestAPIManager *manager=[[RequestAPIManager alloc] init];
    [manager GETRequestQueryOrder:_orderID success:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
        if (dic) {
            _model=[TradeDetailsModel  yy_modelWithDictionary:dic];
            _topView.model=_model;
            _bottomView.model=_model;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray* dataArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:TradeRecordKey]];
            if (dataArray.count>=1024) {
    
                [dataArray removeLastObject];
            }
            [dataArray insertObject:dic atIndex:0];
    
            
            [defaults setObject:dataArray forKey:TradeRecordKey];
            [defaults synchronize];
        }else{
            [SHOWProgressHUD showMessage:responseObject[@"message"]];
        }
    } fail:^(NSURLSessionDataTask * task, NSError * error) {
        [SHOWProgressHUD showMessage:error.domain];
    }];
    
}
-(void)sureClick:(UIButton *)sender{
    if ([_sureBtnTitle isEqualToString:BITLocalizedCapString(@"str_input_destination_address", nil)]) {
        TradeOrderDetailsViewController*controller = [[TradeOrderDetailsViewController alloc] init];
        controller.orderID=_orderID;
        [self.navigationController pushViewController:controller animated:YES];
    }else{


        
        PaymentManager *manager=[[PaymentManager alloc] init];
        [manager transfer:_model.base_receiving_integrated_address amountstr:_model.base_amount_total unlock_time_str:@"0" payment_id:@"" mixin:0 sendtx:NO password:@"" isAll:NO success:^(NSDictionary * _Nonnull transferInfo) {
            PaymentVerifyViewController*controller = [[PaymentVerifyViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.dicInfo=transferInfo;
            controller.address=_model.base_receiving_integrated_address;
            controller.paymentID=@"";
            controller.orderID=_model.order_id;
            controller.className=@"TradeDetailsViewController";
            [self.navigationController pushViewController:controller animated:YES];
            
        } fail:^(NSDictionary * _Nonnull error) {
            NSString *errCode=[NSString  stringWithFormat:@"%@",error[@"errCode"]];
            if ([errCode intValue]==1007) {
                CustomActionView *actionV = [[CustomActionView alloc] init];
                actionV.frame = CGRectMake(0, 0, Width, Height);
                [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:actionV];
                
                actionV.title=BITLocalizedCapString(@"Enter the password",nil);
                actionV.placeholder=BITLocalizedCapString(@"Please enter password",nil);
                actionV.determineBlock = ^(NSString * _Nonnull string) {
                    [manager transfer:_model.base_receiving_integrated_address amountstr:_model.base_amount_total unlock_time_str:@"0" payment_id:@"" mixin:0 sendtx:NO password:string isAll:NO success:^(NSDictionary * _Nonnull transferInfo) {
                        PaymentVerifyViewController*controller = [[PaymentVerifyViewController alloc] init];
                        controller.hidesBottomBarWhenPushed = YES;
                        controller.dicInfo=transferInfo;
                        controller.address=_model.base_receiving_integrated_address;
                        controller.paymentID=@"";
                        controller.orderID=_model.order_id;
                        controller.className=@"TradeDetailsViewController";
                        [self.navigationController pushViewController:controller animated:YES];
                        
                    } fail:^(NSDictionary * _Nonnull error) {
                        [SHOWProgressHUD showMessage:error[@"errMsg"]];
                    }];
                };
            }else{
                [SHOWProgressHUD showMessage:error[@"errMsg"]];
            }
        }];
    }

}
    


-(void)Timeout:(TradeDetailsBottomView *)bottomView{
    _sureBtnTitle=BITLocalizedCapString(@"str_input_destination_address", nil);
    [_sureBtn setTitle:BITLocalizedCapString(@"str_input_destination_address", nil) forState:UIControlStateNormal];

}


- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView)
    {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.alwaysBounceVertical = YES;
        
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _mainScrollView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView  alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (TradeDetailsHeadQrCodeView *)topView
{
    if (!_topView)
    {
        _topView = [[TradeDetailsHeadQrCodeView alloc] init];
        _topView.backgroundColor=[UIColor whiteColor];
    }
    return _topView;
}
- (TradeDetailsBottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[TradeDetailsBottomView alloc] init];
        _bottomView.backgroundColor=[UIColor whiteColor];
        _bottomView.delegate=self;
    }
    return _bottomView;
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
        if ([_checkType isEqualToString:@"DMC-USDT"]) {
            [_sureBtn setTitle:BITLocalizedCapString(@"Pay Now", nil) forState:UIControlStateNormal];
            _sureBtnTitle=BITLocalizedCapString(@"Pay Now", nil);
        }else{
            [_sureBtn setTitle:BITLocalizedCapString(@"str_input_destination_address", nil) forState:UIControlStateNormal];
            _sureBtnTitle=BITLocalizedCapString(@"str_input_destination_address", nil);
        }
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
