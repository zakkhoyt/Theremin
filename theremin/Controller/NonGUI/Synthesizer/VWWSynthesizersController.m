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


@interface VWWSynthesizersController () <VWWMotionMonitorDelegate>
@property (nonatomic, strong) VWWMotionMonitor *motionMonitor;
@property (nonatomic, strong, readwrite) NSString *accelerometersStatisticsString;
@property (nonatomic, strong, readwrite) NSString *gyroscopesStatisticsString;
@property (nonatomic, strong, readwrite) NSString *magnetometersStatisticsString;

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
    
}


#pragma mark Private methods




-(void)setupSynthesizers{
    // We will create 11 synthesizers here:
    // 2 for the touchscreen (x, y)
    // 3 for the accelerometers (x, y, z)
    // 3 for the gyroscopes (x, y, z)
    // 3 for the magnetometers (x, y, z)
    // Each group will be initialized with the default settings (stored in NSUserDefaults), all axis muted, then started.
    // What is required for each synth to make noise is to unmute an axis
    
    // Default settings
    VWWGeneralSettings *generalSettings = [VWWGeneralSettings sharedInstance];

    // Touchscreeen
    NSDictionary *touchscreenDictionary = [VWWUserDefaults touchscreenSettings];
    if(touchscreenDictionary){
        self.touchscreenGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:touchscreenDictionary];
    } else {
        self.touchscreenGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                    amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                    amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
        self.touchscreenGroup.xSynthesizer.effectType = VWWEffectTypeAutoTune;
        self.touchscreenGroup.xSynthesizer.keyType = VWWAutoTuneTypeCMajor;
        
        self.touchscreenGroup.ySynthesizer.waveType = VWWWaveTypeTriangle;
    }
    
    self.touchscreenGroup.muted = YES;
    [self.touchscreenGroup start];
    
    // Accelerometers
    NSDictionary *accelerometersDictionary = [VWWUserDefaults accelerometersSettings];
    if(accelerometersDictionary){
        self.accelerometersGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:accelerometersDictionary];
    } else {
        self.accelerometersGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                       amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                       amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
    }
    self.accelerometersGroup.muted = YES;
    [self.accelerometersGroup start];
    
    // Gyroscopes
    NSDictionary *gyroscopesDictionary = [VWWUserDefaults gyroscopesSettings];
    if(gyroscopesDictionary){
        self.gyroscopesGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:gyroscopesDictionary];
    } else {
        self.gyroscopesGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                   amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                   amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
    }
    self.gyroscopesGroup.muted = YES;
    [self.gyroscopesGroup start];
    
    
    // Magnetometers
    NSDictionary *magnetometersDictionary = [VWWUserDefaults magnetometersSettings];
    if(magnetometersDictionary){
        self.magnetometersGroup = [[VWWSynthesizerGroup alloc]initWithDictionary:magnetometersDictionary];
    } else {
        self.magnetometersGroup = [[VWWSynthesizerGroup alloc]initWithAmplitudeX:generalSettings.amplitudeDefault xFrequencyMin:generalSettings.frequencyDefaultMin xFrequencyMax:generalSettings.frequencyDefaultMax xFrequencyNormalized:generalSettings.frequencyNormalized
                                                                      amplitudeY:generalSettings.amplitudeDefault yFrequencyMin:generalSettings.frequencyDefaultMin yFrequencyMax:generalSettings.frequencyDefaultMax yFrequencyNormalized:generalSettings.frequencyNormalized
                                                                      amplitudeZ:generalSettings.amplitudeDefault zFrequencyMin:generalSettings.frequencyDefaultMin zFrequencyMax:generalSettings.frequencyDefaultMax zFrequencyNormalized:generalSettings.frequencyNormalized];
    }
    self.magnetometersGroup.muted = YES;
    [self.magnetometersGroup start];
    
    
}


-(void)setupMotionMonitor{
    self.motionMonitor = [[VWWMotionMonitor alloc]init];
    self.motionMonitor.delegate = self;
    [self.motionMonitor startAccelerometer];
    [self.motionMonitor startGyroscopes];
    [self.motionMonitor startMagnetometer];
    
}


#pragma mark VWWMotionMonitorDelegate
-(NSString*)stringForMotionStatsWithDevice:(VWWMotionAxes*)device{
//    return [NSString stringWithFormat:@"x: min:%.4f x:%.4f max:%.4f"
//                 @"\ny: min:%.4f x:%.4f max:%.4f"
//                 @"\nz: min:%.4f x:%.4f max:%.4f",
//                 device.x.min, device.x.currentNormalized, device.x.max,
//                 device.y.min, device.y.currentNormalized, device.y.max,
//                 device.z.min, device.z.currentNormalized, device.z.max];
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
