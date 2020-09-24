

#import "RequestManager.h"
@interface RequestManager()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
@implementation RequestManager
+ (instancetype)shareInstance
{
    static RequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestManager alloc] init];
    });
    return manager;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager)
    {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        [_sessionManager.securityPolicy setValidatesDomainName:NO];

        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
  
    [_sessionManager.requestSerializer setValue:[ChangeLanguage shareInstance].languageKey forHTTPHeaderField:@"APP-LANGUAGE"];
    return _sessionManager;
}
+ (AFHTTPSessionManager *)manager
{
    return [RequestManager shareInstance].sessionManager;
}

@end
