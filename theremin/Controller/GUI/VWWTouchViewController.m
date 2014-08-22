//
//  VWWTouchViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 1/9/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWTouchViewController.h"
#import "VWWTouchView.h"
#import "VWWSynthesizersController.h"
#import "NSTimer+Blocks.h"


#import "VWWBonjourModel.h"
@import AudioToolbox;
@import AVFoundation;

@interface VWWTouchViewController () <VWWTouchViewDelegate>
@property (weak, nonatomic) IBOutlet VWWTouchView *touchView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) VWWSynthesizersController *synthesizersController;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic) BOOL hasLoaded;
@end

@implementation VWWTouchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.touchView.delegate = self;
    
    //[self setupSynthesizers];
    
    
//    self.infoLabel.alpha = 0.0;

    
    

    
//    UIFont *font = [UIFont fontWithName:@"PricedownBl-Regular" size:24.0];
//    [self.settingsButton.titleLabel setFont:font];
    
//    [self addGestureRecognizers];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.hasLoaded == NO){
        self.hasLoaded = YES;
        [self showInfoLabel];
    }

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:VWWSegueTouchToSettings]){
//        
//    }
//}

#pragma mark Private methods

-(void)addObservers{
    
}



-(void)showInfoLabel{
    
    CGRect centeredRect = self.infoLabel.frame;
    CGFloat x = self.infoLabel.frame.origin.x;
    CGFloat y = self.view.bounds.size.height;
    CGFloat w = self.infoLabel.frame.size.width;
    CGFloat h = self.infoLabel.frame.size.height;
    CGRect belowScreenRect = CGRectMake(x, y, w, h);
    self.infoLabel.frame = belowScreenRect;
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.infoLabel.alpha = 1.0;
        self.infoLabel.frame = centeredRect;
    } completion:^(BOOL finished) {
        self.infoLabel.hidden = NO;
    }];
}

-(void)hideInfoLabel{
    CGFloat x = self.infoLabel.frame.origin.x;
    CGFloat y = -(self.infoLabel.frame.size.height);
    CGFloat w = self.infoLabel.frame.size.width;
    CGFloat h = self.infoLabel.frame.size.height;
    CGRect aboveScreenRect = CGRectMake(x, y, w, h);
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.infoLabel.alpha = 0.0;
        self.infoLabel.frame = aboveScreenRect;
    } completion:^(BOOL finished) {
        
        self.infoLabel.hidden = YES;
    }];

}

-(void)setupSynthesizers{
    self.synthesizersController = [VWWSynthesizersController sharedInstance];
}




//-(void)addGestureRecognizers{
//    // Gesture recognizer
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHandler:)];
//    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
//    [self.view addGestureRecognizer:singleTapGestureRecognizer];
//    
//    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureHandler:)];
//    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
//    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
//    
//    UITapGestureRecognizer *twoFingerTripleTapGestureHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerTripleTapGestureHandler:)];
//    twoFingerTripleTapGestureHandler.numberOfTapsRequired = 3;
//    twoFingerTripleTapGestureHandler.numberOfTouchesRequired = 2;
//    [self.view addGestureRecognizer:twoFingerTripleTapGestureHandler];
//    
//    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
//}
//
//
//
//-(void)singleTapGestureHandler:(UIGestureRecognizer*)gestureRecognizer{
//    VWW_LOG_INFO(@"Single Tap");
//
//}
//
//-(void)doubleTapGestureHandler:(UIGestureRecognizer*)gestureRecognizer{
//    VWW_LOG_INFO(@"Double Tap");
//}
//
//- (void)twoFingerTripleTapGestureHandler:(UITapGestureRecognizer*)recognizer {
//    VWW_LOG_INFO(@"Settings tap");
//    [self performSegueWithIdentifier:VWWSegueTouchToSettings sender:self];
//}


-(void)updateFrequenciesWithArray:(NSArray*)array{
    for(NSDictionary *dictionary in array){
        NSNumber *x = dictionary[VWWTouchViewXKey];
        NSNumber *y = dictionary[VWWTouchViewYKey];
        self.synthesizersController.touchscreenGroup.xSynthesizer.frequencyNormalized = x.floatValue;
        self.synthesizersController.touchscreenGroup.ySynthesizer.frequencyNormalized = y.floatValue;
    }
}

#pragma mark VWWTouchViewDelegate
-(void)touchViewDelegate:(VWWTouchView*)sender touchesBeganWithArray:(NSArray*)array{
    // Unmute on touch begin
    self.synthesizersController.touchscreenGroup.xSynthesizer.muted = NO;
    self.synthesizersController.touchscreenGroup.ySynthesizer.muted = NO;
    
    [self updateFrequenciesWithArray:array];
    
    
    
    [self hideInfoLabel];
    
    
    

}

-(void)touchViewDelegate:(VWWTouchView*)sender touchesMovedWithArray:(NSArray*)array{
    [self updateFrequenciesWithArray:array];
    
//    VWWBonjourModel *bm = [[VWWBonjourModel alloc]init];
//    NSDictionary *d = [bm dictionaryRepresentation];
//    VWW_LOG_INFO(@"inspect bounour model dictionary here");

}

-(void)touchViewDelegate:(VWWTouchView*)sender touchesEndedWithArray:(NSArray*)array{
    [self updateFrequenciesWithArray:array];
    // Mute on touch end
    self.synthesizersController.touchscreenGroup.xSynthesizer.muted = YES;
    self.synthesizersController.touchscreenGroup.ySynthesizer.muted = YES;
}










@end
