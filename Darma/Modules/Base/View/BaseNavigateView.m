



#import "BaseNavigateView.h"

@implementation BaseNavigateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#1C1F26"];
        [self addSubview:self.backgroundImage];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.backButton];
        [self.contentView addSubview:self.titleLabel];
        [self updateView];
        [self addLayout];
        self.autoresizingMask  = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}
- (void)addLayout
{
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
        make.height.equalTo(@44);
    }];
   
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@44);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)updateView
{
    
}

- (void)clickButton
{
    if ([self.delegate respondsToSelector:@selector(navigateViewClickBack:)])
    {
        [self.delegate navigateViewClickBack:self];
    }
    else
    {
        if (self.back)
        {
            self.back();
        }
    }
}

- (void)titleClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(navigateViewClickTitle:)])
    {
        [self.delegate navigateViewClickTitle:self];
    }
}

- (void)setTitle:(NSString *)title
{
    
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UIImageView *)backgroundImage
{
    if (!_backgroundImage)
    {
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.image=[UIImage imageNamed:@"bg_nav"];
        _backgroundImage.contentMode= UIViewContentModeScaleAspectFill;
    }
    return _backgroundImage;
}
- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [[UIButton alloc] init];
        [_backButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [_titleLabel addGestureRecognizer:tap];
    }
    return _titleLabel;
}
@end
