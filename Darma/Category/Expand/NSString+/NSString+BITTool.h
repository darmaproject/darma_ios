

#import <Foundation/Foundation.h>


@interface NSString (BITTool)


+ (NSString *)removeEndZero:(NSString *)valueStr;
- (NSString *)removeEndZero;


+ (NSString *)removeSpaceWithStr:(NSString *)str;
- (NSString *)removeSpace;


- (NSString *)pointWithValue:(NSInteger)round;


- (NSString *)pointWithMiddle:(NSInteger)middleNumber;


- (NSString *)percentStr;


- (NSString *)add:(NSString *)value;
- (NSString *)add:(NSString *)value round:(NSInteger)round;
- (NSString *)addDouble:(double)doubleValue;
- (NSString *)addDouble:(double)doubleValue round:(NSInteger)round;


- (NSString *)sub:(NSString *)value;
- (NSString *)sub:(NSString *)value round:(NSInteger)round;
- (NSString *)subDouble:(double)doubleValue;
- (NSString *)subDouble:(double)doubleValue round:(NSInteger)round;


- (NSString *)bitMul:(NSString *)value;
- (NSString *)bitMul:(NSString *)value round:(NSInteger)round;
- (NSString *)bitMulDouble:(double)doubleValue;
- (NSString *)bitMulDouble:(double)doubleValue round:(NSInteger)round;


- (NSString *)div:(NSString *)value;
- (NSString *)div:(NSString *)value round:(NSInteger)round;
- (NSString *)divDouble:(double)doubleValue;
- (NSString *)divDouble:(double)doubleValue round:(NSInteger)round;

+ (NSString *)one:(double)one addTwo:(double)two;
+ (NSString *)one:(double)one subTwo:(double)two;
+ (NSString *)one:(double)one mulTwo:(double)two;
+ (NSString *)one:(double)one divTwo:(double)two;


- (BOOL)compare:(NSString *)value;

@end
