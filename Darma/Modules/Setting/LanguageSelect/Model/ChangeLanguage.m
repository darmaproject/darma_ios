



#import "ChangeLanguage.h"

static ChangeLanguage* localString=nil;

@implementation ChangeLanguage

static NSBundle *languageBundle=nil;
static NSString *key=nil;
BOOL _isEnglish;

+ ( NSBundle * )languageBundle{
    
    return languageBundle;
    
}
+ (instancetype)shareInstance
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        localString = [[ChangeLanguage alloc]init];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        NSString *language=[def valueForKey:@"LocalLanguageKey"];
        NSString *currentString=nil;
        if (language.length==0)
        {
            key = @"en-us";
             _isEnglish = YES;
            [def setValue:currentString forKey:@"LocalLanguageKey"];
            [def synchronize];
        }else
        {
            currentString=language;
             _isEnglish = NO;
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:currentString ofType:@"lproj"]; 
        languageBundle=[NSBundle bundleWithPath:path];
    });
    return localString;
}

+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"LocalLanguageKey"];
    return language;
}

-(void)setLanguage:(NSString *)language
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [def valueForKey:@"LocalLanguageKey"];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [def setValue:language forKey:@"LocalLanguageKey"];
    [def synchronize];
    if ([language hasPrefix:@"en"]) {
        key = @"en-us";
    }else if ([language hasPrefix:@"zh"]) {
        key = @"zh-cn";
    }else{
        key=language;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    languageBundle=[NSBundle bundleWithPath:path];
}

-(NSString *)LoacalStingForKey:(NSString *)key
{
    return [languageBundle localizedStringForKey:key value:nil table:@"Localizable"];

}
- (NSString *)languageKey
{
    return key;
}

- (BOOL)isEnglish;
{
    return _isEnglish;
}
@end
