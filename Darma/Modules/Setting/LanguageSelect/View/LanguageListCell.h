



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageListCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dict;

-(void)setlanguageName:(NSString *)language isSelect:(NSString *)isSelect;
@end

NS_ASSUME_NONNULL_END
