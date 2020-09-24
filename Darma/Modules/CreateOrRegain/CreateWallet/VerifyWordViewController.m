



#import "VerifyWordViewController.h"

#import "VerifyWordView.h"

#import "BaseTabBarController.h"
#import "BaseNavController.h"
@interface VerifyWordViewController ()<selectWordDelegate>
@property(nonatomic ,strong) UIView *headPromptView;
@property(nonatomic ,strong) UILabel *PromptLable;
@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) UILabel *titleLable;
@property(nonatomic ,strong) showVerifyLabelView * showLable1;
@property(nonatomic ,strong) showVerifyLabelView * showLable2;
@property(nonatomic ,strong) showVerifyLabelView * showLable3;
@property(nonatomic ,strong) showVerifyLabelView * showLable4;
@property(nonatomic ,strong) UILabel *tipLable;
@property(nonatomic ,strong) VerifyWordView *verifyView;
@property(nonatomic, strong)UIButton  *verifyBtn;
@property(nonatomic, strong)UIButton  *skipBtn;

@property(nonatomic, strong)NSString *str_selectSeeds;
@property(nonatomic, strong)NSString *str_verifySeeds;

@end

@implementation VerifyWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Create Wallet",nil);
    self.navigateView.backgroundImage.hidden=YES;

    [self addLayoutUI];
    
    [self tagAndSeed];
}

