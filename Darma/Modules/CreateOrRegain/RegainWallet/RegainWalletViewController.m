



#import "RegainWalletViewController.h"

#import "PrivateKeyRegainWalletVC.h"
#import "WordRegainWalletVC.h"
#import "RegainReadOnleyWalletVC.h"

@interface RegainWalletViewController ()
@property(nonatomic ,strong) ClickRegainTypeView * privateKeyRaginBtn;
@property(nonatomic ,strong) ClickRegainTypeView * wordRaginBtn;

@property(nonatomic ,strong) ClickRegainTypeView * raginReadOnlyBtn;

@end

@implementation RegainWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.title =BITLocalizedCapString(@"Recover Wallet", nil) ;
    
    [self addLayoutUI];
    
}

- (void)addLayoutUI
{
    [self.view addSubview:self.privateKeyRaginBtn];
    [self.view addSubview:self.wordRaginBtn];
    [self.view addSubview:self.raginReadOnlyBtn];
    [_wordRaginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(48);
    }];
    
    [_privateKeyRaginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.wordRaginBtn.mas_top).offset(-27);
        make.height.mas_equalTo(48);
    }];
    [_raginReadOnlyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.wordRaginBtn);
        make.top.equalTo(self.wordRaginBtn.mas_bottom).offset(27);
    }];
}
-(void)privateKeyRaginWallte:(UIButton *)sender{
    
    PrivateKeyRegainWalletVC *conVC=[[PrivateKeyRegainWalletVC alloc] init];
    [self.navigationController pushViewController:conVC animated:YES];
}
-(void)wordRaginWallte:(UIButton *)sender{
    
    WordRegainWalletVC *conVC=[[WordRegainWalletVC alloc] init];
    [self.navigationController pushViewController:conVC animated:YES];
}
-(void)raginReadOnlyWallte:(UIButton *)sender{
   
    RegainReadOnleyWalletVC *conVC=[[RegainReadOnleyWalletVC alloc] init];
    [self.navigationController pushViewController:conVC animated:YES];
}

-(ClickRegainTypeView *)privateKeyRaginBtn{
    if (!_privateKeyRaginBtn) {
        _privateKeyRaginBtn=[[ClickRegainTypeView alloc] init];
        _privateKeyRaginBtn.layer.cornerRadius=8;
        _privateKeyRaginBtn.layer.borderWidth=1;
        _privateKeyRaginBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _privateKeyRaginBtn.makeImageV.image=[UIImage imageNamed:@"miyao"];
        _privateKeyRaginBtn.nameLabel.text=BITLocalizedCapString(@"Recover from private keys",nil);
        [_privateKeyRaginBtn.regainBtn addTarget:self action:@selector(privateKeyRaginWallte:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateKeyRaginBtn;
}
-(ClickRegainTypeView *)wordRaginBtn{
    if (!_wordRaginBtn) {
        _wordRaginBtn=[[ClickRegainTypeView alloc] init];
        _wordRaginBtn.layer.cornerRadius=8;
        _wordRaginBtn.layer.borderWidth=1;
        _wordRaginBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _wordRaginBtn.makeImageV.image=[UIImage imageNamed:@"zhujici"];
        _wordRaginBtn.nameLabel.text=BITLocalizedCapString(@"Recover from SEED words",nil);
        [_wordRaginBtn.regainBtn addTarget:self action:@selector(wordRaginWallte:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wordRaginBtn;
}
-(ClickRegainTypeView *)raginReadOnlyBtn{
    if (!_raginReadOnlyBtn) {
        _raginReadOnlyBtn=[[ClickRegainTypeView alloc] init];
        _raginReadOnlyBtn.layer.cornerRadius=8;
        _raginReadOnlyBtn.layer.borderWidth=1;
        _raginReadOnlyBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _raginReadOnlyBtn.makeImageV.image=[UIImage imageNamed:@"qianbao"];
        _raginReadOnlyBtn.nameLabel.text=BITLocalizedCapString(@"Recover View-only Wallet",nil);
        [_raginReadOnlyBtn.regainBtn addTarget:self action:@selector(raginReadOnlyWallte:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _raginReadOnlyBtn;
}

@end
@interface ClickRegainTypeView()

@end
@implementation ClickRegainTypeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.makeImageV];
        [self addSubview:self.nameLabel];
        [self addSubview:self.regainBtn];
        [self addLayout];
    }
    return self;
}

- (void)addLayout
{
  
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    
    [_makeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_left).offset(-27);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(Fit(32));
    }];
    
    [_regainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (UIImageView *)makeImageV{
    if (!_makeImageV)
    {
        _makeImageV = [[UIImageView alloc] init];
    }
    return _makeImageV;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UIButton *)regainBtn
{
    if (!_regainBtn)
    {
        _regainBtn = [[UIButton alloc] init];
    }
    return _regainBtn;
}
@end
