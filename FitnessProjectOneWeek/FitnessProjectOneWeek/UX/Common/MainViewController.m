//
//  MainViewController.m
//  FitnessProjectOneWeek
//
//  Created by redmond\rugos on 7/22/17.
//  Copyright © 2017 Rushabh Gosar. All rights reserved.
//
#include "math.h"
#import "MainViewController.h"
@import CoreMotion;

double diff(double x, double y, double z, double oldx, double oldy, double oldz)
{
    
    return (double)sqrt((x - oldx) * (x - oldx) + (y - oldy) * (y - oldy) + (z - oldz) * (z - oldz));
}
static double threshold = 0.01f;

@interface MainViewController ()
{
    AVCaptureSession *session;
    AVCapturePhotoOutput *stillImageOutput;
    AVCaptureDevice *inputDevice;
    AVCaptureVideoPreviewLayer *previewLayer;
    IBOutlet UIView *cameraView;
    IBOutlet UIButton *captureButton;
    CMMotionManager* motionManager;
    
    BOOL accelerometerDeltaBelowThreshold;
}
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resizeCameraView];
    [self startAccelerometer];
    [self startCamera];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                             target:self
                                           selector:@selector(onTimerElapsed)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void) onTimerElapsed
{
    if (accelerometerDeltaBelowThreshold)
    {
        [self captureFrame];
    }
}

- (void) startAccelerometer
{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.01;
    [motionManager startAccelerometerUpdates];
    [motionManager startGyroUpdates];
    [motionManager startDeviceMotionUpdates];
    [motionManager startMagnetometerUpdates];
    
    NSOperationQueue *accQueue = [[NSOperationQueue alloc] init];
    [motionManager startAccelerometerUpdatesToQueue:accQueue
                                        withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error)
     {
         static CMAcceleration oldAcc = {0, 0, 0};
         
         CMAcceleration acc = accelerometerData.acceleration;
         double delta = diff(acc.x, acc.y, acc.z, oldAcc.x , oldAcc.y, oldAcc.z);
         accelerometerDeltaBelowThreshold = delta < threshold;
         oldAcc = acc;
     }];
}

- (void) resizeCameraView
{
    CGFloat UIAspectRatio = 4 / 3;
    CGFloat newHeight = cameraView.bounds.size.width / UIAspectRatio;
    self.cameraViewHeight.constant = newHeight;
}

- (void) startCamera
{
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice
                                                                              error:&error];
    
    if ([session canAddInput:deviceInput])
    {
        [session addInput:deviceInput];
    }
    
    [session setSessionPreset:AVCaptureSessionPreset3840x2160];
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = cameraView.layer;
    [rootLayer setMasksToBounds:YES];
    CGRect frame = cameraView.frame;
    [previewLayer setFrame:frame];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput = [[AVCapturePhotoOutput alloc] init];
    if (@available(iOS 11.0, *))
    {
        [stillImageOutput setDepthDataDeliveryEnabled:YES];
    }
    [stillImageOutput setHighResolutionCaptureEnabled:YES];
    if (@available(iOS 11.0, *))
    {
        [stillImageOutput setDualCameraDualPhotoDeliveryEnabled:YES];
    }
    [session addOutput:stillImageOutput];
    [session startRunning];
}

- (void) captureFrame
{
    id capturePhotoOutput = stillImageOutput;
    AVCapturePhotoSettings *settings = [[AVCapturePhotoSettings alloc] init];
    if (@available(iOS 10.2, *))
    {
        [settings setAutoDualCameraFusionEnabled:YES];
    }
    [settings setHighResolutionPhotoEnabled:YES];
    [settings setFlashMode:AVCaptureFlashModeOff];
    if (@available(iOS 11.0, *))
    {
        [settings setDepthDataDeliveryEnabled:YES];
        [settings setDepthDataFiltered:YES];
    }
    [capturePhotoOutput capturePhotoWithSettings:settings delegate:self];
}

-               (void) captureOutput:(AVCapturePhotoOutput *)output
didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer
            previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer
                    resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings
                     bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings
                               error:(NSError *)error
{
    @synchronized(self)
    {
        UIImage *image = [UIImage imageWithData:[AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer
                                                                                            previewPhotoSampleBuffer:previewPhotoSampleBuffer]
                          ];
        NSLog(@"%@", image);
    }
    
}

- (IBAction)onCaptureTapped:(id)sender
{
    [self captureFrame];
}

@end