-(void)tagAndSeed{
    NSMutableArray *unRandomArray=[[NSMutableArray alloc] initWithArray:_seedArray];
   
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger mumber=_seedArray.count;
    for (int i=0; i<mumber; i++) {
        int t=arc4random()%unRandomArray.count;
        resultArray[i]=unRandomArray[t];
        unRandomArray[t]=[unRandomArray lastObject]; 
        [unRandomArray removeLastObject];
      
    }
    _verifyView.markArray=resultArray;
    
    NSMutableArray *numberArray=[[NSMutableArray alloc] init];
    for (int j=1; j<=resultArray.count; j++) {
        NSString * num=[NSString stringWithFormat:@"%i",j];
        [numberArray addObject:num];
    }
    NSArray *array=[[NSArray alloc] initWithArray:numberArray];
    array=[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [obj1 compare:obj2];
        } else {
            return [obj2 compare:obj1];
        }
    }];
    _showLable1.numLabel.text=[NSString stringWithFormat:@"%@",array[0]];
    _showLable2.numLabel.text=[NSString stringWithFormat:@"%@",array[1]];
    _showLable3.numLabel.text=[NSString stringWithFormat:@"%@",array[2]];
    _showLable4.numLabel.text=[NSString stringWithFormat:@"%@",array[3]];
    
    NSMutableArray *verifyArray=[[NSMutableArray alloc] init];
    for (int s=0; s<4; s++) {
        int index= [[NSString stringWithFormat:@"%@",array[s]] intValue];
        [verifyArray addObject:_seedArray[index-1]];
    }
    _str_verifySeeds = [verifyArray componentsJoinedByString:@" "];
}
- (void)addLayoutUI
{
    [self.headPromptView addSubview:self.imageView];
    [self.headPromptView addSubview:self.PromptLable];
    [self.view addSubview:self.headPromptView];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.showLable1];
    [self.view addSubview:self.showLable2];
    [self.view addSubview:self.showLable3];
    [self.view addSubview:self.showLable4];
    [self.view addSubview:self.tipLable];
    [self.view addSubview:self.verifyView];
    [self.view addSubview:self.verifyBtn];
    [self.view addSubview:self.skipBtn];

    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPromptView).offset(17);
        make.left.equalTo(self.headPromptView).offset(6);
        make.width.height.mas_equalTo(7);
    }];
    [_PromptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPromptView).offset(12);
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.equalTo(self.headPromptView).offset(-32);
        make.bottom.equalTo(self.headPromptView).offset(-12);
    }];

    [_headPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigateView.mas_bottom).offset(-20);
        make.left.right.equalTo(self.view);
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPromptView.mas_bottom).offset(24);
        make.left.right.equalTo(self.view);
    }];
    
    CGFloat buttonW=(Width-13*2-3*3)/4;
    CGFloat buttonH=31;
    
    [_showLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(24);
        make.left.left.equalTo(self.view).offset(13);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(buttonH);
    }];
    [_showLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.showLable1);
        make.left.equalTo(self.showLable1.mas_right).offset(3);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(buttonH);
    }];
    [_showLable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.showLable2);
        make.left.equalTo(self.showLable2.mas_right).offset(3);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(buttonH);
    }];
    [_showLable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.showLable3);
        make.left.equalTo(self.showLable3.mas_right).offset(3);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(buttonH);
    }];
    
    [_tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showLable4.mas_bottom).offset(24);
        make.left.right.equalTo(self.view);
    }];
    
    [_verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLable.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
    }];
    
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-88);
        make.height.mas_equalTo(48);
    }];
    [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(_verifyBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
}

-(void)verify:(UIButton *)sender{
    if ([_str_selectSeeds isEqualToString: _str_verifySeeds]) {
        
        [_verifyBtn setBackgroundColor:[UIColor colorWithHexString:@"#BCE6E7"]];
        self.verifyView.isVerifySucceed=YES;
        [[MobileWalletSDKManger shareInstance] Update_Wallet];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        BaseTabBarController *loginVC = [[BaseTabBarController alloc]init];
        BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:loginVC];
        [loginVC.navigationController setNavigationBarHidden:YES];
        window.rootViewController = navigationController;
    }else{
        
        [_verifyBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        [self.verifyView.clickWordsArray removeAllObjects];
        _showLable1.contentLabel.text=@"";
        _showLable2.contentLabel.text=@"";
        _showLable3.contentLabel.text=@"";
        _showLable4.contentLabel.text=@"";
        [self tagAndSeed];
        self.verifyView.isVerifySucceed=NO;

        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Verification failed. Try again.", nil) ];
    }
 
}
-(void)skip:(UIButton *)sender{
    
    [[MobileWalletSDKManger shareInstance] Update_Wallet];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BaseTabBarController *loginVC = [[BaseTabBarController alloc]init];
    BaseNavController *navigationController = [[BaseNavController alloc]initWithRootViewController:loginVC];
    [loginVC.navigationController setNavigationBarHidden:YES];
    window.rootViewController = navigationController;
}

-(void)wordLickView:(VerifyWordView *)view Word:(NSMutableArray *)wordsArray{
   if(wordsArray.count==1){
         _showLable1.contentLabel.text=wordsArray[0];
    }else if(wordsArray.count==2){
        _showLable1.contentLabel.text=wordsArray[0];
        _showLable2.contentLabel.text=wordsArray[1];
    }else if(wordsArray.count==3){
        _showLable1.contentLabel.text=wordsArray[0];
        _showLable2.contentLabel.text=wordsArray[1];
        _showLable3.contentLabel.text=wordsArray[2];
    }else if(wordsArray.count==4){
        _showLable1.contentLabel.text=wordsArray[0];
        _showLable2.contentLabel.text=wordsArray[1];
        _showLable3.contentLabel.text=wordsArray[2];
        _showLable4.contentLabel.text=wordsArray[3];
    }else{
        _showLable1.contentLabel.text=@"";
        _showLable2.contentLabel.text=@"";
        _showLable3.contentLabel.text=@"";
        _showLable4.contentLabel.text=@"";
    }
    _str_selectSeeds = [wordsArray componentsJoinedByString:@" "];

}

- (UIView *)headPromptView
{
    if (!_headPromptView)
    {
        _headPromptView = [[UIView alloc] init];
        _headPromptView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
    }
    return _headPromptView;
}
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"dian"];
    }
    return _imageView;
}
- (UILabel *)PromptLable
{
    if (!_PromptLable)
    {
        _PromptLable = [[UILabel alloc] init];
        _PromptLable.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
        _PromptLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _PromptLable.text=BITLocalizedCapString(@"To make sure you have copied your SEED words in right form, please select the corresponding words.", nil);
        _PromptLable.numberOfLines=0;
        _PromptLable.textAlignment=NSTextAlignmentLeft;
    }
    return _PromptLable;
}
- (UILabel *)titleLable
{
    if (!_titleLable)
    {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _titleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLable.text=BITLocalizedCapString(@"Please confirm your SEED words.", nil);
        _titleLable.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLable;
}
- (showVerifyLabelView *)showLable1
{
    if (!_showLable1)
    {
        _showLable1 = [[showVerifyLabelView alloc] init];
        _showLable1.numLabel.text=[NSString stringWithFormat:@"%i",1];
        _showLable1.backgroundColor=[UIColor colorWithHexString:@"#F0F1F4"];
        _showLable1.layer.cornerRadius=4;
        _showLable1.clipsToBounds = YES;
        _showLable1.tag = 100;
    }
    return _showLable1;
}
- (showVerifyLabelView *)showLable2
{
    if (!_showLable2)
    {
        _showLable2 = [[showVerifyLabelView alloc] init];
        _showLable2.numLabel.text=[NSString stringWithFormat:@"%i",2];
        _showLable2.backgroundColor=[UIColor colorWithHexString:@"#F0F1F4"];
        _showLable2.layer.cornerRadius=4;
        _showLable2.clipsToBounds = YES;
        _showLable2.tag = 101;
    }
    return _showLable2;
}
- (showVerifyLabelView *)showLable3
{
    if (!_showLable3)
    {
        _showLable3 = [[showVerifyLabelView alloc] init];
        _showLable3.numLabel.text=[NSString stringWithFormat:@"%i",3];
        _showLable3.backgroundColor=[UIColor colorWithHexString:@"#F0F1F4"];
        _showLable3.layer.cornerRadius=4;
        _showLable3.clipsToBounds = YES;
        _showLable3.tag = 102;
    }
    return _showLable3;
}
- (showVerifyLabelView *)showLable4
{
    if (!_showLable4)
    {
        _showLable4 = [[showVerifyLabelView alloc] init];
        _showLable4.numLabel.text=[NSString stringWithFormat:@"%i",4];
        _showLable4.backgroundColor=[UIColor colorWithHexString:@"#F0F1F4"];
        _showLable4.layer.cornerRadius=4;
        _showLable4.clipsToBounds = YES;
        _showLable4.tag = 103;
    }
    return _showLable4;
}
- (UILabel *)tipLable
{
    if (!_tipLable)
    {
        _tipLable = [[UILabel alloc] init];
        _tipLable.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _tipLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _tipLable.text=BITLocalizedCapString(@"Please click SEED words according above serial No.", nil);
        _tipLable.textAlignment=NSTextAlignmentCenter;
    }
    return _tipLable;
}
-(VerifyWordView *)verifyView{
    if (!_verifyView)
    {
        _verifyView = [[VerifyWordView alloc] init];
        _verifyView.backgroundColor=[UIColor whiteColor];
        _verifyView.delegate=self;
    }
    return _verifyView;
}
- (UIButton *)verifyBtn
{
    if (!_verifyBtn)
    {
        _verifyBtn = [[UIButton alloc] init];
        [_verifyBtn setTitle:BITLocalizedCapString(@"Verify", nil) forState:UIControlStateNormal];
        _verifyBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_verifyBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_verifyBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        _verifyBtn.layer.cornerRadius=8.0f;
        _verifyBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _verifyBtn.layer.borderWidth=1.0f;
        _verifyBtn.layer.masksToBounds=YES;
        [_verifyBtn addTarget:self action:@selector(verify:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyBtn;
}
- (UIButton *)skipBtn
{
    if (!_skipBtn)
    {
        _skipBtn = [[UIButton alloc] init];
        [_skipBtn setTitle:BITLocalizedCapString(@"Thanks. Skip.", nil) forState:UIControlStateNormal];
        _skipBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_skipBtn setTitleColor:[UIColor colorWithHexString:@"#AF7EC1"] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}


@end

@interface showVerifyLabelView()

@end
@implementation showVerifyLabelView
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
- (UILabel *)numLabel{
    if (!_numLabel)
    {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _numLabel.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
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
