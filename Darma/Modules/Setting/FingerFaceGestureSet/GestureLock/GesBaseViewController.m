



#import "GesBaseViewController.h"

@interface GesBaseViewController ()<ContentVieDelegate>

@end

@implementation GesBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.view.backgroundColor = RECT_VCBACKGROUND;

    [self createUI];
    
    [self addUI];

}

- (void)createUI{
    CGFloat w = RECT_WEIGHT*3 + FitW(40)+ RECT_RADIUS_SPACE *2;
    self.gesView = [[ContentView alloc]initWithFrame:CGRectMake(0, 0, w, w)];
    self.gesView.delegate  = self;
    self.gesView.center = CGPointMake(self.view.center.x, self.view.center.y+FitH(50));
    [self.view addSubview:self.gesView];
    
    self.tipText = [[TipLable alloc]initWithFrame:CGRectMake(0, self.gesView.frame.origin.y-FitH(30) , S_WIDTH, FitH(30))];
    self.tipText.font = [UIFont systemFontOfSize:14];
    self.tipText.textAlignment = 1;
    self.tipText.textColor = [UIColor redColor];
    [self.view addSubview:self.tipText];
}

- (void)selectedWithNum:(NSString *)str{
    
    
    if (str.length < 4) {
        self.passStr = @"";
        [self.tipText setFaildWithNSString: BITLocalizedCapString(@"Please connect at least 4 points",nil)];

    }else{
        self.passStr = [NSString stringWithFormat:@"%@",str];
        [self nextRequest];
    }
}

- (void)nextRequest{
    
}
    
- (void)addUI{
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
