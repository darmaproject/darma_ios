


#import "HomeHeaderView.h"

#import "NSString+BITTool.h"
@interface HomeHeaderView()

@property(nonatomic, strong) UILabel *coinNameLabel; 
@property(nonatomic, strong) UILabel *totalLabel;
@property(nonatomic, strong) UILabel *lockNumLabel;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *imageView; 
@property(nonatomic, strong) UILabel *percentLabel; 
@property(nonatomic, strong) UILabel *walletHeightLabel; 
@property(nonatomic ,strong) UIActivityIndicatorView *activity;


@property(nonatomic, strong) UIImageView *receiveImage;
@property(nonatomic, strong) UILabel *receiveLabel;

@end

@implementation HomeHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.coinNameLabel];
        [self addSubview:self.totalLabel];
        [self addSubview:self.lockNumLabel];
      
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.activity];
        [self.contentView addSubview:self.percentLabel];
        [self.contentView addSubview:self.walletHeightLabel];

     
        [self addSubview:self.sendView];
        [self addSubview:self.receiveView];
        [self.receiveView addSubview:self.receiveImage];
        [self.receiveView addSubview:self.receiveLabel];
        
        [self.sendView addSubview:self.sendImage];
        [self.sendView addSubview:self.sendLabel];
        
        [self.sendView addSubview:self.sendBtn];
        [self.receiveView addSubview:self.receiveBtn];
        [self addLayout];
        [self showContentView:@"0" Locked_balance:@"0" wallet_topo_height:0 Daemon_topo_height:0 Wallet_online:NO Wallet_network:NO];
    }
    return self;
}
- (void)addLayout
{
    [_coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
    }];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.coinNameLabel.mas_bottom).offset(10);
    }];
    [_lockNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.totalLabel.mas_bottom).offset(10);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.lockNumLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(170);
    }];
    [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.contentView).offset(6);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.percentLabel);
        make.centerX.equalTo(self.percentLabel.mas_left).offset(-9);
        make.width.height.mas_equalTo(15);
    }];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.percentLabel);
        make.centerX.equalTo(self.percentLabel.mas_left).offset(-9);
        make.width.height.mas_equalTo(15);
    }];
   
    [_walletHeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.percentLabel.mas_bottom).offset(2);
        make.left.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-18);
    }];
   
    [_sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.contentView.mas_bottom).offset(12);
        make.height.equalTo(@44);
        make.width.equalTo(@160);
        
    }];
    
    [_receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self.sendView);
        make.width.equalTo(self.sendView.mas_width);
        make.height.equalTo(self.sendView.mas_height);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [_sendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendView).offset(12);
        make.centerY.equalTo(self.sendView);
        make.width.height.mas_equalTo(28);
    }];
    [_sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendImage);
        make.right.equalTo(self.sendView);
        make.centerY.equalTo(self.sendView);
    }];
    
    [_receiveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiveView).offset(12);
        make.centerY.equalTo(self.receiveView);
        make.width.height.mas_equalTo(28);
    }];
    [_receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiveImage);
        make.right.equalTo(self.receiveView);
        make.centerY.equalTo(self.receiveView);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.sendView);
    }];
    
    [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.receiveView);
    }];
    
}

- (void)showContentView:(NSString *)unlocked_balance
         Locked_balance:(NSString *)locked_balance
     wallet_topo_height:(NSUInteger)wallet_topo_height
     Daemon_topo_height:(NSUInteger)Daemon_topo_height
     Wallet_online:(BOOL)Wallet_online
