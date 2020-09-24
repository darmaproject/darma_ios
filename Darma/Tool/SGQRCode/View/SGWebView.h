




#import <UIKit/UIKit.h>
@class SGWebView;

@protocol SGWebViewDelegate <NSObject>
@optional

- (void)webViewDidStartLoad:(SGWebView *)webView;

- (void)webView:(SGWebView *)webView didCommitWithURL:(NSURL *)url;

- (void)webView:(SGWebView *)webView didFinishLoadWithURL:(NSURL *)url;

- (void)webView:(SGWebView *)webView didFailLoadWithError:(NSError *)error;
@end

@interface SGWebView : UIView

@property (nonatomic, weak) id<SGWebViewDelegate> SGQRCodeDelegate;

@property (nonatomic, strong) UIColor *progressViewColor;

@property (nonatomic, copy) NSString *navigationItemTitle;

@property (nonatomic, assign) BOOL isNavigationBarOrTranslucent;


+ (instancetype)webViewWithFrame:(CGRect)frame;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)HTMLString;

- (void)reloadData;


@end

