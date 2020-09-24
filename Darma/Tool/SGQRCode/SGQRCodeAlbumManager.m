




#import "SGQRCodeAlbumManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "UIImage+ImageSize.h"

#ifdef DEBUG
#define SGQRCodeLog(...) NSLog(__VA_ARGS__)
#else
#define SGQRCodeLog(...)
#endif

@interface SGQRCodeAlbumManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) NSString *detectorString;
@end

@implementation SGQRCodeAlbumManager

+ (instancetype)sharedManager {
    static SGQRCodeAlbumManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SGQRCodeAlbumManager alloc] init];
    });
    return manager;
}

- (void)initialization {
    _isOpenLog = YES;
}

- (void)readQRCodeFromAlbumWithCurrentController:(UIViewController *)currentController {
    [self initialization];
    self.currentVC = currentController;
    
    if (currentController == nil) {
        NSException *excp = [NSException exceptionWithName:@"SGQRCode" reason:@"readQRCodeFromAlbumWithCurrentController: In the method currentController Parameters cannot be empty" userInfo:nil];
        [excp raise];
    }
    
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) { 
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { 
                    self.isPHAuthorization = YES;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self enterImagePickerController];
                    });
                    if (self.isOpenLog) {
                        SGQRCodeLog(@"The user agreed to access the album for the first time - - %@", [NSThread currentThread]);
                    }
                } else { 
                    if (self.isOpenLog) {
                        SGQRCodeLog(@"The user denied access to the camera for the first time - - %@", [NSThread currentThread]);
                    }
                }
            }];
            
        } else if (status == PHAuthorizationStatusAuthorized) { 
            self.isPHAuthorization = YES;
            if (self.isOpenLog) {
                SGQRCodeLog(@"Access camera permissions - - %@", [NSThread currentThread]);
            }
            [self enterImagePickerController];
        } else if (status == PHAuthorizationStatusDenied) { 
            [self enterImagePickerController];
        } else if (status == PHAuthorizationStatusRestricted) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warm remind" message:@"Unable to access album due to system reasons" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self.currentVC presentViewController:alertC animated:YES completion:nil];
        }
    }
}


- (void)enterImagePickerController {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self.currentVC presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.currentVC dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeAlbumManagerDidCancelWithImagePickerController:)]) {
        [self.delegate QRCodeAlbumManagerDidCancelWithImagePickerController:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [UIImage imageSizeWithScreenImage:info[UIImagePickerControllerOriginalImage]];
    
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (features.count == 0) {
        if (self.isOpenLog) {
            SGQRCodeLog(@"The scanned qr code has not been recognized yet - - %@", features);
        }
        [self.currentVC dismissViewControllerAnimated:YES completion:nil];
        return;
        
    } else {
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            NSString *resultStr = feature.messageString;
            if (self.isOpenLog) {
                SGQRCodeLog(@"Read qr code data information in the album - - %@", resultStr);
            }
            self.detectorString = resultStr;
        }
        [self.currentVC dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeAlbumManager:didFinishPickingMediaWithResult:)]) {
                [self.delegate QRCodeAlbumManager:self didFinishPickingMediaWithResult:self.detectorString];
            }
        }];
    }
}
- (void)setIsOpenLog:(BOOL)isOpenLog {

    _isOpenLog = isOpenLog;
}


@end

