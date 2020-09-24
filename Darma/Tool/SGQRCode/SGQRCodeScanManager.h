




#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class SGQRCodeScanManager;

@protocol SGQRCodeScanManagerDelegate <NSObject>

@required

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects;
@optional

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue;
@end

@interface SGQRCodeScanManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak) id<SGQRCodeScanManagerDelegate> delegate;


- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController;

- (void)startRunning;

- (void)stopRunning;

- (void)videoPreviewLayerRemoveFromSuperlayer;

- (void)palySoundName:(NSString *)name;

- (void)resetSampleBufferDelegate;

- (void)cancelSampleBufferDelegate;

@end

