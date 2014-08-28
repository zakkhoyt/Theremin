//
//  VWWTouchViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 1/9/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//




#import "VWWTouchViewController.h"
#import "VWWTouchView.h"
#import "VWWSynthesizersController.h"
#import "NSTimer+Blocks.h"
#import "VWWCameraMonitor.h"

#import "VWWBonjourModel.h"
#import "VWWMotionAxes.h"

@import AudioToolbox;
@import AVFoundation;

@interface VWWTouchViewController () <VWWTouchViewDelegate, VWWSynthesizersControllerRenderDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureSession *_session;
    BOOL _cameraRunning;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}
@property (weak, nonatomic) IBOutlet VWWTouchView *touchView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) VWWSynthesizersController *synthesizersController;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic) BOOL hasLoaded;
@property dispatch_queue_t avqueue;
@property (nonatomic, strong) VWWMotionAxes *cameraAxes;


@end

@implementation VWWTouchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.touchView.delegate = self;

    [self setupSynthesizers];
    
    self.infoLabel.text = @"Touch the screen to generate audio waves.\n\nEnsure that your volume is turned up and your device is not muted.\n\nTo use the Accelerometers or other motion sensors, tap Settings -> Synthesizers then toggle the switches for each axis that you want to use.";
    
    self.cameraAxes = [[VWWMotionAxes alloc]init];
    self.avqueue = dispatch_queue_create("com.vaporwarewolf.theremin.camera", NULL);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWStopCamera object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self stopCamera];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWStartCamera object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self startCamera];
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;

    
//    if([VWWSynthesizersController sharedInstance].cameraGroup.xSynthesizer.muted == NO ||
//       [VWWSynthesizersController sharedInstance].cameraGroup.xSynthesizer.muted == NO ||
//       [VWWSynthesizersController sharedInstance].cameraGroup.xSynthesizer.muted == NO){
//        [self startCamera];
//    } else {
//        [self stopCamera];
//    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.hasLoaded == NO){
        self.hasLoaded = YES;
        
    }
    [self showInfoLabel];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:VWWSegueTouchToSettings]){
//        
//    }
//}

#pragma mark Private methods

-(void)addObservers{
    
}



-(void)showInfoLabel{
    
    CGFloat x = self.infoLabel.frame.origin.x;
    CGFloat y = 0;
    CGFloat w = self.infoLabel.frame.size.width;
    CGFloat h = self.infoLabel.frame.size.height;
    CGRect onScreenRect = CGRectMake(x, y, w, h);
    
    self.infoLabel.hidden = NO;
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.infoLabel.alpha = 1.0;
        self.infoLabel.frame = onScreenRect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideInfoLabel{
    CGFloat x = self.infoLabel.frame.origin.x;
    CGFloat y = -(self.infoLabel.frame.size.height);
    CGFloat w = self.infoLabel.frame.size.width;
    CGFloat h = self.infoLabel.frame.size.height;
    CGRect aboveScreenRect = CGRectMake(x, y, w, h);
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.infoLabel.alpha = 0.0;
        self.infoLabel.frame = aboveScreenRect;
    } completion:^(BOOL finished) {
        
        self.infoLabel.hidden = YES;
    }];

}

-(void)setupSynthesizers{
    self.synthesizersController = [VWWSynthesizersController sharedInstance];
    self.synthesizersController.renderDelegate = self;
    [self.synthesizersController setupParentViewForCameraRendering:self.view];
}




//-(void)addGestureRecognizers{
//    // Gesture recognizer
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHandler:)];
//    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
//    [self.view addGestureRecognizer:singleTapGestureRecognizer];
//    
//    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureHandler:)];
//    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
//    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
//    
//    UITapGestureRecognizer *twoFingerTripleTapGestureHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerTripleTapGestureHandler:)];
//    twoFingerTripleTapGestureHandler.numberOfTapsRequired = 3;
//    twoFingerTripleTapGestureHandler.numberOfTouchesRequired = 2;
//    [self.view addGestureRecognizer:twoFingerTripleTapGestureHandler];
//    
//    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
//}
//
//
//
//-(void)singleTapGestureHandler:(UIGestureRecognizer*)gestureRecognizer{
//    VWW_LOG_INFO(@"Single Tap");
//
//}
//
//-(void)doubleTapGestureHandler:(UIGestureRecognizer*)gestureRecognizer{
//    VWW_LOG_INFO(@"Double Tap");
//}
//
//- (void)twoFingerTripleTapGestureHandler:(UITapGestureRecognizer*)recognizer {
//    VWW_LOG_INFO(@"Settings tap");
//    [self performSegueWithIdentifier:VWWSegueTouchToSettings sender:self];
//}


-(void)updateFrequenciesWithArray:(NSArray*)array{
    for(NSDictionary *dictionary in array){
        NSNumber *x = dictionary[VWWTouchViewXKey];
        NSNumber *y = dictionary[VWWTouchViewYKey];
        self.synthesizersController.touchscreenGroup.xSynthesizer.frequencyNormalized = x.floatValue;
        self.synthesizersController.touchscreenGroup.ySynthesizer.frequencyNormalized = y.floatValue;
    }
}