Wallet_network:(BOOL)wallet_network
{
    NSString *str_total=[[NSString stringWithFormat:@"%@",unlocked_balance] removeEndZero];
    NSString *str_locked_balance=[[NSString stringWithFormat:@"%@",locked_balance] removeEndZero];

    if ([str_total isEqualToString:@"0"]) {
        str_total=@"0.0";
    }
    if ([str_locked_balance isEqualToString:@"0"]) {
        str_locked_balance=@"0.0";
    }
    
    _totalLabel.text=AppwalletFormat_Money(str_total);
    _lockNumLabel.text=[NSString stringWithFormat:@"%@%@",BITLocalizedCapString(@"Locked：", nil),AppwalletFormat_Money(str_locked_balance)];
   
    if (!wallet_network) {
        [_activity stopAnimating];
        [_activity hidesWhenStopped];
        _imageView.hidden=NO;
        _walletHeightLabel.hidden=NO;
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
        _percentLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        
        [_percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).offset(8);
            make.top.equalTo(self.contentView).offset(6);
        }];
        
        [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.percentLabel);
            make.centerX.equalTo(self.percentLabel.mas_left).offset(-9);
            make.width.height.mas_equalTo(15);
        }];
        
        [_walletHeightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.percentLabel.mas_bottom).offset(2);
            make.left.equalTo(self.contentView).offset(18);
            make.right.equalTo(self.contentView).offset(-18);
        }];
        _imageView.image = [UIImage imageNamed:@"home_offline"];
        _percentLabel.text=[NSString stringWithFormat:@"%@",BITLocalizedCapString(@"Network is disconnected", nil)];
        _walletHeightLabel.text=[NSString stringWithFormat:@"%@%ld",BITLocalizedCapString(@"Height：", nil),(long)wallet_topo_height];
    }else{
        if (Wallet_online) {
            [_activity startAnimating];
            if (Daemon_topo_height==0) {
                _walletHeightLabel.hidden=YES;
                _imageView.hidden=YES;
                
                _contentView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
                _percentLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
                
                [_percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.contentView).offset(8);
                    make.centerY.equalTo(self.contentView);
                }];
                [_activity mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.percentLabel);
                    make.centerX.equalTo(self.percentLabel.mas_left).offset(-9);
                    make.width.height.mas_equalTo(15);
                }];
                
                _percentLabel.text=[NSString stringWithFormat:@"%@",BITLocalizedCapString(@"Starting sync", nil)];
            }else{
                _walletHeightLabel.hidden=NO;
                
                if (wallet_topo_height==Daemon_topo_height) {
                    [_activity stopAnimating];
                    [_activity hidesWhenStopped];
                    _imageView.hidden=NO;
                    _contentView.backgroundColor = [UIColor colorWithHexString:@"#F9F5FA"];
                    _percentLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
                    _walletHeightLabel.textColor = [UIColor colorWithHexString:@"#AF7EC1"];
                    
                    [_percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.contentView).offset(8);
                        make.top.equalTo(self.contentView).offset(6);
                    }];
                    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(self.percentLabel);
                        make.centerX.equalTo(self.percentLabel.mas_left).offset(-9);
                        make.width.height.mas_equalTo(15);
                    }];
                    [_walletHeightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.percentLabel.mas_bottom).offset(2);
                        make.left.equalTo(self.contentView).offset(18);
                        make.right.equalTo(self.contentView).offset(-18);
                    }];
                    
                    _imageView.image = [UIImage imageNamed:@"finish_image_home"];
                    _percentLabel.text=[NSString stringWithFormat:@"%@",BITLocalizedCapString(@"Synchronized", nil)];
                    _walletHeightLabel.text=[NSString stringWithFormat:@"%@%ld",BITLocalizedCapString(@"Height：", nil),(long)wallet_topo_height];
                    
                }else{
                    _imageView.hidden=YES;
                    
                    _activity.hidden=NO;
                    _contentView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
                    _percentLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
                    _walletHeightLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
                    
                    [_percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.contentView).offset(8);
                        make.top.equalTo(self.contentView).offset(6);
                    }];
                    [_activity mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(self.percentLabel);
                        make.centerX.equalTo(self.percentLabel.mas_left).offset(-9);
                        make.width.height.mas_equalTo(15);
                    }];
                    [_walletHeightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.percentLabel.mas_bottom).offset(2);
                        make.left.equalTo(self.contentView).offset(18);
                        make.right.equalTo(self.contentView).offset(-18);
                    }];
                    
                    NSMutableString *str = [NSMutableString string];
                    NSString *str_percent = [NSString stringWithFormat:@"%.2f", ((double)wallet_topo_height/(double)Daemon_topo_height * 100)];
                    [str appendString:str_percent];
                    [str appendString:@"%"];
                    NSUInteger remain_height=Daemon_topo_height-wallet_topo_height;
                    
                    _percentLabel.text=[NSString stringWithFormat:@"%@%@",BITLocalizedCapString(@"Starting sync ", nil),str];
                    _walletHeightLabel.text=[NSString stringWithFormat:@"%@%ld",BITLocalizedCapString(@"Remaining：", nil),(long)remain_height];
                }
            }
        }else{
            [_activity stopAnimating];
            [_activity hidesWhenStopped];
            _imageView.hidden=NO;
            _walletHeightLabel.hidden=YES;
            _contentView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
            _percentLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
            
            [_percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView).offset(8);
                make.centerY.equalTo(self.contentView);
            }];
            
            [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.percentLabel);
                make.centerX.equalTo(self.percentLabel.mas_left).offset(-9);
                make.width.height.mas_equalTo(15);
            }];
            _imageView.image = [UIImage imageNamed:@"interrupt_image_Home"];
            _percentLabel.text=[NSString stringWithFormat:@"%@",BITLocalizedCapString(@"Offline", nil)];
            
        }
        
    }
}


