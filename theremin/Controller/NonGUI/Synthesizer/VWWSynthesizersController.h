//
//  VWWSynthesizersController.h
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWWSynthesizerGroup.h"


static NSString *VWWSynthesizersControllerAccelerometersStatisticsString = @"accelerometersStatisticsString";
static NSString *VWWSynthesizersControllerGyroscopesStatisticsString = @"gyroscopesStatisticsString";
static NSString *VWWSynthesizersControllerMagnetoometersStatisticsString = @"magnetometersStatisticsString";
static NSString *VWWSynthesizersControllerCameraStatisticsString = @"cameraStatisticsString";

@class VWWMotionAxes;

@interface VWWSynthesizersController : NSObject
+(VWWSynthesizersController*)sharedInstance;
-(void)writeSettings;
-(void)cameraMonitorColorsUpdated:(VWWMotionAxes*)axes;
@property (nonatomic, strong) VWWSynthesizerGroup *touchscreenGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *accelerometersGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *gyroscopesGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *magnetometersGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *cameraGroup;
@property (nonatomic, strong, readonly) NSString *accelerometersStatisticsString;
@property (nonatomic, strong, readonly) NSString *gyroscopesStatisticsString;
@property (nonatomic, strong, readonly) NSString *magnetometersStatisticsString;
@property (nonatomic, strong, readonly) NSString *cameraStatisticsString;

@property (strong, readonly) NSMutableArray *accelerometersData;
@property (strong, readonly) NSMutableArray *gyroscopesData;
@property (strong, readonly) NSMutableArray *magnetometersData;
@property (strong, readonly) NSMutableArray *cameraData;
@end
