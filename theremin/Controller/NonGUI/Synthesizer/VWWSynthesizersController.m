//
//  VWWSynthesizersController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSynthesizersController.h"
#import "VWWGeneralSettings.h"
#import "VWWMotionMonitor.h"
#import "VWWMotionAxes.h"
#import "GPUImage.h"


@interface GPUImageView (ColorOfPoint)
- (UIColor *)colorOfPoint:(CGPoint)point;
@end



@interface VWWSynthesizersController () <VWWMotionMonitorDelegate, GPUImageVideoCameraDelegate>
@property (nonatomic, strong) VWWMotionMonitor *motionMonitor;
@property (nonatomic, strong, readwrite) NSString *accelerometersStatisticsString;
@property (nonatomic, strong, readwrite) NSString *gyroscopesStatisticsString;
@property (nonatomic, strong, readwrite) NSString *magnetometersStatisticsString;
@property (nonatomic, strong, readwrite) NSString *cameraStatisticsString;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImagePicture *sourcePicture;
@property (nonatomic, strong) GPUImageUIElement *uiElementInput;
@property (nonatomic, strong) GPUImageFilterPipeline *pipeline;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) VWWMotionAxes *cameraDevice;
@end


@implementation VWWSynthesizersController
+(VWWSynthesizersController*)sharedInstance{
    static VWWSynthesizersController *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

-(void)setup{
    [self setupSynthesizers];
    [self setupMotionMonitor];
    [self setupCameraMonitor];

}

-(void)writeSettings{
    NSDictionary *touchscreenDictionary = [self.touchscreenGroup dictionaryRepresentation];
    [VWWUserDefaults setTouchscreenSettings:touchscreenDictionary];
    
    NSDictionary *accelerometersDictionary = [self.accelerometersGroup dictionaryRepresentation];
    [VWWUserDefaults setAccelerometersSettings:accelerometersDictionary];
    
    NSDictionary *gyroscopesDictionary = [self.gyroscopesGroup dictionaryRepresentation];
    [VWWUserDefaults setGyroscopesSettings:gyroscopesDictionary];
    
    NSDictionary *magnetometerDictionary = [self.magnetometersGroup dictionaryRepresentation];
    [VWWUserDefaults setMagnetometersSettings:magnetometerDictionary];
    
    NSDictionary *cameraDictionary = [self.cameraGroup dictionaryRepresentation];
    [VWWUserDefaults setCameraSettings:cameraDictionary];
    
}


#pragma mark Private methods




-(void)setupSynthesizers{
    // We will create 14 synthesizers here:
    // 2 for the touchscreen (x, y)
    // 3 for the accelerometers (x, y, z)
    // 3 for the gyroscopes (x, y, z)
    // 3 for the magnetometers (x, y, z)
    // 3 for the camera (r, g, b)
    // Each group will be initialized with the default settings (stored in NSUserDefaults), all axis muted, then started.
    // Just unmute the axis to allow audio output
    
    // Default settings
    VWWGeneralSettings *generalSettings = [VWWGeneralSettings sharedInstance];

    // Touchscreeen
    {
        NSDictionary *touchscreenDictionary = [VWWUserDefaults touchscreenSettings];
        if(touchscreenDictionary){
            self.touchscreenGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:touchscreenDictionary];
        } else {
            self.touchscreenGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                        amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                        amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
            self.touchscreenGroup.xSynthesizer.effectType = VWWEffectTypeAutoTune;
            self.touchscreenGroup.xSynthesizer.keyType = VWWAutoTuneTypeChromatic;
            self.touchscreenGroup.ySynthesizer.waveType = VWWWaveTypeTriangle;
        }
        self.touchscreenGroup.groupType = VWWSynthesizerGroupTouchScreen;
        
        self.touchscreenGroup.muted = YES;
        [self.touchscreenGroup start];
    }
    
    // Accelerometers
    {
        NSDictionary *accelerometersDictionary = [VWWUserDefaults accelerometersSettings];
        if(accelerometersDictionary){
            self.accelerometersGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:accelerometersDictionary];
        } else {
            self.accelerometersGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                           amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                           amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
        }
        self.accelerometersGroup.groupType = VWWSynthesizerGroupMotion;
        
        self.accelerometersGroup.muted = YES;
        [self.accelerometersGroup start];
    }
    
    // Gyroscopes
    {
        NSDictionary *gyroscopesDictionary = [VWWUserDefaults gyroscopesSettings];
        if(gyroscopesDictionary){
            self.gyroscopesGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:gyroscopesDictionary];
        } else {
            self.gyroscopesGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                       amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                       amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
        }
        self.gyroscopesGroup.groupType = VWWSynthesizerGroupMotion;
        self.gyroscopesGroup.muted = YES;
        [self.gyroscopesGroup start];
    }
    
    // Magnetometers
    {
        NSDictionary *magnetometersDictionary = [VWWUserDefaults magnetometersSettings];
        if(magnetometersDictionary){
            self.magnetometersGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:magnetometersDictionary];
        } else {
            self.magnetometersGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                          amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                          amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
        }
        self.magnetometersGroup.groupType = VWWSynthesizerGroupMotion;
        self.magnetometersGroup.muted = YES;
        [self.magnetometersGroup start];
    }
    
    // Camera
    {
        NSDictionary *cameraDictionary = [VWWUserDefaults cameraSettings];
        if(cameraDictionary){
            self.cameraGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:cameraDictionary];
        } else {
            self.cameraGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                   amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                   amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
        }
        self.cameraGroup.groupType = VWWSynthesizerGroupCamera;
        self.cameraGroup.muted = YES;
        [self.cameraGroup start];
    }
}