- (UILabel *)coinNameLabel
{
    if (!_coinNameLabel)
    {
        _coinNameLabel = [[UILabel alloc] init];
        _coinNameLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _coinNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _coinNameLabel.text=@"DARMA";
    }
    return _coinNameLabel;
}
- (UILabel *)totalLabel
{
    if (!_totalLabel)
    {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = [UIColor colorWithHexString:@"#3EB7BA"];
        _totalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28];
        _totalLabel.text=@"0.000";
    }
    return _totalLabel;
}
- (UILabel *)lockNumLabel
{
    if (!_lockNumLabel)
    {
        _lockNumLabel = [[UILabel alloc] init];
        _lockNumLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _lockNumLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
         _lockNumLabel.text=[NSString stringWithFormat:@"lock：%@",@"0.000"];
    }
    return _lockNumLabel;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
        _contentView.clipsToBounds = YES;
        _contentView.layer.cornerRadius =22;
    }
    return _contentView;
}
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"shibai"];
    }
    return _imageView;
}
- (UIActivityIndicatorView *)activity
{
    if (!_activity)
    {
        _activity = [[UIActivityIndicatorView alloc] init];
        _activity.color=[UIColor colorWithHexString:@"#9CA8B3"];
        CGAffineTransform transform = CGAffineTransformMakeScale(0.75,0.75);    
        _activity.transform = transform;
    }
    return _activity;
}

- (UILabel *)percentLabel
{
    if (!_percentLabel)
    {
        _percentLabel = [[UILabel alloc] init];
        _percentLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _percentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _percentLabel.text=[NSString stringWithFormat:@"Start synchronization %@",@"0%"];

    }
    return _percentLabel;
}
- (UILabel *)walletHeightLabel
{
    if (!_walletHeightLabel)
    {
        _walletHeightLabel = [[UILabel alloc] init];
        _walletHeightLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _walletHeightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _walletHeightLabel.text=[NSString stringWithFormat:@"%@/%@",@"0",@"0"];
        _walletHeightLabel.textAlignment=NSTextAlignmentCenter;

    }
    return _walletHeightLabel;
}
- (UIView *)receiveView
{
    if (!_receiveView)
    {
        _receiveView = [[UIView alloc] init];
        _receiveView.backgroundColor = [UIColor colorWithHexString:@"#F9F5FA"];
        _receiveView.layer.cornerRadius=8.0f;
        _receiveView.layer.borderColor=[UIColor colorWithHexString:@"#AF7EC1"].CGColor;
        _receiveView.layer.borderWidth=1.0f;
        _receiveView.layer.masksToBounds=YES;
    }
    return _receiveView;
}
- (UIImageView *)receiveImage
{
    if (!_receiveImage)
    {
        _receiveImage = [[UIImageView alloc] init];
        _receiveImage.image = [UIImage imageNamed:@"btn_rec"];
    }
    return _receiveImage;
}
- (UILabel *)receiveLabel
{
    if (!_receiveLabel)
    {
        _receiveLabel = [[UILabel alloc] init];
        _receiveLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _receiveLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _receiveLabel.text=BITLocalizedCapString(@"Receive" , nil);
        _receiveLabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _receiveLabel;
}
- (UIView *)sendView
{
    if (!_sendView)
    {
        _sendView = [[UIView alloc] init];
        _sendView.backgroundColor = [UIColor colorWithHexString:@"#F1FAFA"];
        _sendView.layer.cornerRadius=8.0f;
        _sendView.layer.borderColor=[UIColor colorWithHexString:@"#3EB7BA"].CGColor;
        _sendView.layer.borderWidth=1.0f;
        _sendView.layer.masksToBounds=YES;
    }
    return _sendView;
}
- (UIImageView *)sendImage
{
    if (!_sendImage)
    {
        _sendImage = [[UIImageView alloc] init];
        _sendImage.image = [UIImage imageNamed:@"btn_send"];
    }
    return _sendImage;
}
- (UILabel *)sendLabel
{
    if (!_sendLabel)
    {
        _sendLabel = [[UILabel alloc] init];
        _sendLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _sendLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _sendLabel.text=BITLocalizedCapString(@"Send", nil);
        _sendLabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _sendLabel;
}
- (UIButton *)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setBackgroundColor:[UIColor clearColor]];
    }
    return _sendBtn;
}
- (UIButton *)receiveBtn
{
    if (!_receiveBtn)
    {
        _receiveBtn = [[UIButton alloc] init];
        [_receiveBtn setBackgroundColor:[UIColor clearColor]];
    }
    return _receiveBtn;
}


@end
