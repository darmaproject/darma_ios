



#import "SGQRCodeScanningVC.h"

#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "PaymentViewController.h"
#import "AddAdressViewController.h"
#import "TradeViewController.h"
#import "BaseTabBarController.h"

@interface SGQRCodeScanningVC () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation SGQRCodeScanningVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [_manager cancelSampleBufferDelegate];
}

- (void)dealloc {
    NSLog(@"SGQRCodeScanningVC - dealloc");
    [self removeScanningView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tradeAddress" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    [self setupNavigationBar];
    [self setupQRCodeScanning];
    [self.view addSubview:self.promptLabel];
    
    [self.view addSubview:self.bottomView];
}

- (void)setupNavigationBar {
    self.navigateView.title =BITLocalizedCapString(@"RichScan", nil);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:BITLocalizedCapString(@"Photo Album", nil) forState:UIControlStateNormal];
    [self.navigateView.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button.superview);
        make.right.equalTo(button.superview).offset(Fit(-10));
    }];
    [button addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];

}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, KNAVIGATE_HEIGHT, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;

    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];

    _manager.delegate = self;
}


- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    NSArray *vcArray = self.navigationController.viewControllers;
    NSArray* reversedArray = [[vcArray reverseObjectEnumerator] allObjects];
    for (UIViewController *controller in reversedArray) {
        if ([controller isKindOfClass:[PaymentViewController class]]) {
            PaymentViewController *revise =(PaymentViewController *)controller;

            
            revise.addressInput = result;
            [self.navigationController popToViewController:revise animated:YES];
             return;
        }
    }
    


}


- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager palySoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.jump_URL = [obj stringValue];
        NSString* string = [obj stringValue];;
        NSArray *vcArray = self.navigationController.viewControllers;
        NSArray* reversedArray = [[vcArray reverseObjectEnumerator] allObjects];
        for (UIViewController *controller in reversedArray) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

            if ([Tool isUrlAddress:string]) {
                NSURL * url=[NSURL URLWithString:string];
                
                NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
                
                
                [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dic setObject:obj.value forKey:obj.name];
                }];
                
                NSRange pp =[string rangeOfString:@"?"];
                
                NSString *addressAndName= [string substringToIndex:pp.location];
                NSArray *arry=[addressAndName componentsSeparatedByString:@":"];
                NSString *WalletName= [arry firstObject];
                NSString *address= [arry lastObject];
                
                [dic setObject:WalletName forKey:@"WalletName"];
                [dic setObject:address forKey:@"address"];
            }else{
                [dic setObject:@"" forKey:@"WalletName"];
                [dic setObject:string forKey:@"address"];
            }
            if ([controller isKindOfClass:[PaymentViewController class]]) {
                
                
                PaymentViewController *revise =(PaymentViewController *)controller;
                revise.scanInfo = dic;
                [self.navigationController popToViewController:revise animated:YES];
                return;
            }else if ([controller isKindOfClass:[AddAdressViewController class]]){
                AddAdressViewController*revise =(AddAdressViewController *)controller;
                
                revise.scanInfo = dic;
                [self.navigationController popToViewController:revise animated:YES];
                return;
            }else if ([controller isKindOfClass:[BaseTabBarController class]]){
                
              BaseTabBarController * TabBar=[[BaseTabBarController alloc] init];
                TabBar=(BaseTabBarController *)controller;
                if ([TabBar.selectedViewController isKindOfClass:[TradeViewController class]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tradeAddress" object:nil userInfo:dic];
                }
                [self.navigationController popToViewController:TabBar animated:YES];
                return;
            }
        }
    } else {
    }
}

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < - 1) {
        [self.view addSubview:self.flashlightBtn];
    } else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text =BITLocalizedCapString(@"Put the qr code/barcode into the box, and it can be scanned automatically", nil);
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}


- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SGQRCodeHelperTool SG_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}


@end

