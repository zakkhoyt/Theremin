//
//  VWWCameraController.h
//  theremin
//
//  Created by Zakk Hoyt on 8/27/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VWWCameraMonitor;
@class VWWMotionAxes;

static NSString *VWWCameraMonitorRenderViewAdded = @"VWWCameraMonitorRenderViewAdded";

@protocol VWWCameraMonitorDelegate <NSObject>
-(void)cameraMonitor:(VWWCameraMonitor*)sender colorsUpdated:(VWWMotionAxes*)axes;
@end

@interface VWWCameraMonitor : NSObject
-(id)initWithRenderView:(UIView*)renderView;
-(void)startCamera;
-(void)stopCamera;
-(void)updateFilterWithMotionAxes:(VWWMotionAxes*)axes;
@property (nonatomic, weak) id <VWWCameraMonitorDelegate> delegate;
@end
