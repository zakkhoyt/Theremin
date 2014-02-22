//
//  VWWBonjourModel.m
//  theremin
//
//  Created by Zakk Hoyt on 2/21/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWBonjourModel.h"
#import "VWWSynthesizersController.h"
#import "VWWNormalizedSynthesizer.h"

// The payload that is sent from device to device will look like this:
//    {
//        "touchscreen": {
//            "x": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "y": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "z": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            }
//        },
//        "accelerometers": {
//            "x": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "y": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "z": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            }
//        },
//        "gyroscopes": {
//            "x": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "y": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "z": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            }
//        },
//        "magnetometers": {
//            "x": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "y": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            },
//            "z": {
//                "frequencyNormalized": 0.35,
//                "muted": 0
//            }
//        }
//    }

static NSString *VWWBonjourModelTouchScreenKey = @"touchscreen";
static NSString *VWWBonjourModelAccelerometersKey = @"accelerometers";
static NSString *VWWBonjourModelGyroscopesKey = @"gyroscopes";
static NSString *VWWBonjourModelMagnetometersKey = @"magnetometers";
static NSString *VWWBonjourModelXAxisKey = @"x";
static NSString *VWWBonjourModelYAxisKey = @"y";
static NSString *VWWBonjourModelZAxisKey = @"z";
static NSString *VWWBonjourModelFrequencyNormalizedKey = @"frequencyNormalized";
static NSString *VWWBonjourModelMutedKey = @"muted";

typedef void (^VWWBonjourDictionariesForAxes)(NSDictionary *xDictionary, NSDictionary *yDictionary, NSDictionary *zDictionary);


@interface VWWBonjourModel ()
@property (nonatomic) dispatch_queue_t bonjourProtocolQueue;
@end

@implementation VWWBonjourModel


-(id)init{
    self = [super init];
    if(self){
        _bonjourProtocolQueue = dispatch_queue_create("com.vaporwarewolf.theremin.bonjourProtocol", NULL);
        
    }
    return self;
}

-(NSDictionary*)dictionaryRepresentation{
    
    // TODO: Watch this and use background queue if this is too hungry
    
//    dispatch_async(self.bonjourProtocolQueue, ^{
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:4];
        
        @autoreleasepool {
            VWWSynthesizerGroup *touchscreenGroup = [VWWSynthesizersController sharedInstance].touchscreenGroup;
            [self dictionariesForSynthesizerGroup:touchscreenGroup completionBlock:^(NSDictionary *xDictionary, NSDictionary *yDictionary, NSDictionary *zDictionary) {
                NSDictionary *touchscreenDictionary = @{VWWBonjourModelXAxisKey : xDictionary,
                                                        VWWBonjourModelYAxisKey : yDictionary,
                                                        VWWBonjourModelZAxisKey : zDictionary};
                dictionary[VWWBonjourModelTouchScreenKey] = touchscreenDictionary;
            }];
        }
        
        @autoreleasepool {
            VWWSynthesizerGroup *accelerometersGroup = [VWWSynthesizersController sharedInstance].accelerometersGroup;
            [self dictionariesForSynthesizerGroup:accelerometersGroup completionBlock:^(NSDictionary *xDictionary, NSDictionary *yDictionary, NSDictionary *zDictionary) {
                NSDictionary *accelerometersDictionary = @{VWWBonjourModelXAxisKey : xDictionary,
                                                           VWWBonjourModelYAxisKey : yDictionary,
                                                           VWWBonjourModelZAxisKey : zDictionary};
                dictionary[VWWBonjourModelAccelerometersKey] = accelerometersDictionary;
            }];
        }
        
        @autoreleasepool {
            VWWSynthesizerGroup *gyroscopesGroup = [VWWSynthesizersController sharedInstance].gyroscopesGroup;
            [self dictionariesForSynthesizerGroup:gyroscopesGroup completionBlock:^(NSDictionary *xDictionary, NSDictionary *yDictionary, NSDictionary *zDictionary) {
                NSDictionary *gyroscopesDictionary = @{VWWBonjourModelXAxisKey : xDictionary,
                                                       VWWBonjourModelYAxisKey : yDictionary,
                                                       VWWBonjourModelZAxisKey : zDictionary};
                dictionary[VWWBonjourModelGyroscopesKey] = gyroscopesDictionary;
            }];
        }
        
        @autoreleasepool {
            VWWSynthesizerGroup *magnetometersGroup = [VWWSynthesizersController sharedInstance].magnetometersGroup;
            [self dictionariesForSynthesizerGroup:magnetometersGroup completionBlock:^(NSDictionary *xDictionary, NSDictionary *yDictionary, NSDictionary *zDictionary) {
                NSDictionary *magnetometersDictionary = @{VWWBonjourModelXAxisKey : xDictionary,
                                                          VWWBonjourModelYAxisKey : yDictionary,
                                                          VWWBonjourModelZAxisKey : zDictionary};
                dictionary[VWWBonjourModelMagnetometersKey] = magnetometersDictionary;
            }];
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            return dictionary;
//        });
        
//    });
    
    
    
    
    
}

// This is a synchronous method
-(void)dictionariesForSynthesizerGroup:(VWWSynthesizerGroup*)synthesizerGroup completionBlock:(VWWBonjourDictionariesForAxes)completionBlock{
    @autoreleasepool {
        NSDictionary *xDictionary = @{VWWBonjourModelFrequencyNormalizedKey : @(synthesizerGroup.xSynthesizer.frequencyNormalized),
                                      VWWBonjourModelMagnetometersKey : @(synthesizerGroup.xSynthesizer.muted)};
        
        NSDictionary *yDictionary = @{VWWBonjourModelFrequencyNormalizedKey : @(synthesizerGroup.ySynthesizer.frequencyNormalized),
                                      VWWBonjourModelMagnetometersKey : @(synthesizerGroup.ySynthesizer.muted)};
        
        NSDictionary *zDictionary = @{VWWBonjourModelFrequencyNormalizedKey : @(synthesizerGroup.zSynthesizer.frequencyNormalized),
                                      VWWBonjourModelMagnetometersKey : @(synthesizerGroup.zSynthesizer.muted)};
        
        completionBlock(xDictionary, yDictionary, zDictionary);
    }
}



@end
