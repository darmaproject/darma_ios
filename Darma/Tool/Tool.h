



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject


+(NSString *)timeStampToTime:(NSString *)time;

+(NSString *)timeTOTimeStamp:(NSString *)stamp;

+(NSString *)MD5ForLower32Bate:(NSString *)str;

+(NSString *)MD5ForUpper32Bate:(NSString *)str;


+(NSString *)MD5ForLower16Bate:(NSString *)str;


+(NSString *)MD5ForUpper16Bate:(NSString *)str;


+(NSString *)SortingAZMD5ForLow32BateDic:(NSDictionary *)dic;


+ (NSString *)safeString:(NSString *)string;

+ (BOOL)isBlankString:(NSString *)string;


+(BOOL)isUrlAddress:(NSString*)url;

+ (UIImage *)composeImages:(NSArray<UIImage *> *)arr;


+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+ (NSString *)DictionaryToJson:(NSDictionary *)dic;

+(NSString*)getDocumentRootPath;
@end

NS_ASSUME_NONNULL_END
