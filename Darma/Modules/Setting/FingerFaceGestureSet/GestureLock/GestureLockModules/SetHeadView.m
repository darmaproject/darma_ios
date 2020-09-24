


#import "SetHeadView.h"

#import "Define.h"
@interface SetHeadView()
{
    CGFloat w;
    
}
@property (nonatomic,strong)NSMutableArray *viewAry;


@end

@implementation SetHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        w = frame.size.height;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat space = w/20;
    CGFloat weight = 0.3*w;
    
    for (int i = 0; i<9; i++) {
        CGFloat x = (space+weight)*(i%3);
        CGFloat y = (space+weight)*(i/3);
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(x, y, weight, weight)];

        v.backgroundColor=[UIColor colorWithHexString:@"#505156"];
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = weight/2;
        v.tag = i+1;
        [self addSubview:v];
        [self.viewAry addObject:v];
    }
    
}

- (void)refreshWithString:(NSString *)str{
    NSMutableString *_str = [[NSMutableString alloc]initWithString:str];
    for (int i = 0; i<_str.length; i++) {
        NSString *s = [_str substringWithRange:NSMakeRange(i, 1)];
        for (int j = 0; j<self.viewAry.count; j++) {
            UIView *v = [self.viewAry objectAtIndex:j];
            if (v.tag  == [s integerValue]) {


                dispatch_async(dispatch_get_main_queue(), ^{

                    v.backgroundColor=[UIColor colorWithHexString:@"#E1C303"];
                });
            }
        }
    }
}

- (void)defult{
    for (int j = 0; j<self.viewAry.count; j++) {
        UIView *v = [self.viewAry objectAtIndex:j];


        dispatch_async(dispatch_get_main_queue(), ^{

            v.backgroundColor=[UIColor colorWithHexString:@"#505156"];

        });
    }
}

- (NSMutableArray*)viewAry{
    
    if (!_viewAry) {
        _viewAry = [[NSMutableArray alloc]init];
    }
    return _viewAry;
}
@end
