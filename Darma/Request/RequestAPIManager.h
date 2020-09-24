

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestAPIManager : NSObject
-(void)GETRequestRate:(NSString *)coinName1 coinName2:(NSString *)coinName2 success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail;
-(void)POSTRequestCreateOrder:(NSDictionary *)params success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail;
-(void)GETRequestQueryOrder:(NSString *)orderId success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail;
-(void)GETRequestQueryPrice:(NSString *)coinName1 coinName2:(NSString *)coinName2 amount:(NSString *)amount success:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail;
-(void)GETExchangeStatusSuccess:(void(^)(NSURLSessionDataTask *,id))success fail:(void(^)(NSURLSessionDataTask *, NSError *))fail;
@end

NS_ASSUME_NONNULL_END
