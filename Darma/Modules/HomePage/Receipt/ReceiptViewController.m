



#import "ReceiptViewController.h"

#import "ReceiptTopView.h"


@interface ReceiptViewController ()
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) ReceiptTopView* infoView;
@property(nonatomic, strong) NSString * walletAddressStr;

@end

@implementation ReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Receive", nil) ;
    self.navigateView.backgroundImage.hidden=YES;

    [self configRightButton];

    [self addLayoutUI];
    _walletAddressStr=[[MobileWalletSDKManger shareInstance] walletAddress];
    [_infoView  createPamentID:nil walletaAddress:_walletAddressStr isCreat:NO];
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
- (void)addLayoutUI
{
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentView];
    _contentView.backgroundColor = [UIColor whiteColor];
    
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigateView.mas_bottom).offset(1);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(Fit(-12));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.mainScrollView);
        make.centerX.equalTo(self.mainScrollView);
        make.height.mas_equalTo(Height);
    }];
    
    [self.contentView addSubview:self.infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);

    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        _infoView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _infoView.layer.shadowOffset = CGSizeMake(0,0);
        _infoView.layer.shadowRadius = 20;
        _infoView.layer.shadowOpacity = 0.07;
        _infoView.layer.masksToBounds = NO;
        UIBezierPath *path=[UIBezierPath bezierPathWithRect:CGRectMake(0,_infoView.bottom, Width, 20)];
        _infoView.layer.shadowPath=path.CGPath;
    });
}
-(void)createPaymentId:(UIButton *)sender{
    
    NSString *str_32bitIntegrated=  [[MobileWalletSDKManger shareInstance] Generate_Intergrated_Address:32];
    
    NSDictionary *dic=[[MobileWalletSDKManger shareInstance] Verify_Address:str_32bitIntegrated];
    
    [_infoView createPamentID:dic walletaAddress:_walletAddressStr isCreat:YES];
    
    [self.infoView removeFromSuperview];
    [self.contentView addSubview:self.infoView];

    [_infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        _infoView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _infoView.layer.shadowOffset = CGSizeMake(0,0);
        _infoView.layer.shadowRadius = 20;
        _infoView.layer.shadowOpacity = 0.07;
        _infoView.layer.masksToBounds = NO;
        UIBezierPath *path=[UIBezierPath bezierPathWithRect:CGRectMake(0,_infoView.bottom, Width, 20)];
        _infoView.layer.shadowPath=path.CGPath;
    });
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
        _contentView = [UIView new];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (ReceiptTopView *)infoView
{
    if (!_infoView)
    {
        _infoView = [[ReceiptTopView alloc] init];
        _infoView.backgroundColor=[UIColor whiteColor];
        [_infoView.createPaymentIdButton addTarget:self action:@selector(createPaymentId:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _infoView;
}
@end
