



#import "WordClickListView.h"

@implementation WordClickListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
         _markArray= [NSArray array];
         _markArray=@[@"word", @"word", @"word", @"word", @"word",@"1",@"2",@"3",@"+",@"word", @"word", @"word", @"word", @"word",@"1",@"2",@"3",@"+"];
        [self setupMultiselectView];
    }
    return self;
}
- (void)setupMultiselectView {
    
    CGFloat toTop = 21;  
    CGFloat marginX = 13;  
    CGFloat margin_loc=3;
    CGFloat margin_row=3;
    int SPNum = 4;

    CGFloat buttonW=(Width-marginX*2-margin_loc*3)/SPNum;
    CGFloat buttonH=31;
     UIView *lastView = nil;   
    for (int i=0; i<self.markArray.count ; i++) {

        int  loc=i%SPNum;
        LabelView *wordView=[[LabelView alloc] init];
        wordView.numLabel.text=[NSString stringWithFormat:@"%i",i+1];
        wordView.contentLabel.text=_markArray[i];
        wordView.backgroundColor=[UIColor colorWithHexString:@"#F0F1F4"];
        wordView.layer.cornerRadius=4;
        wordView.clipsToBounds = YES;
        wordView.tag = 1000+i;
        [self addSubview:wordView];
        [wordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(buttonW);
            make.height.mas_equalTo(buttonH);
            
            
            CGFloat top = toTop  + (i/SPNum)*(buttonH+margin_row);
            make.top.mas_offset(top);
            if (!lastView || loc == 0) {  
                make.left.mas_offset(marginX);
                
            }else{
                
                make.left.mas_equalTo(lastView.mas_right).mas_offset(margin_loc);
            }
        }];
        lastView = wordView;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-toTop);
    }];
}
-(void)setMarkArray:(NSArray *)markArray{
    _markArray=markArray;
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self setupMultiselectView];
}
@end

@interface LabelView()

@end
@implementation LabelView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.numLabel];
        [self addSubview:self.contentLabel];
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(3);
        make.top.equalTo(self).offset(1);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
}
- (UILabel *)numLabel
{
    if (!_numLabel)
    {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _numLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _numLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _numLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

@end
