




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ReceiptTopView : UIView
@property(nonatomic, strong) UIButton *createPaymentIdButton;
-(void)createPamentID:(NSDictionary *__nullable)dict walletaAddress:(NSString *)walletaAddress isCreat:(BOOL)isCrate;

@end

NS_ASSUME_NONNULL_END
