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
#import "VWWCameraMonitor.h"
#import "VWWMotionAxes.h"


@interface VWWSynthesizersController () <VWWMotionMonitorDelegate, VWWCameraMonitorDelegate>
@property (nonatomic, strong) VWWMotionMonitor *motionMonitor;
@property (nonatomic, strong) VWWCameraMonitor *cameraMonitor;
@property (nonatomic, strong, readwrite) NSString *accelerometersStatisticsString;
@property (nonatomic, strong, readwrite) NSString *gyroscopesStatisticsString;
@property (nonatomic, strong, readwrite) NSString *magnetometersStatisticsString;
@property (nonatomic, strong, readwrite) NSString *cameraStatisticsString;

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

-(void)setupParentViewForCameraRendering:(UIView*)view{
    [self setupSynthesizers];
    [self setupMotionMonitor];
//    [self setupCameraMonitor:view];
    
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


#pragma mark Public methods
-(void)cameraMonitorColorsUpdated:(VWWMotionAxes*)axes{
    self.cameraGroup.xSynthesizer.frequencyNormalized = axes.x.currentNormalized;
    self.cameraGroup.ySynthesizer.frequencyNormalized = axes.y.currentNormalized;
    self.cameraGroup.zSynthesizer.frequencyNormalized = axes.z.currentNormalized;
    self.cameraStatisticsString = [NSString stringWithFormat:@"R: %.4f < %.4f < %.4f"
                                   @"\nG: %.4f < %.4f < %.4f"
                                   @"\nB: %.4f < %.4f < %.4f",
                                   axes.x.min, axes.x.currentNormalized, axes.x.max,
                                   axes.y.min, axes.y.currentNormalized, axes.y.max,
                                   axes.z.min, axes.z.currentNormalized, axes.z.max];
    
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


- (void)setupCameraMonitor:(UIView*)renderView{
    self.cameraMonitor = [[VWWCameraMonitor alloc]initWithRenderView:renderView];
    self.cameraMonitor.delegate = self;
    [self.cameraMonitor startCamera];
}

-(NSString*)stringForMotionStatsWithDevice:(VWWMotionAxes*)device{
    return [NSString stringWithFormat:@"x: %.4f < %.4f < %.4f"
            @"\ny: %.4f < %.4f < %.4f"
            @"\nz: %.4f < %.4f < %.4f",
            device.x.min, device.x.currentNormalized, device.x.max,
            device.y.min, device.y.currentNormalized, device.y.max,
            device.z.min, device.z.currentNormalized, device.z.max];
}



#pragma mark VWWMotionMonitorDelegate

-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender accelerometerUpdated:(VWWMotionAxes*)device{
    self.accelerometersGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
    self.accelerometersGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
    self.accelerometersGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
    self.accelerometersStatisticsString = [self stringForMotionStatsWithDevice:device];
}

-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender gyroUpdated:(VWWMotionAxes*)device{
    self.gyroscopesGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
    self.gyroscopesGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
    self.gyroscopesGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
    self.gyroscopesStatisticsString = [self stringForMotionStatsWithDevice:device];
}


-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender magnetometerUpdated:(VWWMotionAxes*)device{
    self.magnetometersGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
    self.magnetometersGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
    self.magnetometersGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
    self.magnetometersStatisticsString = [self stringForMotionStatsWithDevice:device];
}






@end


