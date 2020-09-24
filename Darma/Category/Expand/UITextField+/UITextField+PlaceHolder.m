

@implementation UITextField (PlaceHolder)

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (!self.placeholder) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[NSForegroundColorAttributeName] = placeholderColor;
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];

}

- (UIColor *)placeholderColor {
    return nil;
}
@end
