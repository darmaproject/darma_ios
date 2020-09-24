


#import "Tool.h"

#import <CommonCrypto/CommonDigest.h>

@implementation Tool


+(NSString *)timeStampToTime:(NSString *)time{
    NSTimeInterval timeInt=[time doubleValue]+28800;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeInt/1000];
    NSLog(@"date:%@",[detaildate description]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *str_time=[NSString stringWithFormat:@"%@",detaildate];
    return str_time;
}

+(NSString *)timeTOTimeStamp:(NSString *)stamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *Date = [formatter dateFromString:stamp];
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[Date timeIntervalSince1970]] integerValue];
    
    NSLog(@"firstStamp:%ld",timeSp);
    NSString *str_timeSp=[NSString stringWithFormat:@"%ld",timeSp];
    return str_timeSp;
}

+(NSString *)MD5ForLower32Bate:(NSString *)str{
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

+(NSString *)MD5ForUpper16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

+(NSString *)MD5ForLower16Bate:(NSString *)str{

    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

+(NSString *)SortingAZMD5ForLow32BateDic:(NSDictionary *)dic{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dic allKeys];
    if (keys.count>0) {
        
        NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
            NSRange range =NSMakeRange(0,obj1.length);
            return [obj1 compare:obj2 options:comparisonOptions range:range];
        }];
        
        for (NSString *categoryId in sortedArray) {
            
            
            for (NSString *keydic in keys) {
                if ([keydic isEqualToString:categoryId]) {
                    
                    if (![dic objectForKey:keydic]||[[NSString stringWithFormat:@"%@",[dic objectForKey:keydic]] isEqualToString:@""]) {
                        break;
                    }
                    
                    if([sortedArray indexOfObject:categoryId]==0){
                        [contentString appendFormat:@"%@=%@", keydic, [dic objectForKey:keydic]];
                        
                        
                    }else{
                        [contentString appendFormat:@"&%@=%@", keydic, [dic objectForKey:keydic]];
                    }
                    break;
                }
            }
            
            
        }
        
        [contentString appendString:@"&key=HKhfXOsXCBQg6hey"];
    } else{
        
        [contentString appendString:@"&key=HKhfXOsXCBQg6hey"];
    }
    
    NSString *signStr = [self MD5ForLower32Bate:[NSString stringWithFormat:@"%@",contentString]];
    return signStr;
}
+ (NSString *)safeString:(NSString *)string{
    string=[NSString stringWithFormat:@"%@",string];
    if ([string isKindOfClass:[NSNull class]]) {
        
        return @"";
    }else if (string == nil) {
        
        return @"";
        
    }else if (string == NULL) {
        
        return @"";
        
    }else if ([string isEqualToString:@"<null>"]) {
        
        return @"";
        
    }else if ([string isEqualToString:@"null"]) {
        
        return @"";
        
    }else if ([string isEqualToString:@"(null)"]) {
        
        return @"";
        
    }else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return @"";
        
    }else{
        return string;
    }
    
    
}
+ (BOOL)isBlankString:(NSString *)string{
    string=[NSString stringWithFormat:@"%@",string];
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }else if (string == nil) {
        
        return YES;
        
    }else if (string == NULL) {
        
        return YES;
        
    }else if ([string isEqualToString:@"null"]) {
        
        return YES;
        
    }else if ([string isEqualToString:@"<null>"]) {
        
        return YES;
        
    }else if ([string isEqualToString:@"(null)"]) {
        
        return YES;
        
    }else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

+(BOOL)isUrlAddress:(NSString*)url

{
    

    if ([url hasPrefix:@"darma:"]) {
        return YES;
    }
    
    NSString*reg =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";


    NSPredicate*urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return[urlPredicate evaluateWithObject:url];
    
}
+ (UIImage *)composeImages:(NSArray<UIImage *> *)arr{
    
    NSInteger column = 3;
    
    
    CGFloat imageW = Width / column;
    CGFloat imageH = imageW;
    
    
    UIGraphicsBeginImageContext(CGSizeMake(Width, Width));
    
    
    for (int i = 0; i<arr.count;i++) {
        UIImage *img = arr[i];
        
        [img drawInRect:CGRectMake(((i % column) * imageW), ((i / column) * imageH), imageW - 10, imageH - 10)];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); 
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}
+ (NSString *)DictionaryToJson:(NSDictionary *)dic{
    if (dic == nil) {
        return @"";
    }
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+(NSString*)getDocumentRootPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
@end
