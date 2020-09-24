



#import "PaymentManager.h"

#import "MobileWalletSDKManger.h"
#import "CustomActionView.h"


@implementation PaymentManager

-(void)transfer:(NSString* _Nonnull)walletAddress amountstr:(NSString* _Nonnull)amountstr unlock_time_str:(NSString* _Nonnull)unlock_time_str payment_id:(NSString* _Nonnull)payment_id mixin:(long)mixin sendtx:(BOOL)sendtx password:(NSString* _Nonnull)password isAll:(BOOL)isAll success:(void(^)(NSDictionary *transferInfo))success fail:(void(^)(NSDictionary *error))fail{
    
    if (isAll==NO) {
        
        
        NSDictionary* transferInfo=[[NSDictionary alloc] init];
        
        transferInfo= [[MobileWalletSDKManger shareInstance] transfer:walletAddress amountstr:amountstr unlock_time_str:@"0" payment_id:payment_id mixin:0 sendtx:NO password:password ];
        if (!transferInfo) {
            NSString *error= AppwalletGetLastError();
            NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if(err) {
                NSLog(@"Json parsing failed：%@",err);
                [SHOWProgressHUD showMessage:dic[@"errMsg"]];
            }
            if (fail) {
                fail(dic);
            }
        }else{
            if (success) {
                success(transferInfo);
            }
        }
        
    }else{
        NSDictionary* transferInfo=[[NSDictionary alloc] init];
        transferInfo= [[MobileWalletSDKManger shareInstance] Transfer_Everything:walletAddress unlock_time_str:@"0" payment_id:payment_id mixin:0 password:password];
        if (!transferInfo) {
            NSString *error= AppwalletGetLastError();
            NSData *jsonData = [error dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if(err) {
                NSLog(@"Json parsing failed：%@",err);
                [SHOWProgressHUD showMessage:dic[@"errMsg"]];
            }
            
            if (fail) {
                fail(dic);
            }
        }else{
            if (success) {
                success(transferInfo);
            }
        }
    }
}

@end
