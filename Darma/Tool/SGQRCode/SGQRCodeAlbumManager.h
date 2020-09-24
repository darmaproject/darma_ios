





#import <UIKit/UIKit.h>
@class SGQRCodeAlbumManager;

@protocol SGQRCodeAlbumManagerDelegate <NSObject>

@required

- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager;

- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result;

@end

@interface SGQRCodeAlbumManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak) id<SGQRCodeAlbumManagerDelegate> delegate;

@property (nonatomic, assign) BOOL isPHAuthorization;

@property (nonatomic, assign) BOOL isOpenLog;


- (void)readQRCodeFromAlbumWithCurrentController:(UIViewController *)currentController;

@end
