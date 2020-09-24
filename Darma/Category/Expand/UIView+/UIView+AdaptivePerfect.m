


CGFloat kgetScreenScale() {
    static CGFloat scale = 0;
    if (scale) return scale;
    scale = CGRectGetWidth([UIScreen mainScreen].bounds) / kDesignStandard;
    return scale;
}

CGFloat kgetScreenHeightScale() {
    static CGFloat scale = 0;
    if (scale)
    {
        return scale;
    }
    if (IS_IPHONE_X)
    {
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds) - 44.0f;
        NSDecimalNumber *heightDecimal = [[NSDecimalNumber alloc] initWithDouble:height];
        NSDecimalNumber *kDecimal = [[NSDecimalNumber alloc] initWithDouble:kDesignHeight];
        scale =  [[heightDecimal decimalNumberByDividingBy:kDecimal] doubleValue];
        return scale;
    }
    else
    {
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
        NSDecimalNumber *heightDecimal = [[NSDecimalNumber alloc] initWithDouble:height];
        NSDecimalNumber *kDecimal = [[NSDecimalNumber alloc] initWithDouble:kDesignHeight];
        scale =  [[heightDecimal decimalNumberByDividingBy:kDecimal] doubleValue];
        return scale;
    }
}

@implementation UILabel (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.font = [UIFont systemFontOfSize:rm_font * kgetScreenScale()];
}

- (CGFloat)rm_font {
    return self.font.pointSize;
}
@end

@implementation UIButton (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.titleLabel.font = [UIFont systemFontOfSize:rm_font * kgetScreenScale()];
}
- (CGFloat)rm_font {
    return self.titleLabel.font.pointSize;
}
@end


@implementation UITextField (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.font = [UIFont systemFontOfSize:rm_font * kgetScreenScale()];
}
- (CGFloat)rm_font {
    return self.font.pointSize;
}
@end


@implementation UITextView (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.font = [UIFont systemFontOfSize:rm_font * kgetScreenScale()];
}
- (CGFloat)rm_font {
    return self.font.pointSize;
}
@end
