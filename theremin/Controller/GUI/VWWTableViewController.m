//
//  VWWTableViewController.m
//  APM Logger
//
//  Created by Zakk Hoyt on 4/12/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWTableViewController.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "UIView+VWW.h"

static NSString *SMSegueDebugSettings = @"VWWSegueDebugSettings";


static vm_size_t get_free_memory() {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        VWW_LOG_ERROR(@"Failed to fetch vm statistics");
        return 0;
    }
    
    return vm_stat.free_count * pagesize;
}



@interface VWWTableViewController ()
@property (nonatomic, strong) NSString *currentStoryboard;
@end

@implementation VWWTableViewController

#pragma mark UIViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view setVWWFonts];
    [self.view layoutSubviews];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#if defined(VWW_SHAKE)
    [self becomeFirstResponder];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
#if defined(VWW_SHAKE)
    [self resignFirstResponder];
#endif
    [super viewWillDisappear:animated];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
#if defined(VWW_DEBUG)
    VWW_LOG_WARNING(@"Memory warning received. %lu free", (unsigned long)get_free_memory());
    //    [SMUtility errorAlert:@"Warning" title:@"Memory warning"];
#endif
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if(segue.destinationViewController == nil){
        VWW_LOG_ERROR(@"View controller doesn't have a segue");
    }
    if([segue.identifier isEqualToString:SMSegueDebugSettings]){
        
    }
}

#pragma mark Shake gesture

-(BOOL)canBecomeFirstResponder {
#if defined(VWW_SHAKE)
    return YES;
#else
    return NO;
#endif
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
#if defined(VWW_SHAKE)
    if (motion == UIEventSubtypeMotionShake){
        VWW_LOG_DEBUG(@"Device shake detected");
        @try {
            [self performSegueWithIdentifier:SMSegueDebugSettings sender:self];
        }
        @catch (NSException *exception) {
            VWW_LOG_WARNING(@"Segue not found: %@", exception);
        }
        
    }
#endif
}

#pragma mark Storyboard


- (void)loadStoryboard:(NSString *)storyboardName animated:(BOOL)animated{
    if ([_currentStoryboard isEqual:storyboardName])
    {
        return;
    }
    
    _currentStoryboard = storyboardName;
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController* rootController = [storyboard instantiateInitialViewController];
    
    if (!animated)
    {
        self.view.window.rootViewController = rootController;
        return;
    }
    
    rootController.view.alpha = 0.0;
    [self.view.window addSubview:rootController.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        rootController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.view.window.rootViewController = rootController;
    }];
}


@end
