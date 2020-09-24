

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeLanguage : NSObject
+ (instancetype)shareInstance;
+(NSBundle *)bundle;


+ (NSString *)userLanguage;

-(void)setLanguage:(NSString *)language;

-(NSString *)LoacalStingForKey:(NSString *)key;
- (NSString *)languageKey;
- (BOOL)isEnglish;

@end

NS_ASSUME_NONNULL_END
