

#import "NSString+BITTool.h"

@implementation NSString (BITTool)

+ (NSString *)removeEndZero:(NSString *)valueStr
{
    NSArray *array = [valueStr componentsSeparatedByString:@"."];
    if (array.count >= 2 && !([array[1] floatValue] <= 0))
    {
        NSString *num = array.lastObject;
        num = [num removeSpace];
        while ([num hasSuffix:@"0"])
        {
            num = [num substringToIndex:num.length -1];
        }
        NSString *end = [NSString stringWithFormat:@"%@.%@", array.firstObject, num];
        return end;
    }
    return [NSString stringWithFormat:@"%ld", [valueStr integerValue]];
}

- (NSString *)removeEndZero
{
    return [NSString removeEndZero:self];
}

+ (NSString *)removeSpaceWithStr:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removeSpace
{
    return [NSString removeSpaceWithStr:self];
}


- (NSString *)percentStr
{
    NSMutableString *str = [NSMutableString stringWithString:self];
    [str appendString:@"%"];
    return str;
}

- (NSString *)pointWithValue:(NSInteger)round
{
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:round
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    value = [value decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [[value stringValue] removeEndZero];
}

- (NSString *)pointWithMiddle:(NSInteger)middleNumber
{
    if (self.length > middleNumber)
    {
        NSString *value = [self substringToIndex:middleNumber];
        if ([value hasSuffix:@"."])
        {
            value = [value substringToIndex:value.length - 1];
        }
        return [value removeEndZero];
    }
    return self;
}


- (NSString *)add:(NSString *)value
{
    return [self add:value round:8];
}

- (NSString *)add:(NSString *)value round:(NSInteger)round
{
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:value];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:round
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    return [[[one decimalNumberByAdding:two withBehavior:roundingBehavior] stringValue] removeEndZero];
}

- (NSString *)addDouble:(double)doubleValue
{
    return [self addDouble:doubleValue round:8];
}

- (NSString *)addDouble:(double)doubleValue round:(NSInteger)round
{
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *two = [[NSDecimalNumber alloc] initWithDouble:doubleValue];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:round
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    return [[[one decimalNumberByAdding:two withBehavior:roundingBehavior] stringValue] removeEndZero];
}

- (NSString *)subDouble:(double)doubleValue
{
    return [self subDouble:doubleValue round:8];
}

- (NSString *)subDouble:(double)doubleValue round:(NSInteger)round
{
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *two = [[NSDecimalNumber alloc] initWithDouble:doubleValue];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:round
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    return [[[one decimalNumberBySubtracting:two withBehavior:roundingBehavior] stringValue] removeEndZero];
}


- (NSString *)sub:(NSString *)value
{
    return [self sub:value round:8];
}

- (NSString *)sub:(NSString *)value round:(NSInteger)round
{
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:value];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:round
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    return [[[one decimalNumberBySubtracting:two withBehavior:roundingBehavior] stringValue] removeEndZero];
}


- (NSString *)bitMul:(NSString *)value
{
    return [self bitMul:value round:8];
}

- (NSString *)bitMul:(NSString *)value round:(NSInteger)round
{
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:value];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:round
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    return [[[one decimalNumberByMultiplyingBy:two withBehavior:roundingBehavior] stringValue] removeEndZero];
}

- (NSString *)bitMulDouble:(double)doubleValue
{
    return [self bitMulDouble:doubleValue round:8];
}

- (NSString *)bitMulDouble:(double)doubleValue round:(NSInteger)round
{
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *two = [[NSDecimalNumber alloc] initWithDouble:doubleValue];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:round
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    return [[[one decimalNumberByMultiplyingBy:two withBehavior:roundingBehavior] stringValue] removeEndZero];
}


- (NSString *)div:(NSString *)value
{
    return [self div:value round:8];
}

- (NSString *)div:(NSString *)value round:(NSInteger)round
{
    if ([value doubleValue] > 0)
    {
        NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:value];
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                          scale:round
                                                                                               raiseOnExactness:NO
                                                                                                raiseOnOverflow:NO
                                                                                               raiseOnUnderflow:NO
                                                                                            raiseOnDivideByZero:NO];
        
        return [[[one decimalNumberByDividingBy:two withBehavior:roundingBehavior] stringValue] removeEndZero];
    }
    return @"";
}

- (NSString *)divDouble:(double)doubleValue
{
    return [self divDouble:doubleValue round:8];
}

- (NSString *)divDouble:(double)doubleValue round:(NSInteger)round
{
    if (doubleValue > 0)
    {
        NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *two = [[NSDecimalNumber alloc] initWithDouble:round];
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                          scale:round
                                                                                               raiseOnExactness:NO
                                                                                                raiseOnOverflow:NO
                                                                                               raiseOnUnderflow:NO
                                                                                            raiseOnDivideByZero:NO];
        
        return [[[one decimalNumberByDividingBy:two withBehavior:roundingBehavior] stringValue] removeEndZero];
    }
    return @"";
}

+ (NSString *)one:(double)one addTwo:(double)two
{
    return [[[NSString decimalWithDouble:one] decimalNumberByAdding:[NSString decimalWithDouble:two]] stringValue];
}
+ (NSString *)one:(double)one subTwo:(double)two
{
    return [[[NSString decimalWithDouble:one] decimalNumberBySubtracting:[NSString decimalWithDouble:two]] stringValue];
}

+ (NSString *)one:(double)one mulTwo:(double)two
{
    return [[[NSString decimalWithDouble:one] decimalNumberByMultiplyingBy:[NSString decimalWithDouble:two]] stringValue];
}

+ (NSString *)one:(double)one divTwo:(double)two
{
    if (two > 0)
    {
         return [[[NSString decimalWithDouble:one] decimalNumberByDividingBy:[NSString decimalWithDouble:two]] stringValue];
    }
    return @"";
}

+ (NSDecimalNumber *)decimalWithDouble:(double)value
{
    return [[NSDecimalNumber alloc] initWithDouble:value];
}

- (BOOL)compare:(NSString *)value
{
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:value];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending)
    {
        return NO;
    }
    return YES;
}

- (NSString *)formatWithVolume
{
    double num = [self doubleValue];
    if (num <= 0)
    {
        return @"0";
    }
    if (num > 10000)
    {
        if (KisEnglish)
        {
            NSString *text = [[NSString stringWithFormat:@"%.2lf", num/1000] removeEndZero];
            return [NSString stringWithFormat:@"%@K", text];
        }
        else
        {
            NSString *text = @"Wan";
            return [[NSString stringWithFormat:@"%.2lf%@", num/10000, text] removeEndZero];
        }
       
    }
    else if (num > 100000000)
    {
        if (KisEnglish)
        {
            NSString *text = [[NSString stringWithFormat:@"%.2lf", num/10000000] removeEndZero];
            return [NSString stringWithFormat:@"%@K", text];
        }
        else
        {
            NSString *text =@"billion";
            return [[NSString stringWithFormat:@"%.2lf%@", num/100000000, text] removeEndZero];
        }
    }
    return [self pointWithValue:2];
}
@end
