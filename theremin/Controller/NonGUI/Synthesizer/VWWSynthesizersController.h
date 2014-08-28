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

@class VWWSynthesizersController;
@class VWWMotionAxes;

@protocol VWWSynthesizersControllerRenderDelegate <NSObject>
-(UIView*)synthesizersControllerViewForCameraRendering:(VWWSynthesizersController*)sender;
-(void)synthesizersController:(VWWSynthesizersController*)sender didAddViewForRendering:(UIView*)view;
@end


@interface VWWSynthesizersController : NSObject

+(VWWSynthesizersController*)sharedInstance;
-(void)setupParentViewForCameraRendering:(UIView*)view;
-(void)writeSettings;
@property (nonatomic, strong) VWWSynthesizerGroup *touchscreenGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *accelerometersGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *gyroscopesGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *magnetometersGroup;
@property (nonatomic, strong) VWWSynthesizerGroup *cameraGroup;
@property (nonatomic, strong, readonly) NSString *accelerometersStatisticsString;
@property (nonatomic, strong, readonly) NSString *gyroscopesStatisticsString;
@property (nonatomic, strong, readonly) NSString *magnetometersStatisticsString;
@property (nonatomic, strong, readonly) NSString *cameraStatisticsString;
@property (nonatomic, weak) id <VWWSynthesizersControllerRenderDelegate> renderDelegate;

-(void)cameraMonitorColorsUpdated:(VWWMotionAxes*)axes;
@end
