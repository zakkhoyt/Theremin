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
//#import "VWWTuningOptionsViewController.h"

#define NUM_POINTS 320

@interface VWWSensorGraphViewController () <VWWMotionMonitorDelegate>
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
    
    
    self.dataForPlot = [[NSMutableArray alloc]initWithCapacity:NUM_POINTS];
    for(int x = 0; x < 320; x++){
        NSDictionary *d = @{@"x" : @(0),
                            @"y" : @(0),
                            @"z" : @(0)};
        [self.dataForPlot addObject:d];
    }
    
    
    //    GLKView *glkView = (GLKView*)self.view;
    //    glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    //    view.drawableMultisample = GLKViewDrawableMultisample4X;
    [EAGLContext setCurrentContext:self.context];
    
    self.preferredFramesPerSecond = 60;
    
    
    
    self.graphScene = [[VWWGraphScene alloc]init];
    self.graphScene.clearColor = GLKVector4Make(0.0, 0.0, 0.0, 0.0);
    self.graphScene.dataForPlot = self.dataForPlot;
    
    
    
//    self.motionMonitor = [VWWMotionMonitor sharedInstance];
    self.motionMonitor.delegate = self;
    
    // Update labels at a low framerate
    VWW_LOG_TODO_TASK(@"This should be changed via callback, not a timer loop. Implement callbacks for it");
    [NSTimer scheduledTimerWithTimeInterval:1/1.0 target:self selector:@selector(renderLabels:) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.graphScene.left   = -1.0;
    self.graphScene.right  =  1.0;
    self.graphScene.bottom = -1.0;
    self.graphScene.top    =  1.0;
    
//    
//    if([VWWUserDefaults tuningSensor] == 0){
//        [self.motionMonitor startAccelerometer];
//    } else if([VWWUserDefaults tuningSensor] == 1){
//        [self.motionMonitor startGyroscope];
//    } else if([VWWUserDefaults tuningSensor] == 2){
//        [self.motionMonitor startMagnetometer];
//    }
//    
//    
//    self.motionMonitor.updateInterval = 1/(float)[VWWUserDefaults tuningUpdateFrequency];
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

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//}
//
//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}
//-(void)updateSceneBounds:(UIInterfaceOrientation)toInterfaceOrientation{
//}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.paused = !self.paused;
}
#pragma mark Private

-(void)renderLabels:(id)sender{
//    self.xMaxLabel.text = [NSString stringWithFormat:@"%.3f", self.limits.x.max];
//    self.xMinLabel.text = [NSString stringWithFormat:@"%.3f", self.limits.x.min];
//    
//    self.yMaxLabel.text = [NSString stringWithFormat:@"%.3f", self.limits.y.max];
//    self.yMinLabel.text = [NSString stringWithFormat:@"%.3f", self.limits.y.min];
//    
//    self.zMaxLabel.text = [NSString stringWithFormat:@"%.3f", self.limits.z.max];
//    self.zMinLabel.text = [NSString stringWithFormat:@"%.3f", self.limits.z.min];
//    
}


#pragma mark IBAction
- (IBAction)settingsButtonTouchUpInside:(id)sender {
//    [self.motionMonitor stopAll];
//    [self performSegueWithIdentifier:VWWSegueTuningToOptions sender:self];
}

- (IBAction)startButtonTouchUpInside:(id)sender {
    
}

- (IBAction)resetButtonTouchUpInside:(id)sender {
//    [self.motionMonitor resetAllLimits];
}


#pragma mark VWWMotionControllerDelegate;

//-(void)motionMonitor:(VWWMotionController*)sender didUpdateAcceleremeters:(CMAccelerometerData*)accelerometers limits:(VWWDeviceLimits*)limits{
//    @synchronized(self.graphScene.dataForPlot){
//        [self.dataForPlot removeObjectAtIndex:0];
//        NSDictionary *d = @{@"x" : @(accelerometers.acceleration.x),
//                            @"y" : @(accelerometers.acceleration.y),
//                            @"z" : @(accelerometers.acceleration.z)};
//        [self.dataForPlot addObject:d];
//        self.limits = limits;
//    }
//    
//    
//}
//
//-(void)motionMonitor:(VWWMotionController*)sender didUpdateGyroscopes:(CMGyroData*)gyroscopes limits:(VWWDeviceLimits*)limits{
//    @synchronized(self.graphScene.dataForPlot){
//        [self.dataForPlot removeObjectAtIndex:0];
//        NSDictionary *d = @{@"x" : @(gyroscopes.rotationRate.x),
//                            @"y" : @(gyroscopes.rotationRate.y),
//                            @"z" : @(gyroscopes.rotationRate.z)};
//        [self.dataForPlot addObject:d];
//        self.limits = limits;
//    }
//}
//-(void)motionMonitor:(VWWMotionController*)sender didUpdateMagnetometers:(CMMagnetometerData*)magnetometers limits:(VWWDeviceLimits*)limits{
//    @synchronized(self.graphScene.dataForPlot){
//        [self.dataForPlot removeObjectAtIndex:0];
//        NSDictionary *d = @{@"x" : @(magnetometers.magneticField.x),
//                            @"y" : @(magnetometers.magneticField.y),
//                            @"z" : @(magnetometers.magneticField.z)};
//        [self.dataForPlot addObject:d];
//        self.limits = limits;
//    }
//}



#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.graphScene render];
}

- (void)update {
    [self.graphScene update];
}
#pragma mark VWWTuningOptionsViewControllerDelegate




@end
