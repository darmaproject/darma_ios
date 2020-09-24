




#import "TradeDetailsBottomView.h"

@implementation TradeDetailsBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.orderIDLabel];
        [self addSubview:self.orderIDValueLabel];
        [self addSubview:self.orderIDCopyBtn];
        [self addSubview:self.orderIDLine];

        
        [self addSubview:self.addressLabel];
        [self addSubview:self.addressValueLabel];
        [self addSubview:self.addressCopyBtn];
        [self addSubview:self.addressLine];
        
        [self addSubview:self.tipInfoLable];
        [self addSubview:self.tipLable];
        
        [self addSubview:self.timeImageV];
        [self addSubview:self.timeLable];
        [self addLayout];
    }
    return self;
}
- (void)addLayout
{
    [_orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FitH(10));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self).offset(-FitW(26));
        make.height.mas_equalTo(FitH(20));
    }];
    [_orderIDCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIDLabel.mas_bottom);
        make.right.equalTo(self).offset(-FitW(26));
        make.width.mas_equalTo(FitW(28));
        make.height.mas_equalTo(FitH(28));
    }];
    [_orderIDValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderIDCopyBtn);
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self.orderIDCopyBtn.mas_left).offset(-FitW(30));
    }];
    [_orderIDLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIDCopyBtn.mas_bottom).offset(FitH(8));
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(-FitW(18));
        make.height.mas_equalTo(1);
    }];
    

    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIDLine.mas_bottom).offset(FitH(10));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self).offset(-FitW(26));
        make.height.mas_equalTo(FitH(20));
    }];
    [_addressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(FitH(7));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self).offset(-FitW(26+28+30));
    }];
    
    [_addressCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addressValueLabel.mas_bottom);
        make.right.equalTo(self).offset(-FitW(26));
        make.width.mas_equalTo(FitW(28));
        make.height.mas_equalTo(FitH(28));
    }];
    [_addressLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressValueLabel.mas_bottom).offset(FitH(8));
        make.left.equalTo(self).offset(FitW(18));
        make.right.equalTo(self).offset(-FitW(18));
        make.height.mas_equalTo(1);

        
    }];
   
    [_tipInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLine.mas_bottom).offset(FitH(16));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self).offset(-FitW(26));
    }];
    [_tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipInfoLable.mas_bottom).offset(FitH(16));
        make.left.equalTo(self).offset(FitW(26));
        make.right.equalTo(self).offset(-FitW(26));
    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLable.mas_bottom).offset(FitH(15));
        make.centerX.equalTo(self).offset(FitW(11));
    }];
    
    [_timeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLable);
        make.right.equalTo(self.timeLable.mas_left).offset(-FitW(2));
        make.width.height.mas_equalTo(Fit(22));

    }];
   
}
-(void)setModel:(TradeDetailsModel *)model{
    _orderIDValueLabel.text = [NSString stringWithFormat:@"%@",model.order_id];

    _addressValueLabel.text = [NSString stringWithFormat:@"%@",model.base_receiving_integrated_address];
    NSArray *arry=[model.pair componentsSeparatedByString:@"_"];
    NSString *coinName=[[arry firstObject] uppercaseString];
    if ([coinName isEqualToString:@"USDT"]) {
        _tipInfoLable.text =[NSString stringWithFormat:BITLocalizedCapString(@"Please send %@ USDT from your USDT external wallet to the address or QR code shown above.", nil),model.base_amount_total,coinName] ;
        _tipLable.text = BITLocalizedCapString(@"Please click 'View Order' to show more details or return to change the amount", nil);

    }else{

        _tipInfoLable.text =[NSString stringWithFormat:BITLocalizedCapString(@"Please click 'Pay Now' to send %@ DMC from your DARMA wallet to the address shown above, or you can send to the above address or QR code by other means.", nil),model.base_amount_total] ;
        _tipLable.text = BITLocalizedCapString(@"Please click 'Pay Now' to continue or return to change the amount", nil);

    }
   
    __block NSInteger count =[[NSString stringWithFormat:@"%@",model.seconds_till_timeout] integerValue];
    
    if (count > 0)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); 
        dispatch_source_set_event_handler(timer, ^{
            if(count <= 0){ 
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.timeLable.text =BITLocalizedCapString(@"str_time_out", nil);
                    if ([self.delegate respondsToSelector:@selector(Timeout:)])
                    {
                        [self.delegate Timeout:self];
                    }
                });
            }else{ 
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeLable.text = [NSString stringWithFormat:@"%ld'%ld''", (count/60), count%60];
                    count--; 
                });
            }
        });
         dispatch_resume(timer);
    }
}

