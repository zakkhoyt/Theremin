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
#import "VWWNormalizedSynthesizer.h"
#import "NSTimer+Blocks.h"
#import "VWWBonjourModel.h"
#import "VWWMotionAxes.h"
#include <sys/types.h>
#include <sys/sysctl.h>
@import AudioToolbox;
@import AVFoundation;

@interface VWWTouchViewController () <VWWTouchViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>{
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
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (weak, nonatomic) IBOutlet UIImageView *crosshairImageView;


@end

@implementation VWWTouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.touchView.delegate = self;
    
    [self setupSynthesizers];
    
    self.infoLabel.text = @"Touch the screen to generate audio waves.\n\nEnsure that your volume is turned up and your device is not muted.\n\nTo use the Accelerometers, Gyroscopes, Magnetometers or Camera, go to Settings -> Synthesizers then toggle the switches for each axis that you want to use.";
    self.toggleButton.hidden = YES;
    self.crosshairImageView.hidden = YES;
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

    self.navigationController.navigationBarHidden = YES;
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.hasLoaded == NO){
        self.hasLoaded = YES;
        
    }
    
    VWWSynthesizerGroup *cameraGroup = self.synthesizersController.cameraGroup;
    if(cameraGroup.xSynthesizer.muted == NO ||
       cameraGroup.ySynthesizer.muted == NO ||
       cameraGroup.zSynthesizer.muted == NO){
        [self hideInfoLabel];
    } else {
        [self showInfoLabel];
    }
    
    //self.touchView.backgroundColor = [UIColor whiteColor];
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

#pragma mark IBActions
- (IBAction)toggleButtonTouchUpInside:(id)sender {
    [self toggleCamera];
}



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
    // Get a reference which will cause init
    self.synthesizersController = [VWWSynthesizersController sharedInstance];
}


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
    _session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    
    if (!input) {
        VWW_LOG_WARNING(@"Couldnt' create AV video capture device");
    }
    
    NSString *deviceHardwareName = [self deviceHardwareName];
    VWW_LOG_DEBUG(@"deviceHardwareName: %@", deviceHardwareName);
    
    // If we are running on hardware capable of doing a good job at higher frame rates
    if([deviceHardwareName rangeOfString:@"iPad3"].location != NSNotFound ||
       [deviceHardwareName rangeOfString:@"iPad4"].location != NSNotFound ||
       [deviceHardwareName rangeOfString:@"iPad5"].location != NSNotFound ||
       [deviceHardwareName rangeOfString:@"iPod6"].location != NSNotFound ||
       [deviceHardwareName rangeOfString:@"iPhone5"].location != NSNotFound ||
       [deviceHardwareName rangeOfString:@"iPhone6"].location != NSNotFound ||
       [deviceHardwareName rangeOfString:@"iPhone7"].location != NSNotFound ||
       [deviceHardwareName rangeOfString:@"iPhone8"].location != NSNotFound){
        
        // Go up to the highest framerate
        for(AVCaptureDeviceFormat *vFormat in [device formats]) {
            CMFormatDescriptionRef description= vFormat.formatDescription;
            float maxrate = ((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
            if(maxrate>59 && CMFormatDescriptionGetMediaSubType(description)==kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
                if([device lockForConfiguration:NULL] == YES) {
                    device.activeFormat = vFormat;
                    [device setActiveVideoMinFrameDuration:CMTimeMake(10,600)];
                    [device setActiveVideoMaxFrameDuration:CMTimeMake(10,600)];
                    [device unlockForConfiguration];
                    NSLog(@"Selected Video Format:  %@ %@ %@", vFormat.mediaType, vFormat.formatDescription, vFormat.videoSupportedFrameRateRanges);
                }
            }
        }
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
        self.toggleButton.hidden = NO;
        self.crosshairImageView.hidden = NO;
        [_session startRunning];
    }
    else {
        NSLog(@"Could not add videoOutput");
        self.toggleButton.hidden = YES;
        self.crosshairImageView.hidden = YES;
        _cameraRunning = NO;
    }
}

-(void)stopCamera{
    if(_cameraRunning == NO) return;
    
    VWW_LOG_TODO_TASK(@"Stop the camera capturing");
    [_session stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;
    _session = nil;
    _cameraRunning = NO;
    
    self.crosshairImageView.hidden = YES;
    self.toggleButton.hidden = YES;
}

-(NSString*)deviceHardwareName{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return sDeviceModel;
}

-(AVCaptureDevice *)frontFacingCameraIfAvailable {
//    AVCaptureDeviceDiscoverySession* discoverSession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
//                                                           mediaType:AVMediaTypeVideo
//                                                            position:AVCaptureDevicePositionUnspecified];
//    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionFront) {
            captureDevice = device;
            break;
        }
    }
    
    if (captureDevice == nil) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return captureDevice;
}


-(AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if([device position] == position) return device;
    }
    return nil;
}

//Change camera source
-(void)toggleCamera{
    if(_session) {
        //Indicate that some changes will be made to the session
        [_session beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [_session.inputs objectAtIndex:0];
        [_session removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack) {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
        [_session addInput:newVideoInput];
        
        [_session commitConfiguration];
    }
}


- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(NSInteger)xx andY:(NSInteger)yy count:(int)count{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
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
    
    NSInteger byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii) {
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

#pragma mark AVCaptureVideoDataOutputDelegate

-(void)captureOutput :(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    // Get a copy of the buffer that we can work with:
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    CGImageRelease(quartzImage);
    
    
    // Get RGBA of the center pixel and use that as a value set
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
