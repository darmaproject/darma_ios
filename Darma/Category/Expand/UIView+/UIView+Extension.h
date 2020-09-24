

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
- (UIButton *)buttonWithTag:(NSInteger ) tag;
- (UIImageView *)imageWithTag:(NSInteger) tag;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
@end
