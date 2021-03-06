
#import "GesManager.h"

#define KEY   @"key"
#define OPEN  @"open"
#define CLOES @"cloes"

@implementation GesManager

+ (BOOL)getGesHidenOpen{
    NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:KEY];
    NSLog( @"%@",s);
    if ([s isEqualToString:OPEN]) {
        return YES;
    }
    return NO;
}

+ (void)setGesHidenOpen:(BOOL)open{
    NSUserDefaults *deful = [NSUserDefaults standardUserDefaults];
    if (open) {
        [deful setObject:OPEN forKey:KEY];
    }else{
        [deful setObject:CLOES forKey:KEY];
    }
    [deful synchronize];
}


@end