#pragma mark VWWTouchViewDelegate
-(void)touchViewDelegate:(VWWTouchView*)sender touchesBeganWithArray:(NSArray*)array{
    // Unmute on touch begin
    self.synthesizersController.touchscreenGroup.xSynthesizer.muted = NO;
    self.synthesizersController.touchscreenGroup.ySynthesizer.muted = NO;
    
    [self updateFrequenciesWithArray:array];
    [self hideInfoLabel];
}

-(void)touchViewDelegate:(VWWTouchView*)sender touchesMovedWithArray:(NSArray*)array{
    [self updateFrequenciesWithArray:array];
    
//    VWWBonjourModel *bm = [[VWWBonjourModel alloc]init];
//    NSDictionary *d = [bm dictionaryRepresentation];
//    VWW_LOG_INFO(@"inspect bounour model dictionary here");

}

-(void)touchViewDelegate:(VWWTouchView*)sender touchesEndedWithArray:(NSArray*)array{
    [self updateFrequenciesWithArray:array];
    // Mute on touch end
    self.synthesizersController.touchscreenGroup.xSynthesizer.muted = YES;
    self.synthesizersController.touchscreenGroup.ySynthesizer.muted = YES;
}



#pragma mark VWWSynthesizersControllerRenderDelegate
-(UIView*)synthesizersControllerViewForCameraRendering:(VWWSynthesizersController*)sender{
    return self.view;
}

-(void)synthesizersController:(VWWSynthesizersController*)sender didAddViewForRendering:(UIView*)view{
    [self.view bringSubviewToFront:self.touchView];
}




#pragma mark AVFoundation stuff


-(void)startCamera{
    if(_cameraRunning == YES) return;

    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetLow;
    
    AVCaptureDevice *device = [self frontFacingCameraIfAvailable];

    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (!input) {
        VWW_LOG_WARNING(@"Couldnt' create AV video capture device");
    }
    [_session addInput:input];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    UIView *view = self.view;
    CALayer *viewLayer = [view layer];
    
    _videoPreviewLayer.frame = view.bounds;
    [viewLayer addSublayer:_videoPreviewLayer];
    [self.view bringSubviewToFront:self.touchView];
    
    
    // ************************* configure AVCaptureSession to deliver raw frames via callback (as well as preview layer)
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSMutableDictionary *cameraVideoSettings = [[NSMutableDictionary alloc] init];
    NSString *key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
    [cameraVideoSettings setValue:value forKey:key];
    [videoOutput setVideoSettings:cameraVideoSettings];
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    [videoOutput setSampleBufferDelegate:self queue:self.avqueue];
    
    if([_session canAddOutput:videoOutput]){
        
        [_session addOutput:videoOutput];
        _cameraRunning = YES;
        [_session startRunning];
    }
    else {
        NSLog(@"Could not add videoOutput");
        _cameraRunning = NO;
    }
}

-(void)stopCamera{
    VWW_LOG_TODO_TASK(@"Stop the camera capturing");
    if(_cameraRunning == NO) return;
    [_session stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;
    _session = nil;
    _cameraRunning = NO;
}



-(AVCaptureDevice *)frontFacingCameraIfAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! captureDevice)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}



- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(NSInteger)xx andY:(NSInteger)yy count:(int)count{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSInteger byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}

#pragma mark implements AVFoundation

// For image resizing, see the following links:
// http://stackoverflow.com/questions/4712329/how-to-resize-the-image-programatically-in-objective-c-in-iphone
// http://stackoverflow.com/questions/6052188/high-quality-scaling-of-uiimage

-(void)captureOutput :(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    // Let's grab the center pixel
    NSUInteger halfWidth = floor(width/2.0);
    NSUInteger halfHeight = floor(height/2.0);
    
    NSArray* pixels = [self getRGBAsFromImage:image atX:halfWidth andY:halfHeight count:1];
    
    UIColor* uicolor = pixels[0];
    CGFloat red, green, blue, alpha = 0;
    [uicolor getRed:&red green:&green blue:&blue alpha:&alpha];


    self.cameraAxes.x.currentNormalized = red;
    self.cameraAxes.y.currentNormalized = green;
    self.cameraAxes.z.currentNormalized = blue;
    
    
    if(red < self.cameraAxes.x.min){
        self.cameraAxes.x.min = red;
    }
    if(red > self.cameraAxes.x.max){
        self.cameraAxes.x.max = red;
    }
    if(green < self.cameraAxes.y.min){
        self.cameraAxes.y.min = green;
    }
    if(green > self.cameraAxes.y.max){
        self.cameraAxes.y.max = green;
    }
    if(blue < self.cameraAxes.z.min){
        self.cameraAxes.z.min = blue;
    }
    if(blue > self.cameraAxes.z.max){
        self.cameraAxes.z.max = blue;
    }
    
    [[VWWSynthesizersController sharedInstance]cameraMonitorColorsUpdated:self.cameraAxes];
    
}




@end
