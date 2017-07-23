//
//  MainViewController.m
//  FitnessProjectOneWeek
//
//  Created by redmond\rugos on 7/22/17.
//  Copyright © 2017 Rushabh Gosar. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
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
    AVCaptureSession *session;
    AVCapturePhotoOutput *stillImageOutput;
    
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    [session setSessionPreset:AVCaptureSessionPreset3840x2160];
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.view.frame;
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
@end
