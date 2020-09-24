


#import "SetGesViewController.h"

#import "SetHeadView.h"
@interface SetGesViewController ()

@property (nonatomic,strong)NSString *firstNun;
@property (nonatomic,strong)NSString *SecontNun;
@property (nonatomic,assign)BOOL isFirstSet;
@property (nonatomic,strong)SetHeadView *headView;
@end
@implementation SetGesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *title = BITLocalizedCapString(@"set gesture code", nil);
    self.navigateView.title = title;
    self.isFirstSet = YES;
}

- (void)addUI{
    
    [self.tipText setDefaultWithNSString: BITLocalizedCapString(@"Please create gesture unlock", nil)];
   
    [self.view addSubview:self.headView];
    
}
- (void)nextRequest{
    if (self.isFirstSet) {
        self.firstNun = [NSString stringWithFormat:@"%@",self.passStr];
        self.isFirstSet = NO;
        [self.headView refreshWithString:self.firstNun];
        [self.tipText setDefaultWithNSString:BITLocalizedCapString(@"Please repeat", nil)];

    }else{
        
        if ([self.passStr isEqualToString:self.firstNun]) {
            
            self.tipText.text = @"";
            if (self.delegate && [self.delegate respondsToSelector:@selector(getGesPass:)]) {
                [self.delegate getGesPass:self.firstNun];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }else{
            
            [self.tipText setFaildWithNSString: BITLocalizedCapString(@"Not match. Please draw it again.", nil)];
            [self.headView defult];
            self.isFirstSet = YES;
        }
    }
}


- (SetHeadView *)headView{
    if (!_headView) {
        CGFloat w = RECT_WEIGHT*3 + 40+ RECT_RADIUS_SPACE *2;
        CGFloat y = self.view.center.y-w/2-50;
        self.headView = [[SetHeadView alloc]initWithFrame:CGRectMake(0 , 0, 60, 60)];
        self.headView.center = CGPointMake(self.view.center.x, y+20);
    }
    return _headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
