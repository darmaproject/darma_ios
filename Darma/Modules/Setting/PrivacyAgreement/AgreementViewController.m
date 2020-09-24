





#import "AgreementViewController.h"

@interface AgreementViewController ()< UIWebViewDelegate>


@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Privacy Policy", nil) ;
   
    [self addLayoutUI];
}
- (void)addLayoutUI
{
    
    UIWebView *Mywebview = [[UIWebView alloc]init];
    Mywebview.delegate = self;
    [self.view addSubview:Mywebview];
    [Mywebview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"agreement"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [Mywebview loadHTMLString:htmlCont baseURL:baseURL];

}


@end