-(void)buttonClick:(UIButton *)sender{
    NSString *str_key;
    if (sender.tag==10) {
         str_key=self.orderIDValueLabel.text;
    }else if(sender.tag==20){


    }else if(sender.tag==30){
        str_key=self.addressValueLabel.text;
    }
  
    if (str_key.length > 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str_key;
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copied", nil)];
    }
    else
    {
        [SHOWProgressHUD showMessage:BITLocalizedCapString(@"Copy failure", nil)];
    }
}
- (UILabel *)orderIDLabel
{
    if (!_orderIDLabel)
    {
        _orderIDLabel = [[UILabel alloc] init];
        _orderIDLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _orderIDLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:11];
        _orderIDLabel.text =BITLocalizedCapString(@"ID", nil);
        _orderIDLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _orderIDLabel;
}

- (UILabel *)orderIDValueLabel
{
    if (!_orderIDValueLabel)
    {
        _orderIDValueLabel = [[UILabel alloc] init];
        _orderIDValueLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _orderIDValueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _orderIDValueLabel.text = @"XXXXXXXX";
        _orderIDValueLabel.textAlignment=NSTextAlignmentLeft;
        _orderIDValueLabel.numberOfLines=0;
    }
    return _orderIDValueLabel;
}
-(UIButton*)orderIDCopyBtn{
    if (!_orderIDCopyBtn) {
        _orderIDCopyBtn = [[UIButton alloc] init];
        _orderIDCopyBtn.tag=10;
        [_orderIDCopyBtn setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
        [_orderIDCopyBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderIDCopyBtn;
}
-(UILabel*)orderIDLine{
    if (!_orderIDLine) {
        _orderIDLine=[[UILabel alloc] init];
        _orderIDLine.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _orderIDLine;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel)
    {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#9CA8B3"];
        _addressLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:11];
        _addressLabel.text =BITLocalizedCapString(@"Send address", nil) ;
        _addressLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _addressLabel;
}

- (UILabel *)addressValueLabel
{
    if (!_addressValueLabel)
    {
        _addressValueLabel = [[UILabel alloc] init];
        _addressValueLabel.textColor = [UIColor colorWithHexString:@"#202640"];
        _addressValueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _addressValueLabel.text = @"XXXXXXXX";
        _addressValueLabel.textAlignment=NSTextAlignmentLeft;
        _addressValueLabel.numberOfLines=0;
    }
    return _addressValueLabel;
}
-(UIButton*)addressCopyBtn{
    if (!_addressCopyBtn) {
        _addressCopyBtn = [[UIButton alloc] init];
        _addressCopyBtn.tag=30;
        [_addressCopyBtn setImage:[UIImage imageNamed:@"copy_button_image"] forState:UIControlStateNormal];
        [_addressCopyBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressCopyBtn;
}
-(UILabel*)addressLine{
    if (!_addressLine) {
        _addressLine=[[UILabel alloc] init];
        _addressLine.backgroundColor=[UIColor colorWithHexString:@"#D2D6DC"];
    }
    return _addressLine;
}
- (UILabel *)tipInfoLable
{
    if (!_tipInfoLable)
    {
        _tipInfoLable = [[UILabel alloc] init];
        _tipInfoLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _tipInfoLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _tipInfoLable.text = BITLocalizedCapString(@"Please send %@ USDT from your USDT external wallet to the address or QR code shown above.", nil);
        _tipInfoLable.textAlignment=NSTextAlignmentLeft;
        _tipInfoLable.numberOfLines=0;
    }
    return _tipInfoLable;
}
- (UILabel *)tipLable
{
    if (!_tipLable)
    {
        _tipLable = [[UILabel alloc] init];
        _tipLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _tipLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _tipLable.text = BITLocalizedCapString(@"Please click 'View Order' to show more details or return to change the amount", nil);
        _tipLable.textAlignment=NSTextAlignmentLeft;
        _tipLable.numberOfLines=0;
    }
    return _tipLable;
}
-(UIImageView *)timeImageV{
    if (!_timeImageV) {
        _timeImageV=[[UIImageView alloc] init];
        [_timeImageV setImage:[UIImage imageNamed:@"time"]];
    }
    return _timeImageV;
}

- (UILabel *)timeLable
{
    if (!_timeLable)
    {
        _timeLable = [[UILabel alloc] init];
        _timeLable.textColor = [UIColor colorWithHexString:@"#202640"];
        _timeLable.font =[UIFont fontWithName:@"PingFangSC-Light" size:11];
        _timeLable.text = [NSString stringWithFormat:@"%ld'%ld''",(long)29,(long)12];
        _timeLable.textAlignment=NSTextAlignmentLeft;
    }
    return _timeLable;
}

@end
