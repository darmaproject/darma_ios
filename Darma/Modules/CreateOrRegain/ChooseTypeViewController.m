



#import "ChooseTypeViewController.h"

#import "CreateWalletViewController.h"
#import "RegainWalletViewController.h"

@interface ChooseTypeViewController ()
@property(nonatomic, strong) UIImageView *imageView; 
@property(nonatomic, strong) UILabel *introduceLabel; 
@property(nonatomic, strong)UIButton  *createBtn;
@property(nonatomic, strong)UIButton  *regainBtn;
@end

@implementation ChooseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigateView.hidden=YES;
    
    [self configUI];
}
- (void)configUI
{
    [self.view addSubview:self.imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.297);
        make.height.mas_equalTo(FitH(64));
        make.width.mas_equalTo(FitW(190));

    }];
    
    [self.view  addSubview:self.regainBtn];
    [_regainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-27);
        make.height.mas_equalTo(48);
    }];
    
    [self.view  addSubview:self.createBtn];
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.bottom.equalTo(self.regainBtn.mas_top).offset(-27);
        make.height.mas_equalTo(48);
    }];
    
    [self.view addSubview:self.introduceLabel];
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.bottom.equalTo(self.createBtn.mas_top).offset(-42);
    }];
    
}
-(void)create:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected) {
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#BCE6E7"]];
    }else{
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
    }
    CreateWalletViewController *createVC=[[CreateWalletViewController alloc] init];
    [self.navigationController pushViewController:createVC animated:YES];
}
-(void)regain:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected) {
        [_regainBtn setBackgroundColor:[UIColor colorWithHexString:@"#E5D5EA"]];
    }else{
        [_regainBtn setBackgroundColor:[UIColor colorWithHexString:@"#F9F5FA"]];
    }
    
    RegainWalletViewController *regainVC=[[RegainWalletViewController alloc] init];
    [self.navigationController pushViewController:regainVC animated:YES];
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"logo"];
    }
    return _imageView;
}
- (UILabel *)introduceLabel
{
    if (!_introduceLabel)
    {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _introduceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _introduceLabel.text=BITLocalizedCapString(@"Please make a selection below to either create a new wallet or restore a wallet", nil);
        _introduceLabel.numberOfLines=0;
        _introduceLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _introduceLabel;
}
- (UIButton *)createBtn
{
    if (!_createBtn)
    {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setTitle:BITLocalizedCapString(@"Create Wallet", nil) forState:UIControlStateNormal];
        _createBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_createBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1FAFA"]];
        
        _createBtn.layer.cornerRadius=8.0f;
        _createBtn.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _createBtn.layer.borderWidth=1.0f;
        _createBtn.layer.masksToBounds=YES;
        [_createBtn addTarget:self action:@selector(create:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
- (UIButton *)regainBtn
{
    if (!_regainBtn)
    {
        _regainBtn = [[UIButton alloc] init];
        [_regainBtn setTitle:BITLocalizedCapString(@"Recover Wallet", nil) forState:UIControlStateNormal];
        _regainBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_regainBtn setTitleColor:[UIColor colorWithHexString:@"#202640"] forState:UIControlStateNormal];
        [_regainBtn setBackgroundColor:[UIColor colorWithHexString:@"#F9F5FA"]];
        _regainBtn.layer.cornerRadius=8.0f;
        _regainBtn.layer.borderColor=[UIColor colorWithHexString:@"#AF7EC1"].CGColor;
        _regainBtn.layer.borderWidth=1.0f;
        _regainBtn.layer.masksToBounds=YES;
        
        [_regainBtn addTarget:self action:@selector(regain:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _regainBtn;
}

@end


