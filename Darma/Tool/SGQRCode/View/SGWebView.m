




#import "SGWebView.h"

#import <WebKit/WebKit.h>

@interface SGWebView () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation SGWebView

static CGFloat const navigationBarHeight = 64;
static CGFloat const progressViewHeight = 2;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.wkWebView];
        [self addSubview:self.progressView];
    }
    return self;
}

+ (instancetype)webViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    }
    return _wkWebView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor clearColor];
        
        _progressView.frame = CGRectMake(0, navigationBarHeight, self.frame.size.width, progressViewHeight);
        
        _progressView.tintColor = [UIColor greenColor];
    }
    return _progressView;
}

- (void)setProgressViewColor:(UIColor *)progressViewColor {
    _progressViewColor = progressViewColor;
    
    if (progressViewColor) {
        _progressView.tintColor = progressViewColor;
    }
}

- (void)setIsNavigationBarOrTranslucent:(BOOL)isNavigationBarOrTranslucent {
    _isNavigationBarOrTranslucent = isNavigationBarOrTranslucent;
    
    if (isNavigationBarOrTranslucent == YES) { 
        _progressView.frame = CGRectMake(0, navigationBarHeight, self.frame.size.width, progressViewHeight);
    } else { 
        _progressView.frame = CGRectMake(0, 0, self.frame.size.width, progressViewHeight);
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        self.progressView.alpha = 1.0;
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        if(self.wkWebView.estimatedProgress >= 0.97) {
            [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0 animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

    if (self.SGQRCodeDelegate && [self.SGQRCodeDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.SGQRCodeDelegate webViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if (self.SGQRCodeDelegate && [self.SGQRCodeDelegate respondsToSelector:@selector(webView:didCommitWithURL:)]) {
        [self.SGQRCodeDelegate webView:self didCommitWithURL:self.wkWebView.URL];
    }
    
    self.navigationItemTitle = self.wkWebView.title;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationItemTitle = self.wkWebView.title;
    if (self.SGQRCodeDelegate && [self.SGQRCodeDelegate respondsToSelector:@selector(webView:didFinishLoadWithURL:)]) {
        [self.SGQRCodeDelegate webView:self didFinishLoadWithURL:self.wkWebView.URL];
    }
    
    self.progressView.alpha = 0.0;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.SGQRCodeDelegate && [self.SGQRCodeDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.SGQRCodeDelegate webView:self didFailLoadWithError:error];
    }
    
    self.progressView.alpha = 0.0;
}


- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWebView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
}

- (void)reloadData {
    [self.wkWebView reload];
}


- (void)dealloc {    
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}


@end

