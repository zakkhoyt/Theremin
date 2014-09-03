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

#define NUM_POINTS 320
@interface VWWSynthesizersController () <VWWMotionMonitorDelegate>
@property (nonatomic, strong) VWWMotionMonitor *motionMonitor;
@property (nonatomic, strong, readwrite) NSString *accelerometersStatisticsString;
@property (nonatomic, strong, readwrite) NSString *gyroscopesStatisticsString;
@property (nonatomic, strong, readwrite) NSString *magnetometersStatisticsString;
@property (nonatomic, strong, readwrite) NSString *cameraStatisticsString;
@property (strong, readwrite) NSMutableArray *accelerometersData;
@property (strong, readwrite) NSMutableArray *gyroscopesData;
@property (strong, readwrite) NSMutableArray *magnetometersData;
@property (strong, readwrite) NSMutableArray *cameraData;

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
        
        [self setupData];
        [self setupSynthesizers];
        [self setupMotionMonitor];
        
    }
    return self;
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

-(void)setupData{
    self.accelerometersData = [[NSMutableArray alloc]initWithCapacity:NUM_POINTS];
    self.gyroscopesData = [[NSMutableArray alloc]initWithCapacity:NUM_POINTS];
    self.magnetometersData = [[NSMutableArray alloc]initWithCapacity:NUM_POINTS];
    self.cameraData = [[NSMutableArray alloc]initWithCapacity:NUM_POINTS];
    for(int x = 0; x < 320; x++){
        NSDictionary *d = @{@"x" : @(0),
                            @"y" : @(0),
                            @"z" : @(0)};
        [self.accelerometersData addObject:d];
        [self.gyroscopesData addObject:d];
        [self.magnetometersData addObject:d];
        [self.cameraData addObject:d];
    }
    
}
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
    @synchronized(self.accelerometersData){
        // Data for rendering graphs
        [self.accelerometersData removeObjectAtIndex:0];
        NSDictionary *d = @{@"x" : @(device.x.current),
                            @"y" : @(device.y.current),
                            @"z" : @(device.z.current)};
        [self.accelerometersData addObject:d];
        
        // Data for synthesizers
        self.accelerometersGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
        self.accelerometersGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
        self.accelerometersGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
        self.accelerometersStatisticsString = [self stringForMotionStatsWithDevice:device];
    }
}

-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender gyroUpdated:(VWWMotionAxes*)device{
    @synchronized(self.gyroscopesData){
        // Data for rendering graphs
        [self.gyroscopesData removeObjectAtIndex:0];
        NSDictionary *d = @{@"x" : @(device.x.current),
                            @"y" : @(device.y.current),
                            @"z" : @(device.z.current)};
        [self.gyroscopesData addObject:d];
        
        // Data for synthesizers
        self.gyroscopesGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
        self.gyroscopesGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
        self.gyroscopesGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
        self.gyroscopesStatisticsString = [self stringForMotionStatsWithDevice:device];
    }
}


-(void)vwwMotionMonitor:(VWWMotionMonitor*)sender magnetometerUpdated:(VWWMotionAxes*)device{
    
    @synchronized(self.magnetometersData){
        // Data for rendering graphs
        [self.magnetometersData removeObjectAtIndex:0];
        NSDictionary *d = @{@"x" : @(device.x.current),
                            @"y" : @(device.y.current),
                            @"z" : @(device.z.current)};
        [self.magnetometersData addObject:d];
        
        // Data for synthesizers
        self.magnetometersGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
        self.magnetometersGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
        self.magnetometersGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
        self.magnetometersStatisticsString = [self stringForMotionStatsWithDevice:device];
    }
}



#pragma mark Public methods
-(void)cameraMonitorColorsUpdated:(VWWMotionAxes*)device{
    @synchronized(self.cameraData){
        // Data for rendering graphs
        [self.cameraData removeObjectAtIndex:0];
        NSDictionary *d = @{@"x" : @(device.x.current),
                            @"y" : @(device.y.current),
                            @"z" : @(device.z.current)};
        [self.cameraData addObject:d];
        
        self.cameraGroup.xSynthesizer.frequencyNormalized = device.x.currentNormalized;
        self.cameraGroup.ySynthesizer.frequencyNormalized = device.y.currentNormalized;
        self.cameraGroup.zSynthesizer.frequencyNormalized = device.z.currentNormalized;
        self.cameraStatisticsString = [NSString stringWithFormat:@"R: %.4f < %.4f < %.4f"
                                       @"\nG: %.4f < %.4f < %.4f"
                                       @"\nB: %.4f < %.4f < %.4f",
                                       device.x.min, device.x.currentNormalized, device.x.max,
                                       device.y.min, device.y.currentNormalized, device.y.max,
                                       device.z.min, device.z.currentNormalized, device.z.max];
    }
    
}



@end


