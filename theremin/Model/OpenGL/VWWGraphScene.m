//
//  VWWGraphScene.m
//  RCTools
//
//  Created by Zakk Hoyt on 4/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGraphScene.h"



const NSUInteger kSamples = 320;
GLfloat  xVertices[kSamples * 2];
GLfloat  yVertices[kSamples * 2];
GLfloat  zVertices[kSamples * 2];

GLfloat xxAxis[4] = {
    -1.0, 0.5,
    1.0, 0.5,
};


GLfloat yxAxis[4] = {
    -1.0, 0.0,
    1.0, 0.0,
};


GLfloat zxAxis[4] = {
    -1.0, -0.5,
    1.0, -0.5,
};

//GLfloat xLimits[4];

@interface VWWGraphScene () {
    GLKVector4 clearColor;
    GLKBaseEffect *effect;
    float left, right, bottom, top;
}
@end




@implementation VWWGraphScene
@synthesize clearColor;
@synthesize left, right, bottom, top;


-(id)init{
    self = [super init];
    if(self){
        effect = [[GLKBaseEffect alloc] init];
        effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
//        glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
//        glEnable(GL_LINE_SMOOTH);
    }
    return self;
}

-(void)update {
    //  NSLog(@"in EEScene's update");
    
    @synchronized(self.dataForPlot){
        for(NSInteger index = 0; index < kSamples * 2; index+=2){
            int i = (int)index / 2;
            NSDictionary *d = self.dataForPlot[i];
            NSNumber *yNumber = d[@"x"];
            
            GLfloat x = i * (2.0 / (float)kSamples);
            x -= 1.0;
            xVertices[index] = x;
            
            GLfloat y = yNumber.floatValue / 5.0f;
            xVertices[index + 1] = y + 0.5;
        }
        
        for(NSInteger index = 0; index < kSamples * 2; index+=2){
            int i = (int)index / 2;
            NSDictionary *d = self.dataForPlot[i];
            NSNumber *yNumber = d[@"y"];
            
            GLfloat x = i * (2.0 / (float)kSamples);
            x -= 1.0;
            yVertices[index] = x;
            
            GLfloat y = yNumber.floatValue / 5.0f;
            yVertices[index + 1] = y;
        }
        
        for(NSInteger index = 0; index < kSamples * 2; index+=2){
            int i = (int)index / 2;
            NSDictionary *d = self.dataForPlot[i];
            NSNumber *yNumber = d[@"z"];
            
            GLfloat x = i * (2.0 / (float)kSamples);
            x -= 1.0;
            zVertices[index] = x;
            
            GLfloat y = yNumber.floatValue / 5.0f;
            zVertices[index + 1] = y - 0.5;
        }
        
//        // Max
//        xLimits[0] = -1.0;
//        xLimits[1] = 0.2f;
//        xLimits[2] = -0.75;
//        xLimits[3] = 0.2f;
    }
    
}



-(void)render {
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
    glClear(GL_COLOR_BUFFER_BIT);
    
//    glEnable(GL_POINT_SMOOTH);
    
    effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    // x x axis
    effect.constantColor = GLKVector4Make(0.5, 0.0, 0.0, 1.0);
    [effect prepareToDraw];
    glLineWidth(1.0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, xxAxis);
    glDrawArrays(GL_LINES, 0, 4);

    effect.constantColor = GLKVector4Make(1,0,0,0.1);
    [effect prepareToDraw];
    glLineWidth(2.0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, xVertices);
    glDrawArrays(GL_LINE_STRIP, 0, kSamples);


    // y z axis
    effect.constantColor = GLKVector4Make(0.0, 0.5, 0.0, 1.0);
    [effect prepareToDraw];
    glLineWidth(1.0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, yxAxis);
    glDrawArrays(GL_LINES, 0, 4);

    effect.constantColor = GLKVector4Make(0,1,0,1);
    [effect prepareToDraw];
    glLineWidth(2.0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, yVertices);
    glDrawArrays(GL_LINE_STRIP, 0, kSamples);
    

    // z x axis
    effect.constantColor = GLKVector4Make(0, 0, 0.5, 1.0);
    [effect prepareToDraw];
    glLineWidth(1.0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, zxAxis);
    glDrawArrays(GL_LINES, 0, 4);

    effect.constantColor = GLKVector4Make(0,0,1,1);
    [effect prepareToDraw];
    glLineWidth(2.0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, zVertices);
    glDrawArrays(GL_LINE_STRIP, 0, kSamples);
    
    
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    
    
}


@end
