

#define kScreenRatio kgetScreenScale()
#define kScreenHRatio kgetScreenHeightScale()

#define Fit(num) kScreenRatio * (num)
#define FitW(num) kScreenRatio * (num)
#define FitH(num) kScreenHRatio * (num)


static CGFloat const kDesignStandard = 375.00;

static CGFloat const kDesignHeight = 667.00;

CGFloat kgetScreenScale();
CGFloat kgetScreenHeightScale();

@interface UILabel (AdaptivePerfect)

@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end

@interface UIButton (AdaptivePerfect)

@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end

@interface UITextField (AdaptivePerfect)

@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end

@interface UITextView (AdaptivePerfect)

@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end

