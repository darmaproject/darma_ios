

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestManager : NSObject
+ (instancetype) shareInstance;
+ (AFHTTPSessionManager *)manager;

@end

NS_ASSUME_NONNULL_END
