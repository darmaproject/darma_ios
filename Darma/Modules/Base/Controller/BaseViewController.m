




#import "BaseViewController.h"

@interface BaseViewController ()<BaseNavigateViewDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigateView];
    [_navigateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(KNAVIGATE_HEIGHT+20));
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}

- (void)navigateViewClickBack:(BaseNavigateView *)view
{
    
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BaseNavigateView *)navigateView
{
    if (!_navigateView)
    {
        _navigateView = [BaseNavigateView new];
        _navigateView.backgroundColor = [UIColor whiteColor];
        _navigateView.delegate = self;
    }
    return _navigateView;
}


@end
