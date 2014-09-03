//
//  VWWSceneProtocol.h
//  RCTools
//
//  Created by Zakk Hoyt on 4/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@protocol VWWSceneProtocol <NSObject>

@required
@property GLKVector4 clearColor;
@property float left, right, bottom, top;
-(void)update;
-(void)render;

@optional
@property (nonatomic, strong) NSMutableArray *dataForPlot;
@end
