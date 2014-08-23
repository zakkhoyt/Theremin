//
//  VWWGeneralSettings.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGeneralSettings.h"
#import "VWWSynthesizerKeys.h"

const float VWWGeneralSettingsFrequencyMin = 20.0;
const float VWWGeneralSettingsFrequencyMax = 18000.0;
const float VWWGeneralSettingsFrequencyDefaultMin = 55;
const float VWWGeneralSettingsFrequencyDefaultMax = 880;
const float VWWGeneralSettingsFrequencyNormalized = 1.0;
const float VWWGeneralSettingsAmplitudeDefault = 0.8;

@implementation VWWGeneralSettings
+(VWWGeneralSettings*)sharedInstance{
    static VWWGeneralSettings *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = self.new;
    });
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        self.frequencyMin = VWWGeneralSettingsFrequencyMin;
        self.frequencyMax = VWWGeneralSettingsFrequencyMax;
        self.frequencyDefaultMin = VWWGeneralSettingsFrequencyDefaultMin;
        self.frequencyDefaultMax = VWWGeneralSettingsFrequencyDefaultMax;
        self.frequencyNormalized = VWWGeneralSettingsFrequencyNormalized;
        self.amplitudeDefault = VWWGeneralSettingsAmplitudeDefault;
    }
    return self;
}


-(id)initWithDictionary:(NSDictionary*)dictionary{
    VWW_LOG_TODO_TASK(@"Write unit test");
    self = [super init];
    if(self){
        NSNumber *frequencyMin = dictionary[VWWGeneralSettingsFrequencyMinKey];
        self.frequencyMin = frequencyMin.floatValue;
        
        NSNumber *frequencyMax = dictionary[VWWGeneralSettingsFrequencyMaxKey];
        self.frequencyMax = frequencyMax.floatValue;
        
        NSNumber *frequencyDefaultMin = dictionary[VWWGeneralSettingsFrequencyDefaultMinKey];
        self.frequencyDefaultMin = frequencyDefaultMin.floatValue;
        
        NSNumber *frequencyDefaultMax = dictionary[VWWGeneralSettingsFrequencyDefaultMaxKey];
        self.frequencyDefaultMax = frequencyDefaultMax.floatValue;
        
        NSNumber *frequencyNormalized = dictionary[VWWGeneralSettingsFrequencyNormalizedKey];
        self.frequencyNormalized = frequencyNormalized.floatValue;
        
        NSNumber *amplitudeDefault = dictionary[VWWGeneralSettingsAmplitudeDefaultKey];
        self.amplitudeDefault = amplitudeDefault.floatValue;
        
    }
    return self;
}

-(NSDictionary*)dictionaryRepresentation{
    VWW_LOG_TODO_TASK(@"Write unit test");
    NSDictionary *dictionary = @{VWWGeneralSettingsFrequencyMinKey : @(self.frequencyMin),
                                 VWWGeneralSettingsFrequencyMaxKey : @(self.frequencyMax),
                                 VWWGeneralSettingsFrequencyDefaultMinKey : @(self.frequencyDefaultMin),
                                 VWWGeneralSettingsFrequencyDefaultMaxKey : @(self.frequencyDefaultMax),
                                 VWWGeneralSettingsFrequencyNormalizedKey : @(self.frequencyNormalized),
                                 VWWGeneralSettingsAmplitudeDefaultKey : @(self.amplitudeDefault)};
    return dictionary;
}




@end
