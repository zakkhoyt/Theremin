//
//  VWWSensorGraph.m
//  theremin
//
//  Created by Zakk Hoyt on 9/3/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSensorGraphViewController.h"
@import GLKit;
#import "VWWGraphScene.h"
#import "VWWMotionMonitor.h"
#import "VWWSynthesizersController.h"
//#import "VWWTuningOptionsViewController.h"

#define NUM_POINTS 320

@interface VWWSensorGraphViewController ()
@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic, strong) VWWGraphScene *graphScene;
@property (nonatomic, strong) VWWMotionMonitor *motionMonitor;
@property (nonatomic, strong) NSMutableArray *dataForPlot;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *startButton;
@property (weak, nonatomic) IBOutlet UILabel *xMaxLabel;
//@property (nonatomic, strong) VWWDeviceLimits *limits;
@property (weak, nonatomic) IBOutlet UILabel *xMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *yMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *yMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *zMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *zMinLabel;
@end

@implementation VWWSensorGraphViewController
@synthesize context = _context;


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    self.preferredFramesPerSecond = 60;
    
    [view setNeedsDisplay];
    
    self.graphScene = [[VWWGraphScene alloc]init];
    self.graphScene.clearColor = GLKVector4Make(0.0, 0.0, 0.0, 0.0);
    
    
    if(self.sensorType == VWWInputTypeAccelerometer){
        self.title = @"Accelerometers";
    } else if(self.sensorType == VWWInputTypeGyroscope){
        self.title = @"Gyroscopes";
    } else if(self.sensorType == VWWInputTypeMagnetometer){
        self.title = @"Magnetometers";
    } else if(self.sensorType == VWWInputTypeCamera){
        self.title = @"Camera";
    } else {
        VWW_LOG_WARNING(@"No sensor has been defined");
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.graphScene.left   = -1.0;
    self.graphScene.right  =  1.0;
    self.graphScene.bottom = -1.0;
    self.graphScene.top    =  1.0;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.toolbar.hidden = YES;
        
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.toolbar.hidden = NO;
    }
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:VWWSegueTuningToOptions]){
//        VWWTuningOptionsViewController *vc = segue.destinationViewController;
//        vc.delegate = self;
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
////    self.paused = !self.paused;
//    BOOL hidden = !self.navigationController.navigationBarHidden;
//    [self.navigationController setNavigationBarHidden:hidden animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark Private



#pragma mark IBAction



#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.graphScene render];
}

- (void)update {
    if(self.sensorType == VWWInputTypeAccelerometer){
        self.graphScene.dataForPlot = [VWWSynthesizersController sharedInstance].accelerometersData;
    } else if(self.sensorType == VWWInputTypeGyroscope){
        self.graphScene.dataForPlot = [VWWSynthesizersController sharedInstance].gyroscopesData;
    } else if(self.sensorType == VWWInputTypeMagnetometer){
        self.graphScene.dataForPlot = [VWWSynthesizersController sharedInstance].magnetometersData;
    } else if(self.sensorType == VWWInputTypeCamera){
        self.graphScene.dataForPlot = [VWWSynthesizersController sharedInstance].cameraData;
    } else {
        VWW_LOG_WARNING(@"No sensor has been defined");
    }
    [self.graphScene update];
}




@end
