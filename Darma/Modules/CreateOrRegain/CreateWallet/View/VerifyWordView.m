




#import "VerifyWordView.h"

@implementation VerifyWordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _markArray=[[NSMutableArray array] init];
        _markArray=@[@"word1", @"word2", @"word3", @"word4", @"word5",@"word6",@"word7",@"word8",@"+",@"-", @"11", @"22", @"yuy", @"iiuy",@"1",@"2",@"3",@"#"];
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
    UIButton *last = nil;   
    for (int i=0; i<self.markArray.count ; i++) {
        
        int  loc=i%SPNum;
        UIButton *keybutton = [UIButton buttonWithType:UIButtonTypeCustom];
        keybutton.backgroundColor=[UIColor colorWithHexString:@"#F0F1F4"];
        [keybutton setTitle:_markArray[i] forState:UIControlStateNormal];
        [keybutton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
        [keybutton setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        keybutton.layer.cornerRadius=4;
        keybutton.clipsToBounds = YES;
        [keybutton addTarget:self action:@selector(chooseMark:) forControlEvents:UIControlEventTouchUpInside];
        keybutton.tag = 1000+i;
        [self addSubview:keybutton];
        [keybutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(buttonW);
            make.height.mas_equalTo(buttonH);
            
            
            CGFloat top = toTop  + (i/SPNum)*(buttonH+margin_row);
            make.top.mas_offset(top);
            if (!last || loc == 0) {  
                make.left.mas_offset(marginX);
                
            }else{
                
                make.left.mas_equalTo(last.mas_right).mas_offset(margin_loc);
            }
        }];
        last = keybutton;
    }
    [last mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-toTop);
    }];
}
-(void)setMarkArray:(NSMutableArray *)markArray{
    _markArray=markArray;
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self setupMultiselectView];
}

- (void)chooseMark:(UIButton *)sender {
        sender.selected = !sender.selected;
    for (int i=0; i <self.markArray.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:1000+i];
        if (sender.tag == btn.tag) {
            if (self.clickWordsArray.count<4) {
                btn.userInteractionEnabled=NO;
                [btn setTitleColor:[UIColor colorWithHexString:@"#D2D6DC"] forState:UIControlStateNormal];
                [self.clickWordsArray addObject:sender.titleLabel.text];
            }
        }
    }
    
    if([self.delegate respondsToSelector:@selector(wordLickView:Word:)]){
        [self.delegate  wordLickView:self Word:self.clickWordsArray];
    }
}
-(void)setIsVerifySucceed:(BOOL)isVerifySucceed{
    for (int i=0; i <self.markArray.count; i++) {
        if (!isVerifySucceed) {
            UIButton *btn = (UIButton *)[self viewWithTag:1000+i];
            btn.userInteractionEnabled=YES;
            [btn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        }
    }
}
- (NSMutableArray *)clickWordsArray {
    if (!_clickWordsArray) {
         _clickWordsArray=[[NSMutableArray alloc] init];
    }
    return _clickWordsArray;
}

@end
