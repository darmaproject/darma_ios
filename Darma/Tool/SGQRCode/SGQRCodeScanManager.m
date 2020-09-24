





#import "SGQRCodeScanManager.h"
#import <ImageIO/ImageIO.h>

@interface SGQRCodeScanManager () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation SGQRCodeScanManager

static SGQRCodeScanManager *_instance;

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone {
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController {
    
    if (sessionPreset == nil) {
        NSException *excp = [NSException exceptionWithName:@"SGQRCode" reason:@"setupSessionPreset:metadataObjectTypes:currentController: In the method sessionPreset Parameters cannot be empty" userInfo:nil];
        [excp raise];
    }
    
    if (metadataObjectTypes == nil) {
        NSException *excp = [NSException exceptionWithName:@"SGQRCode" reason:@"setupSessionPreset:metadataObjectTypes:currentController: In the method metadataObjectTypes Parameters cannot be empty" userInfo:nil];
        [excp raise];
    }
    
    if (currentController == nil) {
        NSException *excp = [NSException exceptionWithName:@"SGQRCode" reason:@"setupSessionPreset:metadataObjectTypes:currentController: In the method currentController Parameters cannot be empty" userInfo:nil];
        [excp raise];
    }

    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    

    
    
    _session = [[AVCaptureSession alloc] init];
    
    _session.sessionPreset = sessionPreset;
    
    
    [_session addOutput:metadataOutput];
    
    [_session addOutput:_videoDataOutput];

    
    [_session addInput:deviceInput];

    
    
    
    metadataOutput.metadataObjectTypes = metadataObjectTypes;
    
    
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    _videoPreviewLayer.frame = CGRectMake(x, y, w, h);
    [currentController.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
    
    
    [_session startRunning];
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeScanManager:didOutputMetadataObjects:)]) {
        [self.delegate QRCodeScanManager:self didOutputMetadataObjects:metadataObjects];
    }
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"%f",brightnessValue);

    if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeScanManager:brightnessValue:)]) {
        [self.delegate QRCodeScanManager:self brightnessValue:brightnessValue];
    }
}

- (void)startRunning {
    [_session startRunning];
}

- (void)stopRunning {
    [_session stopRunning];

}

- (void)videoPreviewLayerRemoveFromSuperlayer {
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)resetSampleBufferDelegate {
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
}

- (void)cancelSampleBufferDelegate {
    [_videoDataOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}

- (void)palySoundName:(NSString *)name {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(soundID); 
}
void soundCompleteCallback(SystemSoundID soundID, void *clientData){

}


@end

