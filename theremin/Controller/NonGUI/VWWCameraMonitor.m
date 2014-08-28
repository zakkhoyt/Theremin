//
//  VWWCameraController.m
//  theremin
//
//  Created by Zakk Hoyt on 8/27/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWCameraMonitor.h"
#import "VWWMotionAxes.h"
#import "GPUImage.h"
#import "VWWSynthesizerGroup.h"

@interface VWWCameraMonitor ()
@property (nonatomic, strong) VWWMotionAxes *cameraAxes;
@property (nonatomic) bool cameraRunning;
@property (nonatomic, strong) UIView *gpuViewParentView;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImagePicture *sourcePicture;
@property (nonatomic, strong) GPUImageUIElement *uiElementInput;
@property (nonatomic, strong) GPUImageFilterPipeline *pipeline;
@property (nonatomic, strong) GPUImageView *filterView;
@end

@implementation VWWCameraMonitor



-(id)initWithRenderView:(UIView*)renderView{
    self = [super init];
    if(self){
        _gpuViewParentView = renderView;
        _cameraRunning = NO;
        _cameraAxes = [[VWWMotionAxes alloc]init];
        
//        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateCameraBasedOnCenterPixel)];
//        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
 
    }
    return self;
}
-(void)updateCameraBasedOnCenterPixel{
//    dispatch_async(dispatch_get_main_queue(), ^{
    
//        [self.filter useNextFrameForImageCapture];
//        UIImage *image = [self.filter imageFromCurrentFramebuffer];
        
//        UIView *snapshotView = [self.filterView snapshotViewAfterScreenUpdates:YES];
//        UIImage *image = [self imageFromView:snapshotView];
    
    
        [self.filter useNextFrameForImageCapture];
        UIImage *image = [self.filter imageFromCurrentFramebufferWithOrientation:UIImageOrientationUp];
        if(image == nil) return;
        NSArray *colors = [self getRGBAsFromImage:image atX:self.filterView.center.x andY:self.filterView.center.y count:1];
        if(colors.count){
            UIColor *color = colors[0];
            
            CGFloat red = 0;
            CGFloat blue = 0;
            CGFloat green = 0;
            CGFloat alpha = 0;
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
            NSLog(@"pixel: %f %f %f %f", red, green, blue, alpha);
            
            self.cameraAxes.x.currentNormalized = red;
            self.cameraAxes.y.currentNormalized = green;
            self.cameraAxes.z.currentNormalized = blue;
            
            
            if(red < self.cameraAxes.x.min){
                self.cameraAxes.x.min = red;
            }
            if(red > self.cameraAxes.x.max){
                self.cameraAxes.x.max = red;
            }
            if(green < self.cameraAxes.y.min){
                self.cameraAxes.y.min = green;
            }
            if(green > self.cameraAxes.y.max){
                self.cameraAxes.y.max = green;
            }
            if(blue < self.cameraAxes.z.min){
                self.cameraAxes.z.min = blue;
            }
            if(blue > self.cameraAxes.z.max){
                self.cameraAxes.z.max = blue;
            }
            
            [self.delegate cameraMonitor:self colorsUpdated:self.cameraAxes];
        }
//    });
}

- (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    // [view.layer renderInContext:UIGraphicsGetCurrentContext()]; // <- same result...
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}



-(void)startCamera{
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //    self.videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    //    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    self.filter = [[GPUImageAverageColor alloc]init];
    //    GPUImageRGBFilter *rgbFilter = [[GPUImageRGBFilter alloc]init];
    //    rgbFilter.red = self.cameraGroup.xSynthesizer.muted ? 0 : 1.0;
    //    rgbFilter.green = self.cameraGroup.ySynthesizer.muted ? 1.0 : 1.0;
    //    rgbFilter.blue = self.cameraGroup.zSynthesizer.muted ? 0 : 1.0;
    //    self.filter = rgbFilter;
    
    [self.videoCamera addTarget:self.filter];
    //    self.videoCamera.delegate = self;
    
    self.filterView = [[GPUImageView alloc]initWithFrame:self.gpuViewParentView.bounds];
    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    [self.gpuViewParentView addSubview:self.filterView];
    
    [self.filter addTarget:self.filterView];
    
    [self.videoCamera startCameraCapture];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VWWCameraMonitorRenderViewAdded object:nil];
    
}
-(void)stopCamera{
    VWW_LOG_TODO;
}
-(void)updateFilterWithMotionAxes:(VWWMotionAxes*)axes{
    VWW_LOG_TODO;
}

@end