-(void)setupMotionMonitor{
    self.motionMonitor = [[VWWMotionMonitor alloc]init];
    self.motionMonitor.delegate = self;
    [self.motionMonitor startAccelerometer];
    [self.motionMonitor startGyroscopes];
    [self.motionMonitor startMagnetometer];
    
}




- (void)setupCameraMonitor{
    
    self.cameraDevice = [[VWWMotionAxes alloc]init];
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    self.videoCamera.horizontallyMirrorFrontFacingCamera = NO;
//    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    self.filter = [[GPUImageAverageColor alloc]init];
    
    [self.videoCamera addTarget:self.filter];
    self.videoCamera.delegate = self;
    UIView *gpuView = [self.renderDelegate synthesizersControllerViewForCameraRendering:self];
    self.filterView = [[GPUImageView alloc]initWithFrame:gpuView.bounds];
    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

    [gpuView addSubview:self.filterView];
    
    [self.filter addTarget:self.filterView];
    
    [self.videoCamera startCameraCapture];
    
    [self.renderDelegate synthesizersController:self didAddViewForRendering:self.filterView];
}

#pragma mark GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    unsigned char pixel[4] = {0};
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
//    
//    CGContextTranslateCTM(context, -self.filterView.center.x, -self.filterView.center.y);
//    
//    UIView *view = self.filterView;
//    [view.layer renderInContext:context];
//    
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);

    dispatch_async(dispatch_get_main_queue(), ^{
        UIColor *color = [self.filterView colorOfPoint:self.filterView.center];
        
        CGFloat red = 0;
        CGFloat blue = 0;
        CGFloat green = 0;
        CGFloat alpha = 0;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        //    NSLog(@"pixel: %f %f %f %f", red, green, blue, alpha);
        
        self.cameraGroup.xSynthesizer.frequencyNormalized = red;
        self.cameraGroup.ySynthesizer.frequencyNormalized = green;
        self.cameraGroup.zSynthesizer.frequencyNormalized = blue;
        
        
        if(red < self.cameraDevice.x.min){
            self.cameraDevice.x.min = red;
        }
        if(red > self.cameraDevice.x.max){
            self.cameraDevice.x.max = red;
        }
        if(green < self.cameraDevice.y.min){
            self.cameraDevice.y.min = green;
        }
        if(green > self.cameraDevice.y.max){
            self.cameraDevice.y.max = green;
        }
        if(blue < self.cameraDevice.z.min){
            self.cameraDevice.z.min = blue;
        }
        if(blue > self.cameraDevice.z.max){
            self.cameraDevice.z.max = blue;
        }
        
        self.cameraStatisticsString = [NSString stringWithFormat:@"R: %.4f < %.4f < %.4f"
                                       @"\nG: %.4f < %.4f < %.4f"
                                       @"\nB: %.4f < %.4f < %.4f",
                                       self.cameraDevice.x.min, self.cameraDevice.x.currentNormalized, self.cameraDevice.x.max,
                                       self.cameraDevice.y.min, self.cameraDevice.y.currentNormalized, self.cameraDevice.y.max,
                                       self.cameraDevice.z.min, self.cameraDevice.z.currentNormalized, self.cameraDevice.z.max];

    });


}

#pragma mark VWWMotionMonitorDelegate
-(NSString*)stringForMotionStatsWithDevice:(VWWMotionAxes*)device{
    return [NSString stringWithFormat:@"x: %.4f < %.4f < %.4f"
            @"\ny: %.4f < %.4f < %.4f"
            @"\nz: %.4f < %.4f < %.4f",
            device.x.min, device.x.currentNormalized, device.x.max,
            device.y.min, device.y.currentNormalized, device.y.max,
            device.z.min, device.z.currentNormalized, device.z.max];
}

-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender accelerometerUpdated:(VWWMotionAxes*)device{
    self.accelerometersGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
    self.accelerometersGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
    self.accelerometersGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
    
    
    self.accelerometersStatisticsString = [self stringForMotionStatsWithDevice:device];
    //    static NSInteger counter = 0;
    //    if(counter % 50 == 0){
    //        VWW_LOG_INFO(@"\nAccelerometers:\n%@", self.accelerometersStatisticsString);
    //    }
    //    counter++;
    
}

-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender gyroUpdated:(VWWMotionAxes*)device{
    self.gyroscopesGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
    self.gyroscopesGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
    self.gyroscopesGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
    
    self.gyroscopesStatisticsString = [self stringForMotionStatsWithDevice:device];
    //    static NSInteger counter = 0;
    //    if(counter % 50 == 0){
    //        VWW_LOG_INFO(@"\nGyroscopes:\n%@", self.gyroscopesStatisticsString);
    //    }
    //    counter++;
}


-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender magnetometerUpdated:(VWWMotionAxes*)device{
    self.magnetometersGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
    self.magnetometersGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
    self.magnetometersGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
    self.magnetometersStatisticsString = [self stringForMotionStatsWithDevice:device];
    
    //    static NSInteger counter = 0;
    //    if(counter % 50 == 0){
    //        VWW_LOG_INFO(@"\nMagnetometers:\n%@", self.magnetometersStatisticsString);
    //    }
    //    counter++;
}

@end



@implementation UIView (ColorOfPoint)

- (UIColor *) colorOfPoint:(CGPoint)point{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end

