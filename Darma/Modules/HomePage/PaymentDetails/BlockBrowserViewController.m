




#import "BlockBrowserViewController.h"

#import <WebKit/WebKit.h>
@interface BlockBrowserViewController ()
@property(nonatomic, strong) WKWebView *webView;

@end

@implementation BlockBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Block explorer", nil) ;
    
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    NSURL *Url = [NSURL URLWithString:@"https://explorer.darmacash.com/m_tx?hash=ba22361b4941f229472e0688b6e23617dd47e6a40fb0ec89f38071d7fcc5339c"];

    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    [self.webView loadRequest:request];
  
}


- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}


@end
